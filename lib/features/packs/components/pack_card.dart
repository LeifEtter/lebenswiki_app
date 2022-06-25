import 'package:flutter/material.dart';
import 'package:lebenswiki_app/models/pack_model.dart';
import 'package:lebenswiki_app/features/packs/views/viewer.dart';
import 'package:lebenswiki_app/features/styling/shadows.dart';
import 'package:lebenswiki_app/features/styling/text_styles.dart';

class PackCard extends StatefulWidget {
  final Pack pack;
  final Function reload;

  const PackCard({
    Key? key,
    required this.pack,
    required this.reload,
  }) : super(key: key);

  @override
  State<PackCard> createState() => _PackCardState();
}

class _PackCardState extends State<PackCard> {
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
                      builder: (context) => PackViewer(pack: widget.pack)));
            },
            child: Column(
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
