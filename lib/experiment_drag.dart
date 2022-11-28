import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class ExperimentDrag extends StatefulWidget {
  const ExperimentDrag({Key? key}) : super(key: key);

  @override
  State<ExperimentDrag> createState() => _ExperimentDragState();
}

class _ExperimentDragState extends State<ExperimentDrag> {
  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color oddItemColor = colorScheme.primary.withOpacity(0.05);
    final Color evenItemColor = colorScheme.primary.withOpacity(0.15);

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              ReorderableListView(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 40),
                children: <Widget>[
                  ListTile(
                    key: Key("One"),
                    title: Text("one"),
                  ),
                  ListTile(
                    key: Key("Two"),
                    title: Text("one"),
                  ),
                  ListTile(
                    key: Key("Three"),
                    title: Text("one"),
                  ),
                  ListTile(
                    key: Key("Four"),
                    title: Text("one"),
                  ),
                ],
                onReorder: (int oldIndex, int newIndex) {
                  /*setState(() {
                    if (oldIndex < newIndex) {
                      newIndex -= 1;
                    }
                    final int item = _items.removeAt(oldIndex);
                    _items.insert(newIndex, item);
                  });*/
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
