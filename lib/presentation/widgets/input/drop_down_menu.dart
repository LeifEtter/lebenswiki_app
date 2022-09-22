import 'package:flutter/material.dart';

class CustomDropDownMenu extends StatelessWidget {
  final String chosenValue;
  final Function onPress;
  final List<String> items;
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
        child: DropdownButton<String>(
          borderRadius: BorderRadius.circular(borderRadius),
          value: chosenValue,
          items: items
              .map<DropdownMenuItem<String>>((String value) => DropdownMenuItem(
                    value: value,
                    child: Text(value),
                  ))
              .toList(),
          onChanged: (String? newValue) => onPress(newValue),
        ),
      ),
    );
  }
}
