import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lebenswiki_app/repository/text_styles.dart';
import 'package:lebenswiki_app/models/user_model.dart';

class CreatorInfo extends StatelessWidget {
  final User user;
  final DateTime creationDate;
  final bool isComment;

  const CreatorInfo({
    Key? key,
    required this.user,
    required this.creationDate,
    required this.isComment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: NetworkImage(user.profileImage),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 5.0),
        Text(
          "${isComment ? "Kommentar" : "Artikel"} von ${user.name} | ${DateFormat("yMMMd").format(creationDate)}",
          style: LebenswikiTextStyles.publisherInfo,
        ),
      ],
    );
  }
}
