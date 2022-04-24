import 'package:flutter/material.dart';
import 'package:lebenswiki_app/components/card_components/creator_info.dart';
import 'package:lebenswiki_app/data/shadows.dart';
import 'package:lebenswiki_app/data/text_styles.dart';
import 'package:lebenswiki_app/views/packs/display_pack.dart';

class PackCard extends StatefulWidget {
  final Map packData;

  const PackCard({
    Key? key,
    required this.packData,
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
            //onTap: () => _displayRoute(),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          DisplayPack(packData: widget.packData)));
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
                      image: NetworkImage(widget.packData["titleImage"]),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, top: 10.0, right: 20.0, bottom: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CreatorInfo(
                        packData: widget.packData,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        widget.packData["title"],
                        style: LebenswikiTextStyles.packTitle,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        widget.packData["description"],
                        style: LebenswikiTextStyles.packDescription,
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

  /*Route _displayRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          DisplayPack(packData: widget.packData),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        final tween = Tween(begin: begin, end: end);
        final offsetAnimation = animation.drive(tween);
        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }*/
}
