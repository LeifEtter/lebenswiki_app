import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:lebenswiki_app/features/common/components/styling_edit.dart';
import 'package:lebenswiki_app/features/testing/components/border.dart';
import 'package:lebenswiki_app/models/enums.dart';
import 'package:lebenswiki_app/features/packs/models/pack_content_models.dart';
import 'package:lebenswiki_app/repository/shadows.dart';

class PageOverview extends StatefulWidget {
  final PackPage page;
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
  late PackPage page;
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
      padding: const EdgeInsets.only(
          left: 20.0, right: 20.0, top: 10.0, bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 5),
          GiveBorder(
            color: Colors.red,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 15.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      )),
                  icon: const Icon(Icons.save),
                  onPressed: () => _save(),
                  label: const Text("Seite Speichern",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                      )),
                ),
              ],
            ),
          ),
          GiveBorder(
            color: Colors.green,
            child: _buildPage(),
          ),
          buildAddButton(),
        ],
      ),
    );
  }

  Widget _buildPage() {
    return ListView.builder(
      padding: const EdgeInsets.all(0),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: page.items.length,
      itemBuilder: (BuildContext context, int index) {
        return GiveBorder(
          color: Colors.blue,
          child: Row(
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
          ),
        );
      },
    );
  }

  Widget _evalContentNew(PackPageItem item, int index) {
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
                padding: const EdgeInsets.only(left: 20.0),
                child: Column(
                  children: List.generate(item.bodyContent.length, (index) {
                    //Set Current input item
                    PackPageItemInput currentInput = item.bodyContent[index];
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
                      PackPageItemInput(
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
          padding: const EdgeInsets.only(top: 20),
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
              decoration: _standardDecoration("Bild Link eingeben"),
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
      PackPageItem item = page.items[x];
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
      PackPageItem item = page.items[x];

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
                        PackPageItem(
                          type: ItemType.list,
                          headContent: PackPageItemInput(
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
                        PackPageItem(
                          type: ItemType.title,
                          headContent: PackPageItemInput(
                              value: "", controller: newController),
                          bodyContent: [],
                        ),
                      );
                      break;
                    case ItemType.image:
                      newController.text = "";
                      page.items.add(PackPageItem(
                        type: ItemType.image,
                        headContent: PackPageItemInput(
                            value: "", controller: newController),
                        bodyContent: [],
                      ));
                      break;
                    case ItemType.text:
                      newController.text = "";
                      page.items.add(
                        PackPageItem(
                          type: ItemType.text,
                          headContent: PackPageItemInput(
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
}
