import 'package:flutter/material.dart';
import 'package:lebenswiki_app/domain/models/pack/pack_page.model.dart';

class ViewableWidgetStyling {
  TextStyle get title => const TextStyle();
}

class ItemToViewableWidget {
  Widget toViewableItem(PackPageItem item) {
    switch (item.type) {
      case ItemType.list:
        return _listWidget(item);
      case ItemType.title:
        return _titleWidget(item);
      case ItemType.image:
        return _imageWidget(item);
      case ItemType.text:
        return _textWidget(item);
      case ItemType.quiz:
        return Container();
    }
  }

  Widget _titleWidget(PackPageItem item) => Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Text(
          item.headContent.value,
          style: const TextStyle(
            fontSize: 25.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      );

  Widget _listWidget(PackPageItem item) => Column(
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
                      _buildListItem(input.value))
                  .toList(),
            ),
          ),
          const SizedBox(height: 10),
        ],
      );

  Widget _buildListItem(value) {
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
        Expanded(child: Text(value)),
      ],
    );
  }

  Widget _imageWidget(PackPageItem item) => Padding(
        padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
        child: Image.network(
          item.headContent.value.replaceAll("https", "http"),
          fit: BoxFit.contain,
          height: 250,
        ),
      );

  Widget _textWidget(PackPageItem item) => Text(
        item.headContent.value,
        style: const TextStyle(fontSize: 18),
      );
}
