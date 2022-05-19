import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:lebenswiki_app/components/create/components/speed_dial.dart';

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
  List pageContent = [];
  List chosenItem = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
                  "titleController": [],
                  "tilesController": [],
                },
                {
                  "key": 1,
                  "type": "LIST",
                  "title": "list title",
                  "tiles": ["something 1", "something 2"],
                  "titleController": [],
                  "tilesController": [],
                },
              ];
              widget.reload();
            },
            child: const Text("reload")),
        _buildPage(),
        buildAddButton(pageContent.length, _speedDialCallback),
        _buildSaveButton(),
      ],
    ));
  }

  Widget _buildPage() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: pageContent.length,
      itemBuilder: (BuildContext context, int index) {
        return _evalContent(pageContent[index]);
      },
    );
  }

  Widget _evalContent(Map element) {
    switch (element["type"]) {
      case "LIST":
        //Reset controllers
        pageContent[element["key"]]["titleController"] = [];
        pageContent[element["key"]]["tilesController"] = [];

        final titleController = TextEditingController();
        titleController.text = element["title"];
        pageContent[element["key"]]["titleController"].add(titleController);
        return Column(
          children: [
            TextFormField(
              controller: titleController,
            ),
            Column(
              children: List.generate(
                element["tiles"].length,
                (index) {
                  final _controller = TextEditingController();
                  _controller.text = element["tiles"][index];
                  pageContent[element["key"]]["tilesController"]
                      .add(_controller);
                  return TextFormField(
                    controller: _controller,
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

  void _speedDialCallback(element) {
    setState(() {
      pageContent.add(element);
    });
  }

  Widget _buildSaveButton() {
    return IconButton(
      icon: const Icon(Icons.save),
      onPressed: () {
        //Save all controller text
        for (var i = 0; i < pageContent.length; i++) {
          switch (pageContent[i]["type"]) {
            case "LIST":
              pageContent[i]["title"] =
                  pageContent[i]["titleController"][0].text;
              pageContent[i]["tiles"] = [];
              for (var controller in pageContent[i]["tilesController"]) {
                pageContent[i]["tiles"].add(controller.text);
              }
          }
        }

        print(pageContent);
      },
    );
  }
}
