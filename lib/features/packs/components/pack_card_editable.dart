import 'package:flutter/material.dart';
import 'package:lebenswiki_app/api/pack_api.dart';
import 'package:lebenswiki_app/models/pack_model.dart';
import 'package:lebenswiki_app/features/packs/views/pack_creator_settings.dart';
import 'package:lebenswiki_app/repository/shadows.dart';
import 'package:lebenswiki_app/repository/text_styles.dart';

class PackCardEdit extends StatefulWidget {
  final Pack pack;
  final Function reload;

  const PackCardEdit({
    Key? key,
    required this.pack,
    required this.reload,
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
          LebenswikiShadows().cardShadow,
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
                    builder: (context) => EditorSettings(pack: widget.pack)),
              );
            },
            child: Column(
              children: [
                Stack(
                  children: [
                    widget.pack.titleImage != ""
                        ? Container(
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
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 150,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10.0),
                                    topLeft: Radius.circular(10.0),
                                  ),
                                ),
                                child: const Center(
                                    child: Text("Füge ein bild hinzu")),
                              ),
                            ],
                          ),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                          onTap: () {
                            packApi.publishPack(widget.pack.id);
                            widget.reload();
                          },
                          child: Container(
                            width: 50,
                            height: 50,
                            child: const Icon(Icons.publish),
                            decoration: BoxDecoration(
                              boxShadow: [LebenswikiShadows().fancyShadow],
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: GestureDetector(
                          onTap: () {
                            packApi.deletePack(widget.pack.id);
                            widget.reload();
                          },
                          child: Container(
                            width: 50,
                            height: 50,
                            child: const Icon(Icons.delete),
                            decoration: BoxDecoration(
                              boxShadow: [LebenswikiShadows().fancyShadow],
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                widget.pack.titleImage == ""
                    ? const Divider(
                        thickness: 2,
                      )
                    : Container(),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, top: 10.0, right: 20.0, bottom: 20.0),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /*CreatorInfo(
                            isComment: false,
                            packData: widget.packData,
                          ),*/
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
