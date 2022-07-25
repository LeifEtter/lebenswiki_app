import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lebenswiki_app/features/common/components/cards/creator_info.dart';
import 'package:lebenswiki_app/features/packs/api/pack_api.dart';
import 'package:lebenswiki_app/features/packs/models/pack_model.dart';
import 'package:lebenswiki_app/features/packs/views/pack_viewer.dart';
import 'package:lebenswiki_app/models/user_model.dart';
import 'package:lebenswiki_app/providers/providers.dart';
import 'package:lebenswiki_app/repository/shadows.dart';
import 'package:lebenswiki_app/repository/text_styles.dart';

class PackCard extends ConsumerStatefulWidget {
  final Pack pack;

  const PackCard({
    Key? key,
    required this.pack,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PackCardState();
}

class _PackCardState extends ConsumerState<PackCard> {
  late User user;
  PackApi packApi = PackApi();

  @override
  Widget build(BuildContext context) {
    user = ref.read(userProvider).user;
    return Padding(
      padding:
          const EdgeInsets.only(top: 10, bottom: 10, left: 10.0, right: 10.0),
      child: Container(
        decoration: BoxDecoration(boxShadow: [
          LebenswikiShadows.cardShadow,
        ]),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 0,
          child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PackViewer(pack: widget.pack)));
            },
            child: Stack(
              children: [
                Column(
                  children: [
                    Container(
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(10.0),
                          topLeft: Radius.circular(10.0),
                        ),
                        image: DecorationImage(
                          fit: BoxFit.fitWidth,
                          image: NetworkImage(widget.pack.titleImage),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, top: 10.0, right: 20.0, bottom: 20.0),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CreatorInfo(
                                isComment: false,
                                user: widget.pack.creator!,
                                creationDate: widget.pack.creationDate,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                widget.pack.title,
                                style: LebenswikiTextStyles.packTitle,
                              ),
                              const SizedBox(height: 5),
                              SizedBox(
                                width: 350,
                                child: Text(
                                  widget.pack.description,
                                  style: LebenswikiTextStyles.packDescription,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [LebenswikiShadows.fancyShadow],
                      ),
                      child: IconButton(
                        onPressed: () {
                          widget.pack.bookmarkedByUser
                              ? packApi.unbookmarkPack(widget.pack.id)
                              : packApi.bookmarkPack(widget.pack.id);
                          widget.pack.toggleBookmarked(user);
                          setState(() {});
                        },
                        icon: Icon(
                          widget.pack.bookmarkedByUser
                              ? Icons.bookmark
                              : Icons.bookmark_outline,
                          size: 25.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
