import 'package:flutter/material.dart';

class TestingExampleClass {}
/*
class TestingProvider {
  List _
}*/

class TestingView extends StatefulWidget {
  const TestingView({Key? key}) : super(key: key);

  @override
  State<TestingView> createState() => _TestingViewState();
}

class _TestingViewState extends State<TestingView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
    );
  }
}
