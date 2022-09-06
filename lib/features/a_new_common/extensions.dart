import 'package:flutter/material.dart';

extension TextPadding on Text {
  Widget addPadding() => Padding(
        padding: const EdgeInsets.only(left: 20, top: 20),
        child: this,
      );
}
