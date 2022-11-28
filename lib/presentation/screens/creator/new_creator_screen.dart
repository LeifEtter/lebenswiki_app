import 'dart:io';
import 'package:either_dart/either.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lebenswiki_app/application/other/image_helper.dart';
import 'package:lebenswiki_app/domain/models/enums.dart';
import 'package:lebenswiki_app/domain/models/error_model.dart';
import 'package:lebenswiki_app/domain/models/pack_content_models.dart';
import 'package:lebenswiki_app/domain/models/pack_model.dart';
import 'package:lebenswiki_app/domain/models/read_model.dart';
import 'package:lebenswiki_app/presentation/providers/providers.dart';
import 'package:lebenswiki_app/presentation/screens/creator/editor_button_row.dart';
import 'package:lebenswiki_app/presentation/screens/creator/item_to_editable_widget.dart';
import 'package:lebenswiki_app/presentation/screens/viewer/view_pack_started.dart';
import 'package:lebenswiki_app/presentation/widgets/interactions/custom_flushbar.dart';
import 'package:lebenswiki_app/presentation/widgets/navigation/top_nav.dart';
import 'package:lebenswiki_app/repository/backend/pack_api.dart';

class NewCreatorScreen extends ConsumerStatefulWidget {
  final Pack pack;

  const NewCreatorScreen({
    Key? key,
    required this.pack,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NewCreatorScreenState();
}

class _NewCreatorScreenState extends ConsumerState<NewCreatorScreen> {
  final FirebaseStorage storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  late ItemToEditableWidget itemToEditableWidget;
  late Pack pack;
  late PackPage currentPage;
  late List<int> pageNumbers;

  bool isOrdering = false;
  double animatedPickerHeight = 0;

  @override
  void initState() {
    pack = widget.pack;
    if (pack.pages.isEmpty) pack.pages.add(PackPage(items: [], pageNumber: 1));
    currentPage = widget.pack.pages.first;
    currentPage.initControllers();
    initPageNumbers();
    itemToEditableWidget = ItemToEditableWidget(
      context: context,
      save: () => currentPage.save(),
      uploadImage: (PackPageItem item) => uploadImage(context, item),
      reload: () => setState(() {}),
      orderingOn: () => _orderingOn(),
    );
    super.initState();
  }

  void initPageNumbers() =>
      pageNumbers = pack.pages.map((PackPage page) => page.pageNumber).toList();

  @override
  Widget build(BuildContext context) {
    itemToEditableWidget.isOrdering = isOrdering;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BackButton(
                    onPressed: () async {
                      await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Verlassen ohne Speichern"),
                          content: const Text(
                              "Willst du wirklich ohne Speichern verlassen?"),
                          actions: [
                            TextButton(
                              child: const Text("Ohne Speichern Verlassen",
                                  style: TextStyle(color: Colors.red)),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            TextButton(
                              child: const Text("Speichern und Verlassen"),
                              onPressed: () {
                                pack.save();
                                _saveToServer();
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      );
                      Navigator.pop(context);
                    },
                  ),
                  Text(
                    "Seiten Bearbeiten (S${currentPage.pageNumber})",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  isOrdering
                      ? TextButton(
                          child: const Text("Sortieren beenden",
                              style: TextStyle(fontWeight: FontWeight.w400)),
                          onPressed: () => _orderingOff())
                      : Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: _popMenuButton(),
                        ),
                ],
              ),
              _buildPageContent(context),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 50),
            child: EditorButtonRow(
              currentPageNumber: currentPage.pageNumber,
              pageNumbers: pageNumbers,
              switchPage: (int newIndex) => _switchPage(newIndex),
              addItem: (ItemType itemType) => _addItem(itemType),
              addPage: () => _addPage(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageContent(context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 100),
      child: ReorderableListView.builder(
        physics: const ClampingScrollPhysics(),
        onReorder: (oldIndex, newIndex) {
          setState(() {
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }
            final PackPageItem item = currentPage.items.removeAt(oldIndex);
            currentPage.items.insert(newIndex, item);
          });
        },
        padding: const EdgeInsets.only(left: 30, right: 20, top: 10),
        shrinkWrap: true,
        itemCount: currentPage.items.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            key: Key('$index'),
            child: itemToEditableWidget.convert(
              item: currentPage.items[index],
              deleteSelf: () {
                currentPage.removeItem(index);
                setState(() {});
              },
            ),
          );
        },
      ),
    );
  }

