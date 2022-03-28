import 'package:flutter/material.dart';
import 'package:lebenswiki_app/api/api_universal.dart';
import 'package:lebenswiki_app/components/feed/get_content.dart';
import 'package:lebenswiki_app/components/input/input_styling.dart';
import 'package:lebenswiki_app/components/navigation/top_nav.dart';
import 'package:lebenswiki_app/data/colors.dart';
import 'package:lebenswiki_app/data/loading.dart';
import 'package:lebenswiki_app/data/text_styles.dart';
import 'package:lebenswiki_app/data/enums.dart';

class BookmarkFeed extends StatefulWidget {
  final bool isShort;
  final bool isSearching;

  const BookmarkFeed({
    Key? key,
    required this.isShort,
    required this.isSearching,
  }) : super(key: key);

  @override
  _BookmarkFeedState createState() => _BookmarkFeedState();
}

class _BookmarkFeedState extends State<BookmarkFeed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const TopNav(pageName: "Gespeichert", backName: "Menu"),
            const SizedBox(height: 30),
            GetContent(
              reload: reload,
              contentType: ContentType.shortBookmarks,
            ),
          ],
        ),
      ),
    );
  }

  void reload() {
    setState(() {});
  }
}
