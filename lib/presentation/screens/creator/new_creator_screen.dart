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
    );
    super.initState();
  }

  void initPageNumbers() =>
      pageNumbers = pack.pages.map((PackPage page) => page.pageNumber).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          ListView(
            children: [
              TopNavIOS(
                title: "Seiten Bearbeiten (S${currentPage.pageNumber})",
                nextTitle: "Vorschau",
                nextFunction: () {
                  pack.save();
                  _saveToServer();
                  pack.id = 0;
                  _navigateToPreview();
                },
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
    return ListView.builder(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.only(left: 30, right: 20, top: 10),
      shrinkWrap: true,
      itemCount: currentPage.items.length,
      itemBuilder: (BuildContext context, int index) {
        return itemToEditableWidget.convert(
          item: currentPage.items[index],
          deleteSelf: () {
            currentPage.removeItem(index);
            setState(() {});
          },
        );
      },
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

  void _switchPage(int newIndex) => setState(() {
        currentPage.save();
        currentPage = pack.pages[newIndex - 1];
      });

  void _navigateToPreview() => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PackViewerStarted(
          read: Read(id: 0, packId: widget.pack.id!, userId: 0, pack: pack),
          heroName: "",
        ),
      ));

  void _saveToServer() async {
    Either<CustomError, String> updateResult =
        await PackApi().updatePack(id: pack.id!, pack: pack);
    updateResult.fold((left) {
      CustomFlushbar.error(message: left.error).show(context);
    }, (right) {
      CustomFlushbar.success(message: right).show(context);
    });
  }
}
