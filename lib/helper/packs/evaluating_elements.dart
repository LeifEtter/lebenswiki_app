import 'package:flutter/material.dart';

Widget evalPageElement(element) {
  switch (element["type"]) {
    case "LIST":
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            element["title"],
            style: const TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          ListView.builder(
            padding: const EdgeInsets.only(left: 10.0, top: 5.0),
            shrinkWrap: true,
            itemCount: element["listItems"].length,
            itemBuilder: (BuildContext context, int index) {
              return buildListItem(element["listItems"][index]);
            },
          ),
          const SizedBox(height: 10),
        ],
      );
    case "TITLE":
      return Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Text(
          element["title"],
          style: const TextStyle(
            fontSize: 25.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    case "IMAGE":
      return Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Image.asset(
          element["src"],
          fit: BoxFit.fitHeight,
          height: 250,
        ),
      );
    case "TEXT":
      return Text(element["text"]);
    default:
      return const Text("Widget couldn't be identified");
  }
}

Widget buildListItem(listItemData) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        "•",
        style: TextStyle(
          fontSize: 25.0,
          height: 0.9,
        ),
      ),
      const SizedBox(width: 2.0),
      Expanded(
        child: Text(
          listItemData,
        ),
      ),
    ],
  );
}
