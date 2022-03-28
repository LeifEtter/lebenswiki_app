import 'package:flutter/material.dart';
import 'package:lebenswiki_app/data/colors.dart';
import 'package:lebenswiki_app/data/text_styles.dart';

class ReadTime extends StatelessWidget {
  const ReadTime({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      height: 30,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: LebenswikiColors.readTimeBackground),
      child: const Center(
        child: Text(
          "6 MIN READ",
          style: LebenswikiTextStyles.packReadTime,
        ),
      ),
    );
  }
}
