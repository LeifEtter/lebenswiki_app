import 'package:flutter/material.dart';
import 'package:lebenswiki_app/presentation/constants/colors.dart';

class InfoLabel extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final double fontSize;
  final Icon? icon;
  final double? borderRadius;
  final TextStyle? textStyle;

  const InfoLabel({
    Key? key,
    required this.text,
    required this.backgroundColor,
    this.fontSize = 13,
    this.icon,
    this.borderRadius,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 2),
            child: icon ?? Container(),
          ),
          Text(
            text,
            style: textStyle ??
                Theme.of(context).textTheme.labelSmall!.copyWith(
                      letterSpacing: 0.5,
                      fontSize: fontSize,
                    ),
          ),
        ],
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius ?? 15.0),
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
  final double textSize;

  const InfoBar({
    Key? key,
    required this.items,
    this.textSize = 13,
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
            child: Text(
              item.text!,
              style: TextStyle(
                fontSize: textSize,
              ),
            ),
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
                    Text(item.indicator!,
                        style: TextStyle(
                          fontSize: textSize,
                        )),
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
        rowItemsNew.add(Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: _buildVerticalDivider(horizontalPadding: 0),
        ));
      }
    }

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        children: rowItemsNew,
      ),
    );
  }

  Widget _buildVerticalDivider({required double horizontalPadding}) => Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: Container(
          color: CustomColors.darkGrey,
          width: 1,
          height: double.infinity,
        ),
      );
}
