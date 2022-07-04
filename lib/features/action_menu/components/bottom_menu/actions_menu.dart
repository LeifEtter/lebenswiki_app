import 'package:flutter/material.dart';

void showActionsMenu(BuildContext context, {required List<Widget> menuItems}) {
  showModalBottomSheet(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
    context: context,
    builder: (context) {
      return Container(
        height: 300,
        padding: const EdgeInsets.only(top: 20.0, left: 30.0),
        child: Column(
          children: List.from(menuItems),
        ),
      );
    },
    isDismissible: true,
  );
}
