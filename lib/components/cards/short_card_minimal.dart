import 'package:flutter/material.dart';
import 'package:lebenswiki_app/api/api_shorts.dart';
import 'package:lebenswiki_app/data/enums.dart';
import 'package:lebenswiki_app/data/text_styles.dart';

class ShortCardMinimal extends StatefulWidget {
  final Map packData;
  final ContentType contentType;
  final Function reload;

  const ShortCardMinimal({
    Key? key,
    required this.packData,
    required this.contentType,
    required this.reload,
  }) : super(key: key);

  @override
  State<ShortCardMinimal> createState() => _ShortCardMinimalState();
}

class _ShortCardMinimalState extends State<ShortCardMinimal> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(top: 10, bottom: 10, left: 10.0, right: 10.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 5,
        child: IntrinsicHeight(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.packData["title"],
                            style: LebenswikiTextStyles.packTitle,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            widget.packData["content"],
                            style: LebenswikiTextStyles.packDescription,
                          ),
                        ],
                      ),
                    ),
                    Transform.rotate(
                      angle: _isExpanded ? 4.7 : 0,
                      child: IconButton(
                          onPressed: () {
                            setState(() {
                              _isExpanded
                                  ? _isExpanded = false
                                  : _isExpanded = true;
                            });
                          },
                          icon: Icon(Icons.arrow_back_ios_new_rounded)),
                    )
                  ],
                ),
              ),
              Visibility(
                visible: _isExpanded,
                child: Column(
                  children: [
                    Divider(),
                    Container(
                      height: 50,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 25.0, right: 25.0, bottom: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Visibility(
                              visible: widget.contentType == ContentType.drafts,
                              child: IconButton(
                                icon: Transform.rotate(
                                  angle:
                                      widget.contentType == ContentType.drafts
                                          ? 0
                                          : 3.13,
                                  child: const Icon(
                                    Icons.publish,
                                    size: 30.0,
                                  ),
                                ),
                                onPressed: () {
                                  publishShort(widget.packData["id"])
                                      .whenComplete(() => widget.reload(0));
                                },
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete,
                                size: 30.0,
                              ),
                              onPressed: () {
                                removeShort(widget.packData["id"])
                                    .whenComplete(() => widget.reload(0));
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
