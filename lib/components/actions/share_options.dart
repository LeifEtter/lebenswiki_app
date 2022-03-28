import 'package:flutter/material.dart';

class ShareOptions extends StatelessWidget {
  final Function shareCallback;
  final Function bookmarkCallback;

  const ShareOptions({
    Key? key,
    required this.shareCallback,
    required this.bookmarkCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      height: 65,
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 1.0, color: Color.fromRGBO(240, 240, 240, 1)),
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset("assets/icons/share_icon.png", width: 28),
          SizedBox(width: 20.0),
          Image.asset("assets/icons/bookmark.png", width: 18),
        ],
      ),
    );
  }
}
