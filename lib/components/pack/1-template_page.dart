import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class PageTemplate extends StatefulWidget {
  final List pageData;
  final Function reload;

  const PageTemplate({
    Key? key,
    required this.pageData,
    required this.reload,
  }) : super(key: key);

  @override
  _PageTemplateState createState() => _PageTemplateState();
}

class _PageTemplateState extends State<PageTemplate> {
  List pageContent = [
    {
      "key": 0,
      "type": "LIST",
      "title": "list title",
      "tiles": ["something 1", "something 2"],
    },
    {
      "key": 0,
      "type": "LIST",
      "title": "list title",
      "tiles": ["something 1", "something 2"],
    }
  ];
  List chosenItem = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        const SizedBox(height: 50),
        TextButton(
            onPressed: () {
              pageContent = [
                {
                  "key": 0,
                  "type": "LIST",
                  "title": "list title",
                  "tiles": ["something 1", "something 2"],
                },
                {
                  "key": 1,
                  "type": "LIST",
                  "title": "list title",
                  "tiles": ["something 1", "something 2"],
                }
              ];
              widget.reload();
            },
            child: const Text("reload")),
        _buildListTemplate(),
      ],
    ));
  }

  Widget _buildListTemplate() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: pageContent.length,
      itemBuilder: (BuildContext context, int index) {
        return evalContent(pageContent[index]);
      },
    );
  }

  Widget _inputStyling(child) {
    return Container();
  }

  Widget evalContent(Map element) {
    print("New eval call: $element");
    switch (element["type"]) {
      case "LIST":
        return Column(
          children: [
            TextFormField(
              initialValue: element["title"],
            ),
            Column(
              children: List.generate(
                element["tiles"].length,
                (index) {
                  print("index");
                  return TextFormField(
                    initialValue: element["tiles"][index],
                    onChanged: (String? value) {
                      chosenItem = [element["key"], index, value];
                    },
                  );
                },
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  pageContent[element["key"]]["tiles"].add("enter");
                });
              },
              icon: const Icon(Icons.add),
            ),
          ],
        );
      default:
        return Container();
    }
  }
}
