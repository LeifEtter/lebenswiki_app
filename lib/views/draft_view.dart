import 'package:flutter/material.dart';
import 'package:lebenswiki_app/components/feed/get_content.dart';
import 'package:lebenswiki_app/components/navigation/top_nav.dart';
import 'package:lebenswiki_app/data/enums.dart';
import 'package:lebenswiki_app/data/text_styles.dart';
import 'package:lebenswiki_app/testing/border.dart';

class DraftView extends StatefulWidget {
  const DraftView({
    Key? key,
  }) : super(key: key);

  @override
  _DraftViewState createState() => _DraftViewState();
}

class _DraftViewState extends State<DraftView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const TopNav(pageName: "Entwürfe", backName: "Zurück"),
            const SizedBox(height: 20),
            GetContent(
              reload: reload,
              contentType: ContentType.drafts,
            )
          ],
        ),
      ),
    );
  }

  void reload() {
    setState(() {});
  }
}
