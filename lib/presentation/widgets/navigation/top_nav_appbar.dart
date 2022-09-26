import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TopNavIOSAppBar extends StatelessWidget implements PreferredSizeWidget {
  final AppBar appBar;
  final String rightText;
  final Function rightAction;
  final String title;

  const TopNavIOSAppBar({
    Key? key,
    required this.appBar,
    required this.rightText,
    required this.rightAction,
    required this.title,
  }) : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 2,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Colors.black,
        ),
      ),
      backgroundColor: Colors.white,
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.black,
        ),
      ),
      actions: [
        CupertinoButton(
          child: Text(rightText),
          onPressed: () => rightAction(),
        )
      ],
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(appBar.preferredSize.height);
}
