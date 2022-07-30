import 'package:flutter/material.dart';
import 'package:lebenswiki_app/api/general/result_model_api.dart';
import 'package:lebenswiki_app/features/shorts/api/short_api.dart';
import 'package:lebenswiki_app/models/enums.dart';
import 'package:lebenswiki_app/features/shorts/models/short_model.dart';
import 'package:lebenswiki_app/repository/text_styles.dart';

class ShortCardMinimal extends StatefulWidget {
  final Short short;
  final CardType cardType;
  final Function reload;

  const ShortCardMinimal({
    Key? key,
    required this.short,
    required this.cardType,
    required this.reload,
  }) : super(key: key);

  @override
  State<ShortCardMinimal> createState() => _ShortCardMinimalState();
}

class _ShortCardMinimalState extends State<ShortCardMinimal> {
  bool _isExpanded = false;
  late ShortApi shortApi;

  @override
  void initState() {
    shortApi = ShortApi();
    super.initState();
  }

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
                            widget.short.title,
                            style: LebenswikiTextStyles.packTitle,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            widget.short.content,
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
                        icon: const Icon(Icons.arrow_back_ios_new_rounded),
                      ),
                    )
                  ],
                ),
              ),
              Visibility(
                visible: _isExpanded,
                child: _buildActionMenu(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionMenu() {
    return Column(
      children: [
        const Divider(),
        SizedBox(
          height: 50,
          child: Padding(
            padding:
                const EdgeInsets.only(left: 25.0, right: 25.0, bottom: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Transform.rotate(
                    angle: widget.cardType == CardType.shortDrafts ? 0 : 3.13,
                    child: const Icon(
                      Icons.publish,
                      size: 30.0,
                    ),
                  ),
                  onPressed: () {
                    widget.cardType == CardType.shortDrafts
                        ? shortApi
                            .publishShort(widget.short.id)
                            .then((ResultModel result) {
                            widget.reload();
                          })
                        : shortApi
                            .unpublishShort(widget.short.id)
                            .then((ResultModel result) {
                            widget.reload();
                          });
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.delete,
                    size: 30.0,
                  ),
                  onPressed: () {
                    shortApi
                        .deleteShort(id: widget.short.id)
                        .then((ResultModel result) {
                      widget.reload();
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
