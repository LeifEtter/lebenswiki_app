import 'package:flutter/material.dart';
import 'package:lebenswiki_app/components/pack/1-template_page.dart';

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
      body: PageTemplate(
        pageData: pageData,
        reload: _reload,
      ),
    );
  }

  void _reload() {
    setState(() {
      pageData.add("");
    });
  }
}
