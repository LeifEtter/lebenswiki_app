import 'package:flutter/material.dart';
import 'package:lebenswiki_app/features/common/components/top_nav.dart';
import 'package:lebenswiki_app/features/shorts/helper/get_shorts.dart';
import 'package:lebenswiki_app/models/enums.dart';

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
            GetShorts(
              reload: reload,
              cardType: CardType.shortBookmarks,
              menuCallback: () {},
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
