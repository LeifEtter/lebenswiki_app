import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

Widget buildAddButton(pageContentLength, callback) {
  return SpeedDial(
    icon: Icons.add_rounded,
    direction: SpeedDialDirection.right,
    children: [
      SpeedDialChild(
        child: const Icon(Icons.list),
        onTap: () => callback({
          "key": pageContentLength,
          "type": "LIST",
          "title": "Titel",
          "tiles": ["something"],
          "controller": [],
        }),
      ),
      SpeedDialChild(
        child: const Icon(Icons.title),
        onTap: () => callback({
          "key": pageContentLength,
          "type": "LIST",
          "title": "Titel",
          "tiles": ["something"],
        }),
      ),
      SpeedDialChild(
        child: const Icon(Icons.image),
        onTap: () => callback({
          "key": pageContentLength,
          "type": "IMAGE",
          "src": "Image Path",
        }),
      ),
      SpeedDialChild(
        child: const Icon(Icons.text_fields),
        onTap: () => callback({
          "key": pageContentLength,
          "type": "TEXT",
          "content": "content",
        }),
      ),
      SpeedDialChild(
        child: const Icon(Icons.quiz),
      ),
    ],
  );
}
