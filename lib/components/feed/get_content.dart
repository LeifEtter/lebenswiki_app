import 'package:flutter/material.dart';
import 'package:lebenswiki_app/api/api_shorts.dart';
import 'package:lebenswiki_app/api/api_posts.dart';
import 'package:lebenswiki_app/api/api_universal.dart';
import 'package:lebenswiki_app/components/cards/short_card_minimal.dart';
import 'package:lebenswiki_app/components/cards/short_card_scaffold.dart';
import 'package:lebenswiki_app/components/create/api/api_creator_pack.dart';
import 'package:lebenswiki_app/components/create/components/card.dart';
import 'package:lebenswiki_app/components/create/components/card_edit.dart';
import 'package:lebenswiki_app/models/creator_pack_model.dart';
import 'package:lebenswiki_app/data/example_data.dart';
import 'package:lebenswiki_app/data/loading.dart';
import 'package:lebenswiki_app/data/enums.dart';

class GetContent extends StatefulWidget {
  final int category;
  final Function reload;
  final CardType contentType;
  final Function(MenuType, Map) menuCallback;

  const GetContent({
    Key? key,
    this.category = 0,
    required this.reload,
    required this.contentType,
    required this.menuCallback,
  }) : super(key: key);

  @override
  _GetContentState createState() => _GetContentState();
}

class _GetContentState extends State<GetContent> {
  bool provideCategory = false;
  String errorText = "";
  late Function packFuture;
  late Widget card;

  @override
  Widget build(BuildContext context) {
    _updateParameters();
    return FutureBuilder(
      future: getBlocked(),
      builder: (context, AsyncSnapshot blockedList) {
        if (!blockedList.hasData) {
          return const Loading();
        } else {
          return FutureBuilder(
            future: packFuture(provideCategory ? widget.category : ""),
            builder: (context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return const Loading();
              } else if ((snapshot.data.isEmpty) |
                  (snapshot.data[1].length == 0)) {
                return Center(
                  child: Text(errorText),
                );
              } else {
                //If Category is new (categoryId: 99) then sort packs by creation date
                /*if (widget.category == 99 && snapshot.data[1].length > 1) {
                  snapshot.data[1] = _sortPacks(snapshot.data[1]);
                }*/
                widget.category == 99
                    ? snapshot.data[1] = _sortPacks(snapshot.data[1])
                    : null;
                //Filter out all blocked shorts
                snapshot.data[1] =
                    _filterBlocked(snapshot.data[1], blockedList.data);
                return Expanded(
                  child: ListView.builder(
                    addAutomaticKeepAlives: true,
                    shrinkWrap: true,
                    itemCount: snapshot.data[1].length,
                    itemBuilder: (context, index) {
                      var currentPack = snapshot.data[1][index];
                      switch (widget.contentType) {
                        case CardType.shortsByCategory:
                          return ShortCardScaffold(
                            packData: currentPack,
                            voteReload: widget.reload,
                            contentType: widget.contentType,
                            menuCallback: widget.menuCallback,
                          );
                        case CardType.shortBookmarks:
                          return ShortCardScaffold(
                            packData: currentPack,
                            voteReload: widget.reload,
                            contentType: widget.contentType,
                            menuCallback: widget.menuCallback,
                          );
                        case CardType.drafts:
                          return ShortCardMinimal(
                            reload: widget.reload,
                            packData: currentPack,
                            contentType: widget.contentType,
                          );
                        case CardType.yourShorts:
                          return ShortCardMinimal(
                            reload: widget.reload,
                            packData: currentPack,
                            contentType: widget.contentType,
                          );
                        case CardType.creatorPacks:
                          return CreatorPackCard(
                              pack: CreatorPack.fromJson(currentPack));
                        case CardType.yourCreatorPacks:
                          return CreatorPackCardEdit(
                            pack: CreatorPack.fromJson(currentPack),
                            reload: widget.reload,
                          );
                        case CardType.yourCreatorPacksPublished:
                          return CreatorPackCardEdit(
                            pack: CreatorPack.fromJson(currentPack),
                            reload: widget.reload,
                          );
                        default:
                          return const Center(
                            child: Text("No Data"),
                          );
                      }
                    },
                  ),
                );
              }
            },
          );
        }
      },
    );
  }

  List _sortPacks(packList) {
    packList.sort((a, b) {
      return DateTime.parse(a["creationDate"])
          .compareTo(DateTime.parse(b["creationDate"]));
    });
    packList = List.from(packList.reversed);
    return packList;
  }

  List _filterBlocked(packList, blockedList) {
    List<Map> filteredPackList = [];
    bool canAdd = true;

    for (Map pack in packList) {
      canAdd = true;
      for (Map report in blockedList) {
        for (Map blocked in report["blocked"]) {
          if (blocked["id"] == pack["creatorId"]) {
            canAdd = false;
            break;
          }
        }
      }
      canAdd ? filteredPackList.add(pack) : null;
    }
    return filteredPackList;
  }

  void _updateParameters() {
    switch (widget.contentType) {
      case CardType.packsByCategory:
        packFuture = widget.category == 99 ? getAllPosts : getPostsByCategory;
        provideCategory = true;
        errorText = "Keine Packs für diese Kategorie gefunden";
        break;
      case CardType.shortsByCategory:
        packFuture = widget.category == 99 ? getAllShorts : getShortsByCategory;
        provideCategory = widget.category == 99 ? false : true;
        errorText = "Keine Shorts für diese Kategorie gefunden";
        break;
      case CardType.shortBookmarks:
        packFuture = getBookmarkedShorts;
        errorText = "Du hast noch keine Shorts gespeichert";
        break;
      case CardType.packBookmarks:
        packFuture = getBookmarkedShorts;
        errorText = "Du hast noch keine Packs gespeichert";
        break;
      case CardType.drafts:
        packFuture = getDrafts;
        errorText = "Du hast noch keine Shorts entworfen";
        break;
      case CardType.yourShorts:
        packFuture = getCreatorShorts;
        errorText = "Du hast noch keine Shorts veröffentlicht";
        break;
      case CardType.yourCreatorPacks:
        packFuture = getYourCreatorPacks;
        errorText = "Du hast noch keine Lernpacks veröffentlicht";
        break;
      case CardType.draftCreatorPacks:
        packFuture = () {};
        errorText = "Du hast noch keine Lernpacks entworfen";
        break;
      case CardType.yourCreatorPacksPublished:
        packFuture = getYourCreatorPacksPublished;
        errorText = "Du hast noch keine Lernpacks veröffentlicht";
        break;
      case CardType.creatorPacks:
        packFuture = getCreatorPacks;
        errorText = "Wir haben keine Lernpacks für diese Kategorie gefunden";
        break;
      default:
        break;
    }
  }
}
