import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:lebenswiki_app/components/create/data/models.dart';
import 'package:lebenswiki_app/components/create/styling/styling_edit.dart';
import 'package:lebenswiki_app/testing/border.dart';

class PageOverview extends StatefulWidget {
  final CreatorPage page;
  final Function reload;

  const PageOverview({
    Key? key,
    required this.page,
    required this.reload,
  }) : super(key: key);

  @override
  _PageOverviewState createState() => _PageOverviewState();
}

class _PageOverviewState extends State<PageOverview> {
  late CreatorPage page;
  EditDecoration decoration = EditDecoration();

  @override
  void initState() {
    page = widget.page;
    _initializeControllers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          _buildPage(),
          buildAddButton(),
          _buildSaveButton(),
          TextButton(
            child: const Text("Refresh"),
            onPressed: () {
              setState(() {});
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPage() {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: page.items.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          child: Row(
            children: [
              Expanded(child: _evalContentNew(page.items[index], index)),
              IconButton(
                icon: Icon(Icons.delete),
                color: Colors.red,
                onPressed: () {
                  page.items.removeAt(index);
                  setState(() {});
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _evalContentNew(CreatorItem item, int index) {
    switch (item.type) {
      case ItemType.list:
        return Column(
          children: [
            //Create Head Input
            TextFormField(
              controller: item.headContent.controller,
            ),
            Column(
              children: List.generate(item.bodyContent.length, (index) {
                //Set Current input item
                ItemInput currentInput = item.bodyContent[index];
                return TextFormField(
                  controller: currentInput.controller,
                );
              }),
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                setState(() {
                  TextEditingController newController = TextEditingController();
                  newController.text = "Type here";
                  page.items[index].bodyContent.add(
                    ItemInput(
                      value: "Type here",
                      controller: newController,
                    ),
                  );
                });
              },
            ),
          ],
        );
      case ItemType.title:
        return decoration.title(
          child: TextFormField(
            controller: item.headContent.controller,
          ),
        );
      case ItemType.image:
        return TextFormField(
          controller: item.headContent.controller,
        );
      case ItemType.text:
        return TextFormField(
          keyboardType: TextInputType.multiline,
          maxLines: null,
          controller: item.headContent.controller,
        );
      default:
        return Container();
    }
  }

  //Add Controllers for
  void _initializeControllers() {
    //Loop through all page items
    for (int x = 0; x < page.items.length; x++) {
      CreatorItem item = page.items[x];
      item.headContent.controller = TextEditingController();
      item.headContent.controller!.text = item.headContent.value;

      for (int y = 0; y < item.bodyContent.length; y++) {
        item.bodyContent[y].controller = TextEditingController();
        item.bodyContent[y].controller!.text = item.bodyContent[y].value;
      }
    }
  }

  //Assign the controller values to the actual values
  void _save() {
    for (int x = 0; x < page.items.length; x++) {
      CreatorItem item = page.items[x];

      item.headContent.value = item.headContent.controller!.text;
      for (int y = 0; y < item.bodyContent.length; y++) {
        item.bodyContent[y].value = item.bodyContent[y].controller!.text;
      }
    }
    setState(() {});
  }

  Widget buildAddButton() {
    List<List> items = [
      [ItemType.title, Icons.title],
      [ItemType.list, Icons.list],
      [ItemType.quiz, Icons.question_answer],
      [ItemType.image, Icons.image],
      [ItemType.text, Icons.text_snippet_outlined],
    ];
    return SpeedDial(
      icon: Icons.add_rounded,
      direction: SpeedDialDirection.right,
      children: items
          .map<SpeedDialChild>((item) => SpeedDialChild(
                child: Icon(item[1]),
                onTap: () {
                  TextEditingController newController = TextEditingController();
                  switch (item[0]) {
                    case ItemType.list:
                      newController.text = "Type title here";
                      page.items.add(
                        CreatorItem(
                          type: ItemType.list,
                          headContent: ItemInput(
                            value: "Type title here",
                            controller: newController,
                          ),
                          bodyContent: [],
                        ),
                      );
                      break;
                    case ItemType.title:
                      newController.text = "Enter Title Here";
                      page.items.add(
                        CreatorItem(
                          type: ItemType.title,
                          headContent: ItemInput(
                              value: "Enter Title Here",
                              controller: newController),
                          bodyContent: [],
                        ),
                      );
                      break;
                    case ItemType.image:
                      newController.text = "Enter Image Link Here";
                      page.items.add(CreatorItem(
                        type: ItemType.image,
                        headContent: ItemInput(
                            value: "Enter Image Link Here",
                            controller: newController),
                        bodyContent: [],
                      ));
                      break;
                    case ItemType.text:
                      newController.text = "Enter Text";
                      page.items.add(
                        CreatorItem(
                          type: ItemType.text,
                          headContent: ItemInput(
                            value: "Enter Text",
                            controller: newController,
                          ),
                          bodyContent: [],
                        ),
                      );
                      break;
                  }
                  setState(() {
                    _save();
                    _initializeControllers();
                  });
                },
              ))
          .toList(),
    );
  }

  Widget _buildSaveButton() {
    return IconButton(icon: const Icon(Icons.save), onPressed: () => _save());
  }
}
