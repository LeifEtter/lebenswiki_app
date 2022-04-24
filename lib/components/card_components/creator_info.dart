import 'package:flutter/material.dart';
import 'package:lebenswiki_app/data/text_styles.dart';

class CreatorInfo extends StatelessWidget {
  final Map packData;

  const CreatorInfo({
    Key? key,
    required this.packData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var creationDateUnformatted = packData["creationDate"].split("T");
    var creationDate = creationDateUnformatted[0];
    return Row(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: NetworkImage(packData["creator"]["profileImage"]),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 5.0),
        Text(
          "Artikel von ${packData["creator"]["name"]} | $creationDate",
          style: LebenswikiTextStyles.publisherInfo,
        ),
      ],
    );
  }
}
