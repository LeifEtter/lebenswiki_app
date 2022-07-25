import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:lebenswiki_app/features/common/components/styling_edit.dart';
import 'package:lebenswiki_app/features/packs/components/pack_editor_components.dart';
import 'package:lebenswiki_app/features/packs/styling/pack_editor_styling.dart';
import 'package:lebenswiki_app/features/testing/components/border.dart';
import 'package:lebenswiki_app/models/enums.dart';
import 'package:lebenswiki_app/features/packs/models/pack_content_models.dart';

//TODO remove save page button
//TODO Add quiz
class PageOverview extends StatefulWidget {
  final PackPage page;
  final Function saveCallback;
  final int selfIndex;
  final Function deleteSelf;
  final Function saveSelf;

  const PageOverview({
    Key? key,
    required this.page,
    required this.saveCallback,
    required this.selfIndex,
    required this.deleteSelf,
    required this.saveSelf,
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
          left: 20.0, right: 10.0, top: 15.0, bottom: 10.0),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //TODO make button red
              if (widget.selfIndex != 0)
                PackEditorComponents.iconButton(
                    icon: Icons.delete,
                    callback: () => widget.deleteSelf(widget.selfIndex),
                    label: "Seite Löschen"),
              _buildPageContent(),
              const SizedBox(height: 60),
            ],
          ),
          Positioned.fill(
            child: Align(
                alignment: Alignment.bottomRight, child: buildAddButton()),
          ),
          Positioned.fill(
              child: Align(
            alignment: Alignment.bottomLeft,
            child: PackEditorComponents.iconButton(
                icon: Icons.save,
                callback: () => _save(),
                label: "Seite speichern"),
          )),
        ],
      ),
    );
  }

  Widget _buildPageContent() {
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
              Expanded(
                  child: _showSingleEditableItem(page.items[index], index)),
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

  Widget _showSingleEditableItem(PackPageItem item, int index) {
    switch (item.type) {
      case ItemType.list:
        return Column(
          children: [
            Container(
              decoration: PackEditorStyling.standardInput(),
              child: TextFormField(
                  onEditingComplete: _save,
                  controller: item.headContent.controller,
                  decoration: PackEditorStyling.standardDecoration(
                      "Listen Titel eingeben")),
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
                      decoration: PackEditorStyling.standardInput(),
                      child: TextFormField(
                        onEditingComplete: _save,
                        controller: currentInput.controller,
                        decoration: PackEditorStyling.standardDecoration(
                            "Listen Element eingeben"),
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
                  TextEditingController newController = TextEditingController();
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
        );
      case ItemType.title:
        return Container(
          decoration: PackEditorStyling.standardInput(),
          child: TextFormField(
            onEditingComplete: _save,
            controller: item.headContent.controller,
            decoration: PackEditorStyling.standardDecoration("Titel eingeben"),
          ),
        );
      case ItemType.image:
        return Container(
          decoration: PackEditorStyling.standardInput(),
          child: TextFormField(
            onEditingComplete: _save,
            decoration:
                PackEditorStyling.standardDecoration("Bild Link eingeben"),
            controller: item.headContent.controller,
          ),
        );
      case ItemType.text:
        return Container(
          decoration: PackEditorStyling.standardInput(),
          child: TextFormField(
            onEditingComplete: _save,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            minLines: 3,
            controller: item.headContent.controller,
            decoration: PackEditorStyling.standardDecoration("Text eingeben"),
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

    setState(() {});
  }

  //TODO implement saving only that specific page
  //Assign the controller values to the actual values
  void _save() {
    /*for (int x = 0; x < page.items.length; x++) {
      PackPageItem item = page.items[x];

      item.headContent.value = item.headContent.controller!.text;
      for (int y = 0; y < item.bodyContent.length; y++) {
        item.bodyContent[y].value = item.bodyContent[y].controller!.text;
      }
    }*/

    widget.saveSelf(widget.selfIndex);

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
      direction: SpeedDialDirection.left,
      children: items
          .map<SpeedDialChild>((itemData) => SpeedDialChild(
                child: Icon(itemData[1]),
                onTap: () {
                  TextEditingController newController = TextEditingController();

                  newController.text = "";
                  page.items.add(PackPageItem(
                    type: itemData[0],
                    headContent: PackPageItemInput(
                      value: "",
                      controller: newController,
                    ),
                    bodyContent: [],
                  ));
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
