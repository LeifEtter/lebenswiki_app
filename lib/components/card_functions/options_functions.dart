import 'package:flutter/material.dart';

Widget buildOptionsMenu(userId, triggerOptionsMenu, showReportDialog) {
  return Positioned.fill(
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              triggerOptionsMenu();
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  IconButton(
                    onPressed: () {
                      showReportDialog();
                    },
                    icon: Icon(Icons.flag, size: 40.0),
                  ),
                  const Text("Report Short"),
                ],
              )
            ],
          )
        ],
      ),
    ),
  );
}
