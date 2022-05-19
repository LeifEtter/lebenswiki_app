import 'package:flutter/material.dart';
import 'package:lebenswiki_app/components/create/page_creation.dart';
import 'package:lebenswiki_app/components/create/test_firebase.dart';

class TestParent extends StatefulWidget {
  const TestParent({Key? key}) : super(key: key);

  @override
  _TestParentState createState() => _TestParentState();
}

class _TestParentState extends State<TestParent> {
  List pageData = [""];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FireBaseTest(),
    );
  }

  void _reload() {
    setState(() {
      pageData.add("");
    });
  }
}
