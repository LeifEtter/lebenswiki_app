import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:lebenswiki_app/features/styling/styling_edit.dart';
import 'package:lebenswiki_app/features/styling/shadows.dart';
import 'package:lebenswiki_app/models/enums.dart';
import 'package:lebenswiki_app/models/pack_content_models.dart';

class PageOverview extends StatefulWidget {
  final CreatorPage page;
  final Function reload;
  final Function saveCallback;
  final int selfIndex;

  const PageOverview({
    Key? key,
    required this.page,
    required this.reload,
    required this.saveCallback,
    required this.selfIndex,
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
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  _save();
                },
                child: Container(
                  width: 200,
                  height: 40,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [LebenswikiShadows().fancyShadow]),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text("Seite Speichern  ",
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500,
                          )),
                      Icon(Icons.save),
                    ],
                  ),
                ),
              ),
            ],
          ),
          _buildPage(),
          const SizedBox(height: 20),
          buildAddButton(),
          const SizedBox(height: 30.0),
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
        return Row(
          children: [
            Expanded(child: _evalContentNew(page.items[index], index)),
            IconButton(
              icon: const Icon(Icons.delete),
              color: Colors.red,
              onPressed: () {
                page.items.removeAt(index);
                setState(() {});
              },
            ),
          ],
        );
      },
    );
  }

  Widget _evalContentNew(CreatorItem item, int index) {
    switch (item.type) {
      case ItemType.list:
        return Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Column(
            children: [
              //Create Head Input
              Container(
                decoration: _standardInput(),
                child: TextFormField(
                    onEditingComplete: _save,
                    controller: item.headContent.controller,
                    decoration: _standardDecoration("Listen Titel eingeben")),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 50.0),
                child: Column(
                  children: List.generate(item.bodyContent.length, (index) {
                    //Set Current input item
                    ItemInput currentInput = item.bodyContent[index];
                    return Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Container(
                        decoration: _standardInput(),
                        child: TextFormField(
                          onEditingComplete: _save,
                          controller: currentInput.controller,
                          decoration:
                              _standardDecoration("Listen Element eingeben"),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  setState(() {
                    TextEditingController newController =
                        TextEditingController();
                    newController.text = "";
                    page.items[index].bodyContent.add(
                      ItemInput(
                        value: "",
                        controller: newController,
                      ),
                    );
                  });
                },
              ),
            ],
          ),
        );
      case ItemType.title:
        return Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Container(
            decoration: _standardInput(),
            child: TextFormField(
              onEditingComplete: _save,
              controller: item.headContent.controller,
              decoration: _standardDecoration("Titel eingeben"),
            ),
          ),
        );
      case ItemType.image:
        return Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Container(
            decoration: _standardInput(),
            child: TextFormField(
              onEditingComplete: _save,
              decoration: _standardDecoration("Bild Link eingebe"),
              controller: item.headContent.controller,
            ),
          ),
        );
      case ItemType.text:
        return Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Container(
            decoration: _standardInput(),
            child: TextFormField(
              onEditingComplete: _save,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              minLines: 3,
              controller: item.headContent.controller,
              decoration: _standardDecoration("Text eingeben"),
            ),
          ),
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

  BoxDecoration _standardInput() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(10.0),
      boxShadow: [LebenswikiShadows().fancyShadow],
      color: Colors.white,
    );
  }

  InputDecoration _standardDecoration(placeholder) {
    return InputDecoration(
      border: InputBorder.none,
      contentPadding: const EdgeInsets.all(10.0),
      hintText: placeholder,
    );
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
    //widget.saveCallback(page: page, index: widget.selfIndex);
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
                      newController.text = "";
                      page.items.add(
                        CreatorItem(
                          type: ItemType.list,
                          headContent: ItemInput(
                            value: "",
                            controller: newController,
                          ),
                          bodyContent: [],
                        ),
                      );
                      break;
                    case ItemType.title:
                      newController.text = "";
                      page.items.add(
                        CreatorItem(
                          type: ItemType.title,
                          headContent:
                              ItemInput(value: "", controller: newController),
                          bodyContent: [],
                        ),
                      );
                      break;
                    case ItemType.image:
                      newController.text = "";
                      page.items.add(CreatorItem(
                        type: ItemType.image,
                        headContent:
                            ItemInput(value: "", controller: newController),
                        bodyContent: [],
                      ));
                      break;
                    case ItemType.text:
                      newController.text = "";
                      page.items.add(
                        CreatorItem(
                          type: ItemType.text,
                          headContent: ItemInput(
                            value: "",
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
