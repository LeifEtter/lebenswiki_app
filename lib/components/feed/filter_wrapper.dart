import 'package:flutter/material.dart';

class FilterWrapper extends StatefulWidget {
  final List<Map> filterMap;
  final Widget child;

  const FilterWrapper({
    Key? key,
    required this.filterMap,
    required this.child,
  }) : super(key: key);

  @override
  _FilterWrapperState createState() => _FilterWrapperState();
}

class _FilterWrapperState extends State<FilterWrapper> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.child,
    );
  }
}

class CC extends StatefulWidget {
  const CC({Key? key}) : super(key: key);

  @override
  _CCState createState() => _CCState();
}

class _CCState extends State<CC> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [FilterWrapper(filterMap: [], child: Container())],
      ),
    );
  }
}
