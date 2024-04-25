import 'package:flutter/material.dart';
import 'package:lebenswiki_app/domain/models/pack/pack_page.model.dart';

class PackConversion {
  static Widget toViewableItem(PackPageItem item) {
    switch (item.type) {
      case ItemType.list:
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.headContent.value,
                style: const TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 7, top: 4),
                child: Column(
                  children: item.bodyContent
                      .map((PackPageItemContent input) =>
                          buildListItem(input.value))
                      .toList(),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      case ItemType.title:
        return Padding(
          padding: const EdgeInsets.only(bottom: 10.0, top: 10.0),
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
            item.headContent.value.replaceAll("https", "http"),
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

  static Widget buildListItem(value) {
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
}
