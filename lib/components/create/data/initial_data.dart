import 'package:flutter/material.dart';
import 'package:lebenswiki_app/components/create/data/models.dart';

CreatorPack initialPack() {
  return CreatorPack(
    title: "",
    description: "",
    pages: [examplePage()],
    categories: [1],
    titleImage: "",
    published: false,
  );
}

CreatorPage examplePage() {
  return CreatorPage(pageNumber: 1, items: [
    CreatorItem(
      type: ItemType.list,
      headContent: ItemInput(
        value: "",
      ),
      bodyContent: [],
    ),
  ]);
}
