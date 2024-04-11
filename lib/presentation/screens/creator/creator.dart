import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lebenswiki_app/application/routing/router.dart';
import 'package:lebenswiki_app/domain/models/error.model.dart';
import 'package:lebenswiki_app/domain/models/pack/pack_page.model.dart';
import 'package:lebenswiki_app/domain/models/pack/pack.model.dart';
import 'package:lebenswiki_app/presentation/constants/shadows.dart';
import 'package:lebenswiki_app/presentation/screens/creator/editor_button_row.dart';
import 'package:lebenswiki_app/presentation/screens/creator/item_to_editable_widget.dart';
import 'package:lebenswiki_app/presentation/widgets/interactions/custom_flushbar.dart';
import 'package:lebenswiki_app/data/pack_api.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

class Creator extends ConsumerStatefulWidget {
  final Pack pack;

  const Creator({
    super.key,
    required this.pack,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreatorScreenState();
}

class _CreatorScreenState extends ConsumerState<Creator> {
  final ImagePicker picker = ImagePicker();

  late ItemToEditableWidget itemToEditableWidget;
  late Pack pack;
  late PackPage currentPage;
  late List<int> pageNumbers;

  bool isOrdering = false;
  double animatedPickerHeight = 0;

  @override
  void initState() {
    pack = widget.pack;
    if (pack.pages.isEmpty) {
      pack.pages.add(PackPage(id: uuid.v4(), items: [], pageNumber: 1));
    }
    pack.orderPages();
    pack.orderItems();
    currentPage = widget.pack.pages.first;
    currentPage.initControllers();
    initPageNumbers();
    itemToEditableWidget = ItemToEditableWidget(
      context: context,
      save: () => currentPage.save(),
      uploadImage: _uploadImage,
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
                                onPressed: () => Navigator.pushNamed(
                                    context, createdViewRoute)),
                            TextButton(
                              child: const Text("Speichern und Verlassen"),
                              onPressed: () {
                                pack.save();
                                _saveToServer();
                                Navigator.pushNamed(context, createdViewRoute);
                              },
                            ),
                          ],
                        ),
                      );
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
              currentPage.items.isEmpty
                  ? _buildPageChooseSetting(context)
                  : _buildPageContent(context),
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

  Widget _buildPageChooseSetting(context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 50, bottom: 20),
          child: Text(
            "Wähle den Seiten Typ aus",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 18.0,
            ),
          ),
        ),
        _buildSelectButton("Info", "assets/icons/info_mark_in_circle.svg",
            () => {print("Selected Info")}),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text(
            "oder",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
          ),
        ),
        _buildSelectButton("Quiz", "assets/icons/question_mark_in_circle.svg",
            () => {print("Selected Quiz")}),
      ],
    );
  }

  Widget _buildSelectButton(
      String title, String icon, void Function() onPressed) {
    return TextButton(
      onPressed: onPressed,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [LebenswikiShadows.fancyShadow],
          borderRadius: const BorderRadius.all(Radius.circular(20.0)),
          color: const Color.fromRGBO(119, 140, 249, 1),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
          child: Column(
            children: [
              SvgPicture.asset(
                width: 30.0,
                icon,
                colorFilter:
                    const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
              Text(
                title,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
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

  void _addItem(ItemType itemType) {
    TextEditingController newController = TextEditingController();
    TextEditingController secondController = TextEditingController();
    newController.text = "";
    secondController.text = "";
    currentPage.items.add(PackPageItem(
      position: currentPage.items.length,
      id: uuid.v4(),
      type: itemType,
      headContent:
          PackPageItemContent(controller: newController, id: uuid.v4()),
      bodyContent: itemType == ItemType.list
          ? [PackPageItemContent(controller: secondController, id: uuid.v4())]
          : [],
    ));
    setState(() {
      currentPage.save();
      currentPage.initControllers();
    });
  }

  void _uploadImage(PackPageItem item) async {
    XFile? file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      Either<CustomError, String> uploadResult = await PackApi()
          .uploadItemImage(
              pathToImage: file.path, packId: pack.id!, itemId: item.id);
      if (uploadResult.isLeft) {
        CustomFlushbar.error(message: uploadResult.left.error).show(context);
      } else {
        setState(() {
          item.headContent.value = uploadResult.right;
          item.headContent.controller!.text = uploadResult.right;
          currentPage.save();
        });
        CustomFlushbar.success(message: "Bild Hochgeladen").show(context);
      }
    }
  }

  void _addPage() => setState(() {
        currentPage.save();
        pack.pages.add(PackPage(
            id: uuid.v4(), pageNumber: pack.pages.length + 1, items: []));
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
      pack.reassignPageNumbers();
      initPageNumbers();
      setState(() {
        CustomFlushbar.success(message: "Seite Gelöscht").show(context);
      });
    }
  }

  void _toggleOrdering() => isOrdering ? _orderingOff() : _orderingOn();
  void _orderingOn() => setState(() => isOrdering = true);
  void _orderingOff() => setState(() => isOrdering = false);

  // void _navigateToPreview() async => await Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => PackViewerStarted(
  //           packId: pack.id,
  //           heroName: "",
  //         ),
  //       ),
  //     );

  Future<bool> _saveToServer() async {
    Either<CustomError, String> updateResult =
        await PackApi().updatePages(pack.pages, pack.id!);
    if (updateResult.isLeft) {
      CustomFlushbar.error(message: updateResult.left.error).show(context);
      return false;
    } else {
      CustomFlushbar.success(message: updateResult.right).show(context);
      return true;
    }
  }

  Widget _popMenuButton() {
    List<String> menuOptions = [
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
              // _navigateToPreview();
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
              bool isSuccessful = await _saveToServer();
              if (isSuccessful) {
                Navigator.pushNamed(context, "/created");
              }
              break;
            case "Aktuelle Seite Löschen":
              _deletePage();
              _saveToServer();
              initPageNumbers();
              break;
          }
        },
        itemBuilder: (BuildContext context) => menuOptions
            .map((String option) =>
                PopupMenuItem(value: option, child: Text(option)))
            .toList());
  }
}
