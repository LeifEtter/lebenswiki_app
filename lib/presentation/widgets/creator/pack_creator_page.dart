import 'dart:io';

import 'package:either_dart/either.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lebenswiki_app/application/other/image_helper.dart';
import 'package:lebenswiki_app/application/data/pack_conversion.dart';
import 'package:lebenswiki_app/domain/models/error_model.dart';
import 'package:lebenswiki_app/presentation/providers/providers.dart';
import 'package:lebenswiki_app/presentation/widgets/creator/styling_edit.dart';
import 'package:lebenswiki_app/domain/models/enums.dart';
import 'package:lebenswiki_app/domain/models/pack_content_models.dart';
import 'package:lebenswiki_app/presentation/widgets/interactions/custom_flushbar.dart';

class PageOverview extends ConsumerStatefulWidget {
  final int packId;
  final String imageIdentifier;
  final PackPage page;
  final int selfIndex;
  final Function deleteSelf;

  const PageOverview({
    Key? key,
    required this.packId,
    required this.imageIdentifier,
    required this.page,
    required this.selfIndex,
    required this.deleteSelf,
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
    page.initControllers();
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
                child: PackConversion.itemToWidget(
              context,
              item: page.items[index],
              reload: () => setState(() {}),
              index: index,
              removeSelf: () => setState(() {
                TextEditingController newController = TextEditingController();
                newController.text = "";
                page.items[index].bodyContent.add(
                  PackPageItemInput(
                    value: "",
                    controller: newController,
                  ),
                );
              }),
              save: () => _save(),
              uploadCallback: (BuildContext context, PackPageItem item) =>
                  upload(context, item),
            )),
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

  void _save() {
    widget.page.save();
    setState(() {});
  }

  Widget buildAddButton() {
    List<List> items = [
      [ItemType.title, Icons.title, "Titel"],
      [ItemType.list, Icons.list, "Liste"],
      //TODO Add Questions to options
      /*[ItemType.quiz, Icons.question_answer, "Fragen"],*/
      [ItemType.image, Icons.image, "Bild"],
      [ItemType.text, Icons.text_snippet_outlined, "Text"],
    ];
    return SpeedDial(
      icon: Icons.add_rounded,
      direction: SpeedDialDirection.up,
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
                    page.initControllers();
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
    Either<CustomError, String> result = await ImageHelper.uploadImage(
      context,
      pathToStore: "pack_images/${widget.imageIdentifier}/",
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
          _save();
        });
      },
    );
  }
}
