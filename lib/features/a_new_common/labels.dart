import 'package:flutter/material.dart';
import 'package:lebenswiki_app/features/a_new_widget_repo/colors.dart';
import 'package:lebenswiki_app/repository/shadows.dart';
import 'package:emojis/emoji.dart';

class InfoLabel extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final double fontSize;
  final Icon? icon;

  const InfoLabel({
    Key? key,
    required this.text,
    required this.backgroundColor,
    this.fontSize = 13,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon ?? Container(),
          Text(
            text,
            style: Theme.of(context).textTheme.labelSmall!.copyWith(
                  letterSpacing: 0.5,
                  fontSize: fontSize,
                ),
          ),
        ],
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: backgroundColor,
      ),
    );
  }
}

enum InfoItemType {
  text,
  iconLabel,
}

class InfoItem {
  late InfoItemType type;
  final Function? onPress;
  final String? text;
  final Icon? icon;
  final String? indicator;
  final String? emoji;

  InfoItem.forIconLabel({
    required this.onPress,
    this.icon,
    required this.indicator,
    this.emoji,
    this.text,
  }) {
    type = InfoItemType.iconLabel;
  }

  InfoItem.forText({
    required this.text,
    this.onPress,
    this.icon,
    this.indicator,
    this.emoji,
  }) {
    type = InfoItemType.text;
  }
}

class InfoBar extends StatelessWidget {
  final List<InfoItem> items;
  final double width;
  final double height;

  const InfoBar({
    Key? key,
    required this.items,
    this.width = 180,
    this.height = 35,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> rowItems = items.map<Widget>((InfoItem item) {
      Widget child;
      switch (item.type) {
        case InfoItemType.text:
          child = Center(
            child: Text(item.text!),
          );
          break;
        case InfoItemType.iconLabel:
          child = GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => item.onPress!(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    item.emoji != null
                        ? Text(item.emoji!)
                        : Padding(
                            padding: const EdgeInsets.only(top: 2.0),
                            child: item.icon,
                          ),
                    const SizedBox(width: 5),
                    Text(item.indicator!),
                  ],
                ),
              ],
            ),
          );
      }
      return Expanded(
        child: child,
      );
    }).toList();
    List<Widget> rowItemsNew = [];
    for (int i = 0; i < rowItems.length; i++) {
      rowItemsNew.add(rowItems[i]);
      if (i != rowItems.length - 1) {
        rowItemsNew.add(_buildVerticalDivider(horizontalPadding: 3));
      }
    }

    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.white,
          boxShadow: [LebenswikiShadows.fancyShadow]),
      child: Row(
        children: rowItemsNew,
      ),
    );
  }

  Widget _buildVerticalDivider({required double horizontalPadding}) => Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: Container(
          color: CustomColors.lightGrey,
          width: 2,
          height: 25,
        ),
      );
}
