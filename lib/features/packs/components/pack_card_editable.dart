import 'package:flutter/material.dart';
import 'package:lebenswiki_app/api/general/result_model_api.dart';
import 'package:lebenswiki_app/features/common/components/buttons/buttons.dart';
import 'package:lebenswiki_app/features/packs/api/pack_api.dart';
import 'package:lebenswiki_app/features/packs/models/pack_model.dart';
import 'package:lebenswiki_app/features/packs/views/pack_creator_information.dart';
import 'package:lebenswiki_app/features/snackbar/components/custom_flushbar.dart';
import 'package:lebenswiki_app/models/enums.dart';
import 'package:lebenswiki_app/repository/shadows.dart';
import 'package:lebenswiki_app/repository/text_styles.dart';

class PackCardEdit extends StatefulWidget {
  final Pack pack;
  final Function reload;
  final bool isPublished;

  const PackCardEdit({
    Key? key,
    required this.pack,
    required this.reload,
    this.isPublished = false,
  }) : super(key: key);

  @override
  State<PackCardEdit> createState() => _PackCardEditState();
}

class _PackCardEditState extends State<PackCardEdit> {
  PackApi packApi = PackApi();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(top: 10, bottom: 10, left: 10.0, right: 10.0),
      child: Container(
        decoration: BoxDecoration(boxShadow: [
          LebenswikiShadows.cardShadow,
        ]),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 0,
          child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          PackCreatorInformation(pack: widget.pack)));
            },
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(10.0),
                          topLeft: Radius.circular(10.0),
                        ),
                        image: DecorationImage(
                          fit: BoxFit.fitWidth,
                          image: NetworkImage(widget.pack.titleImage),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.topRight,
                        child: widget.isPublished
                            ? Transform.rotate(
                                angle: 3.14,
                                child: LebenswikiButtons.iconButton
                                    .roundEdgesWhite(
                                  callback: () async {
                                    await packApi
                                        .unpublishPack(widget.pack.id)
                                        .then((ResultModel result) {
                                      if (result.type == ResultType.success) {
                                        CustomFlushbar.success(
                                                message:
                                                    "Lernpack von veröffentlichten entfernt!")
                                            .show(context);
                                        widget.reload();
                                      } else {
                                        CustomFlushbar.error(
                                                message:
                                                    "Dafür hast du keine Rechte")
                                            .show(context);
                                      }
                                    });
                                  },
                                  icon: const Icon(Icons.publish),
                                ),
                              )
                            : LebenswikiButtons.iconButton.roundEdgesWhite(
                                callback: () async {
                                  await packApi
                                      .publishPack(widget.pack.id)
                                      .then((ResultModel result) {
                                    if (result.type == ResultType.success) {
                                      CustomFlushbar.success(
                                              message:
                                                  "Lernpack veröffentlicht!")
                                          .show(context);
                                      widget.reload();
                                    } else {
                                      CustomFlushbar.error(
                                              message:
                                                  "Dafür hast du keine Rechte")
                                          .show(context);
                                    }
                                  });
                                },
                                icon: const Icon(Icons.publish),
                              ),
                      ),
                    ),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: LebenswikiButtons.iconButton.roundEdgesWhite(
                          callback: () async {
                            await showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (BuildContext context) => AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0)),
                                title: const Text("Lernpack löschen"),
                                content: const Text(
                                    "Willst du das Lernpack wirklich löschen?"),
                                actions: [
                                  TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(true),
                                      child: const Text("Löschen")),
                                  TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      child: const Text("Abbrechen")),
                                ],
                              ),
                            ).then((confirmed) {
                              if (confirmed) {
                                packApi
                                    .deletePack(widget.pack.id)
                                    .then((ResultModel result) {
                                  if (result.type == ResultType.success) {
                                    CustomFlushbar.success(
                                            message: "Lernpack gelöscht")
                                        .show(context);
                                  } else {
                                    CustomFlushbar.error(
                                            message:
                                                "Lernpack konnte nicht gelöscht werden")
                                        .show(context);
                                  }
                                  widget.reload();
                                });
                              }
                            });
                          },
                          icon: const Icon(Icons.delete),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, top: 10.0, right: 20.0, bottom: 20.0),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 5),
                          Text(
                            widget.pack.title,
                            style: LebenswikiTextStyles.packTitle,
                          ),
                          const SizedBox(height: 5),
                          SizedBox(
                            width: 350,
                            child: Text(
                              widget.pack.description,
                              style: LebenswikiTextStyles.packDescription,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
