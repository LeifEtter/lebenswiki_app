import 'dart:io';

import 'package:either_dart/either.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lebenswiki_app/application/image_helper.dart';
import 'package:lebenswiki_app/domain/models/error_model.dart';
import 'package:lebenswiki_app/presentation/providers/providers.dart';
import 'package:lebenswiki_app/presentation/widgets/creator/styling_edit.dart';
import 'package:lebenswiki_app/domain/models/enums.dart';
import 'package:lebenswiki_app/domain/models/pack_content_models.dart';
import 'package:lebenswiki_app/presentation/widgets/interactions/custom_flushbar.dart';
import 'package:lebenswiki_app/repository/constants/shadows.dart';

class PageOverview extends ConsumerStatefulWidget {
  final PackPage page;
  final Function saveCallback;
  final int selfIndex;
  final Function deleteSelf;
  final Function saveSelf;

  const PageOverview({
    Key? key,
    required this.page,
    required this.saveCallback,
    required this.selfIndex,
    required this.deleteSelf,
    required this.saveSelf,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PageOverviewState();
}

class _PageOverviewState extends ConsumerState<PageOverview> {
  final FirebaseStorage storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();
  late PackPage page;
  EditDecoration decoration = EditDecoration();

  @override
  void initState() {
    page = widget.page;
    _initializeControllers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildPageContent(context),
        Positioned.fill(
          bottom: 40,
          right: 40,
          child:
              Align(alignment: Alignment.bottomRight, child: buildAddButton()),
        ),
      ],
    );
  }

  Widget _buildPageContent(context) {
    return ListView.builder(
      padding: const EdgeInsets.only(left: 30, right: 20, top: 10),
      shrinkWrap: true,
      itemCount: page.items.length,
      itemBuilder: (BuildContext context, int index) {
        return Row(
          children: [
            Expanded(
                child:
                    _showSingleEditableItem(context, page.items[index], index)),
            IconButton(
              icon: const Icon(Icons.delete),
              color: Colors.red.shade400,
              onPressed: () {
                page.items.removeAt(index);
                setState(() {});
              },
            ),
          ],
        );
      },
    );
  }

  Widget _showSingleEditableItem(
      BuildContext context, PackPageItem item, int index) {
    switch (item.type) {
      case ItemType.list:
        return Column(
          children: [
            Container(
              //decoration: PackEditorStyling.standardInput(),
              child: TextFormField(
                onEditingComplete: _save,
                controller: item.headContent.controller,
                /*decoration: PackEditorStyling.standardDecoration(
                      "Listen Titel eingeben")*/
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Column(
                children: List.generate(item.bodyContent.length, (index) {
                  //Set Current input item
                  PackPageItemInput currentInput = item.bodyContent[index];
                  return Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            //decoration: PackEditorStyling.standardInput(),
                            child: TextFormField(
                              onEditingComplete: _save,
                              controller: currentInput.controller,
                              /*decoration: PackEditorStyling.standardDecoration(
                                  "Listen Element eingeben"),*/
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          color: Colors.red.shade200,
                          onPressed: () {
                            item.bodyContent.removeAt(index);
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                setState(() {
                  TextEditingController newController = TextEditingController();
                  newController.text = "";
                  page.items[index].bodyContent.add(
                    PackPageItemInput(
                      value: "",
                      controller: newController,
                    ),
                  );
                });
              },
            ),
          ],
        );
      case ItemType.title:
        return Container(
          child: TextFormField(
            onEditingComplete: _save,
            controller: item.headContent.controller,
            //decoration: PackEditorStyling.standardDecoration("Titel eingeben"),
          ),
        );
      case ItemType.image:
        return GestureDetector(
          onTap: () => upload(context, item),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              boxShadow: [LebenswikiShadows.fancyShadow],
              color: Colors.white,
              image: item.headContent.value.isNotEmpty
                  ? DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        item.headContent.value,
                      ))
                  : null,
            ),
            width: double.infinity,
            height: 200,
            child: item.headContent.value.isNotEmpty
                ? Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(255, 255, 255, 0.6),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Text(
                        "Bild Ändern",
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ),
                  )
                : Center(
                    child: Text(
                    "Wähle ein Bild",
                    style: Theme.of(context).textTheme.labelSmall,
                  )),
          ),
        );
      case ItemType.text:
        return Container(
          //decoration: PackEditorStyling.standardInput(),
          child: TextFormField(
            onEditingComplete: _save,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            minLines: 3,
            controller: item.headContent.controller,
            //decoration: PackEditorStyling.standardDecoration("Text eingeben"),
          ),
        );
      default:
        return Container();
    }
  }

  //Add Controllers for
  void _initializeControllers() {
    //Loop through all page items
    for (int x = 0; x < page.items.length; x++) {
      PackPageItem item = page.items[x];
      item.headContent.controller = TextEditingController();
      item.headContent.controller!.text = item.headContent.value;

      for (int y = 0; y < item.bodyContent.length; y++) {
        item.bodyContent[y].controller = TextEditingController();
        item.bodyContent[y].controller!.text = item.bodyContent[y].value;
      }
    }

    setState(() {});
  }

  void _save() {
    widget.saveSelf(widget.selfIndex);
    setState(() {});
  }

  Widget buildAddButton() {
    List<List> items = [
      [ItemType.title, Icons.title, "Titel"],
      [ItemType.list, Icons.list, "Liste"],
      [ItemType.quiz, Icons.question_answer, "Fragen"],
      [ItemType.image, Icons.image, "Bild"],
      [ItemType.text, Icons.text_snippet_outlined, "Text"],
    ];
    return SpeedDial(
      icon: Icons.add_rounded,
      direction: SpeedDialDirection.left,
      children: items
          .map<SpeedDialChild>((itemData) => SpeedDialChild(
                child: Icon(itemData[1]),
                labelWidget: Padding(
                    child: Text(itemData[2]),
                    padding: const EdgeInsets.only(left: 10, right: 10)),
                onTap: () {
                  TextEditingController newController = TextEditingController();
                  newController.text = "";
                  page.items.add(PackPageItem(
                    type: itemData[0],
                    headContent: PackPageItemInput(
                      value: "",
                      controller: newController,
                    ),
                    bodyContent: [],
                  ));
                  setState(() {
                    _save();
                    _initializeControllers();
                  });
                },
              ))
          .toList(),
    );
  }

  void upload(context, PackPageItem item) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      return;
    }
    if (item.headContent.value.isNotEmpty) {
      await storage.refFromURL(item.headContent.value).delete();
    }
    Either<CustomError, String> result = await ImageHelper.uploadImage(context,
        chosenImage: File(pickedFile.path),
        userId: ref.read(userProvider).user.id,
        storage: storage);
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
          _save();
        });
      },
    );
  }
}
