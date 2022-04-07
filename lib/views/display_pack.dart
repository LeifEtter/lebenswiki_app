import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:lebenswiki_app/components/actions/share_options.dart';
import 'package:lebenswiki_app/components/buttons/main_buttons.dart';
import 'package:lebenswiki_app/components/cards/creator_info.dart';
import 'package:lebenswiki_app/data/text_styles.dart';
import 'package:quill_markdown/quill_markdown.dart';
import 'package:markdown/markdown.dart' as md;

class DisplayPack extends StatefulWidget {
  final Map packData;

  const DisplayPack({
    Key? key,
    required this.packData,
  }) : super(key: key);

  @override
  _DisplayPackState createState() => _DisplayPackState();
}

class _DisplayPackState extends State<DisplayPack> {
  @override
  Widget build(BuildContext context) {
    var markdown = quillToMarkdown(widget.packData["content"])!;
    return Scaffold(
      body: Stack(
        children: [
          ListView(
            shrinkWrap: true,
            children: [
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  CloseButton(),
                ],
              ),
              const SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Text(
                  widget.packData["title"],
                  style: LebenswikiTextStyles.shortContent.displayShortTitle,
                ),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Text(
                  widget.packData["description"],
                  style:
                      LebenswikiTextStyles.shortContent.displayShortDescription,
                ),
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: CreatorInfo(packData: widget.packData),
              ),
              const SizedBox(height: 25),
              Container(
                height: 180,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(widget.packData["titleImage"])),
                ),
              ),
              Container(
                child: Markdown(
                  shrinkWrap: true,
                  data: markdown,
                  physics: const NeverScrollableScrollPhysics(),
                ),
              ),
            ],
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomRight,
              child: ShareOptions(
                shareCallback: () {},
                bookmarkCallback: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}
