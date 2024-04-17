import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TopNavIOSAppBar extends StatelessWidget implements PreferredSizeWidget {
  final AppBar appBar;
  final String rightText;
  final Function rightAction;
  final String title;
  final Function? leftAction;

  const TopNavIOSAppBar({
    Key? key,
    required this.appBar,
    required this.rightText,
    required this.rightAction,
    required this.title,
    this.leftAction,
  }) : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 2,
      leading: IconButton(
        onPressed: () async {
          await leftAction?.call();
          context.pop();
        },
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
  Size get preferredSize => Size.fromHeight(appBar.preferredSize.height);
}
