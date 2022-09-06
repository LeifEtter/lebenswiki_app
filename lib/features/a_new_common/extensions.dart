import 'package:flutter/material.dart';

extension TextPadding on Text {
  Widget addPadding() => Padding(
        padding: const EdgeInsets.only(left: 25, top: 20, bottom: 20),
        child: this,
      );
}
