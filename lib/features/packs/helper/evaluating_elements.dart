import 'package:flutter/material.dart';
import 'package:lebenswiki_app/models/enums.dart';
import 'package:lebenswiki_app/features/packs/models/pack_content_models.dart';

Widget evalPageElement(PackPageItem item) {
  switch (item.type) {
    case ItemType.list:
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.headContent.value,
            style: const TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          ListView.builder(
            padding: const EdgeInsets.only(left: 10.0, top: 5.0),
            shrinkWrap: true,
            itemCount: item.bodyContent.length,
            itemBuilder: (BuildContext context, int index) {
              return buildListItem(item.bodyContent[index].value);
            },
          ),
          const SizedBox(height: 10),
        ],
      );
    case ItemType.title:
      return Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Text(
          item.headContent.value,
          style: const TextStyle(
            fontSize: 25.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    case ItemType.image:
      return Padding(
        padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
        child: Image.network(
          item.headContent.value,
          fit: BoxFit.contain,
          height: 250,
        ),
      );
    case ItemType.text:
      return Text(
        item.headContent.value,
        style: const TextStyle(fontSize: 18),
      );
    default:
      return const Text("Widget couldn't be identified");
  }
}

Widget buildListItem(value) {
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
          value,
        ),
      ),
    ],
  );
}
