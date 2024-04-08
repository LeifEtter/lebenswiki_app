import 'package:flutter/material.dart';

class DropDownItem {
  final int id;
  final String name;

  DropDownItem({required this.id, required this.name});
}

class CustomDropDownMenu extends StatelessWidget {
  final DropDownItem chosenValue;
  final List<DropDownItem> items;
  final Function onPress;
  final double borderRadius;
  final List<BoxShadow>? shadows;

  const CustomDropDownMenu({
    Key? key,
    required this.chosenValue,
    required this.onPress,
    required this.items,
    this.borderRadius = 15.0,
    this.shadows,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.only(left: 20.0, right: 20.0, top: 5, bottom: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: Colors.white,
        boxShadow: shadows,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<DropDownItem>(
          borderRadius: BorderRadius.circular(borderRadius),
          value: chosenValue,
          items: items
              .map<DropdownMenuItem<DropDownItem>>(
                  (DropDownItem item) => DropdownMenuItem(
                        value: item,
                        child: Text(item.name),
                      ))
              .toList(),
          onChanged: (DropDownItem? newValue) => onPress(newValue),
        ),
      ),
    );
  }
}
