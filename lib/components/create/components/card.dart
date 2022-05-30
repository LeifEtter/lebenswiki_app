import 'package:flutter/material.dart';
import 'package:lebenswiki_app/models/creator_pack_model.dart';
import 'package:lebenswiki_app/components/create/views/editor.dart';
import 'package:lebenswiki_app/components/create/views/viewer.dart';
import 'package:lebenswiki_app/data/shadows.dart';
import 'package:lebenswiki_app/data/text_styles.dart';

class CreatorPackCard extends StatefulWidget {
  final CreatorPack pack;

  const CreatorPackCard({
    Key? key,
    required this.pack,
  }) : super(key: key);

  @override
  State<CreatorPackCard> createState() => _CreatorPackCardState();
}

class _CreatorPackCardState extends State<CreatorPackCard> {
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
                      builder: (context) =>
                          CreatorPackViewer(pack: widget.pack)));
            },
            child: Column(
              children: [
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10.0),
                      topLeft: Radius.circular(10.0),
                    ),
                    image: DecorationImage(
                      fit: BoxFit.fitWidth,
                      image: NetworkImage(widget.pack.titleImage),
                    ),
                  ),
                ),
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
                          Container(
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
