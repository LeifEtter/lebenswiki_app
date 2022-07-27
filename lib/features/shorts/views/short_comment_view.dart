import 'package:flutter/material.dart';
import 'package:lebenswiki_app/features/common/components/nav/top_nav.dart';
import 'package:lebenswiki_app/features/shorts/models/short_model.dart';

//TODO finish comment view
class ShortCommentView extends StatefulWidget {
  final Short short;

  const ShortCommentView({
    Key? key,
    required this.short,
  }) : super(key: key);

  @override
  State<ShortCommentView> createState() => _ShortCommentViewState();
}

class _ShortCommentViewState extends State<ShortCommentView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const TopNav(pageName: "Kommentare", backName: "Shorts"),
        ListView(
          children: [
            
          ],
        ),
      ],
    );
  }
}
