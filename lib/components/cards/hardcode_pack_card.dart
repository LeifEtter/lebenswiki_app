import 'package:flutter/material.dart';
import 'package:lebenswiki_app/components/card_components/creator_info.dart';
import 'package:lebenswiki_app/views/packs_new/hardcode_pack.dart';
import 'package:lebenswiki_app/components/card_components/read_time.dart';
import 'package:lebenswiki_app/data/shadows.dart';
import 'package:lebenswiki_app/data/text_styles.dart';

class HardcodePackCard extends StatefulWidget {
  final List packData;
  final Function reload;

  const HardcodePackCard({
    Key? key,
    required this.packData,
    required this.reload,
  }) : super(key: key);

  @override
  State<HardcodePackCard> createState() => _HardcodePackCardState();
}

class _HardcodePackCardState extends State<HardcodePackCard> {
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
                  builder: (context) => PackPageView(packData: widget.packData),
                ),
              );
            },
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      height: 150,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10.0),
                          topLeft: Radius.circular(10.0),
                        ),
                        image: DecorationImage(
                          fit: BoxFit.fitWidth,
                          image: AssetImage(
                              "assets/images/investieren_pack_image.png"),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      bottom: 10,
                      right: 10,
                      child: Align(
                        child: readTime(),
                        alignment: Alignment.bottomRight,
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 15.0, top: 10.0),
                  child: CreatorInfo(isComment: false, packData: {
                    "creationDate": "19. April 2022T",
                    "creator": {
                      "profileImage":
                          "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8cHJvZmlsZSUyMGltYWdlfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=600&q=60",
                      "name": "Dr. Martina Rebecca",
                    }
                  }),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, top: 0.0, right: 20.0, bottom: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      SizedBox(height: 5),
                      Text(
                        "Investieren",
                        style: LebenswikiTextStyles.packTitle,
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Die Inflation und der Zinseszings Effekt sind nur zwei Gründe fürs Investieren - lerne die Basics.",
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
}