  void uploadImage(context, PackPageItem item) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      return;
    }
    if (item.headContent.value.isNotEmpty) {
      await storage.refFromURL(item.headContent.value).delete();
    }
    Either<CustomError, String> result = await ImageHelper.uploadImage(
      context,
      pathToStore: "pack_images/${widget.pack.imageIdentifier}/",
      chosenImage: File(pickedFile.path),
      userId: ref.read(userProvider).user.id,
      storage: storage,
    );
    result.fold(
      (left) {
        CustomFlushbar.error(message: left.error).show(context);
      },
      (right) {
        CustomFlushbar.success(message: "Bild erfolgreich hochgeladen")
            .show(context);

        setState(() {
          item.headContent.value = right;
          item.headContent.controller!.text = right;
          currentPage.save();
        });
      },
    );
  }

  void _addItem(ItemType itemType) {
    TextEditingController newController = TextEditingController();
    TextEditingController secondController = TextEditingController();
    newController.text = "";
    secondController.text = "";
    currentPage.items.add(PackPageItem(
      type: itemType,
      headContent: PackPageItemInput(controller: newController),
      bodyContent: itemType == ItemType.list
          ? [PackPageItemInput(controller: secondController)]
          : [],
    ));
    setState(() {
      currentPage.save();
      currentPage.initControllers();
    });
  }

  void _addPage() => setState(() {
        currentPage.save();
        pack.pages.add(PackPage(pageNumber: pack.pages.length + 1, items: []));
        initPageNumbers();
        currentPage = pack.pages.last;
      });

  void _switchPage(int newIndex) {
    currentPage.save();
    _saveToServer();
    currentPage = pack.pages[newIndex - 1];
    currentPage.initControllers();
    setState(() {});
  }

  void _deletePage() {
    if (currentPage.pageNumber != 1) {
      int deleteIndex = currentPage.pageNumber - 1;
      currentPage = pack.pages[deleteIndex - 1];
      pack.pages.removeAt(deleteIndex);
      pack.reassignePageNumbers();
      initPageNumbers();
      setState(() {
        CustomFlushbar.success(message: "Seite Gelöscht").show(context);
      });
    }
  }

  void _toggleOrdering() => isOrdering ? _orderingOff() : _orderingOn();
  void _orderingOn() => setState(() => isOrdering = true);
  void _orderingOff() => setState(() => isOrdering = false);

  void _navigateToPreview() async => await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PackViewerStarted(
            read: Read(id: 0, packId: widget.pack.id!, userId: 0, pack: pack),
            heroName: "",
          ),
        ),
      );

  Future<bool> _saveToServer() async {
    Either<CustomError, String> updateResult =
        await PackApi().updatePack(id: pack.id!, pack: pack);

    if (updateResult.isLeft) {
      CustomFlushbar.error(message: updateResult.left.error).show(context);
      return false;
    } else {
      return true;
    }
  }

  Widget _popMenuButton() {
    List<String> _menuOptions = [
      "Vorschau",
      "Sortieren",
      "Speichern",
      "Speichern und Verlassen",
      "Aktuelle Seite Löschen",
    ];

    return PopupMenuButton(
        onSelected: (value) async {
          switch (value) {
            case "Vorschau":
              pack.save();
              _saveToServer();
              _navigateToPreview();
              break;
            case "Speichern":
              pack.save();
              _saveToServer();
              break;
            case "Sortieren":
              pack.save();
              _toggleOrdering();
              break;
            case "Speichern und Verlassen":
              pack.save();
              bool isSuccessfull = await _saveToServer();
              if (isSuccessfull) {
                Navigator.pop(context);
              }
              break;
            case "Aktuelle Seite Löschen":
              _deletePage();
              _saveToServer();
              initPageNumbers();
              break;
          }
        },
        itemBuilder: (BuildContext context) => _menuOptions
            .map((String option) =>
                PopupMenuItem(child: Text(option), value: option))
            .toList());
  }
}
