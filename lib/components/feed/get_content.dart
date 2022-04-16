import 'package:flutter/material.dart';
import 'package:lebenswiki_app/api/api_shorts.dart';
import 'package:lebenswiki_app/api/api_posts.dart';
import 'package:lebenswiki_app/api/api_universal.dart';
import 'package:lebenswiki_app/components/cards/pack_card.dart';
import 'package:lebenswiki_app/components/cards/short_card.dart';
import 'package:lebenswiki_app/components/cards/short_card_minimal.dart';
import 'package:lebenswiki_app/components/cards/short_card_scaffold.dart';
import 'package:lebenswiki_app/data/loading.dart';
import 'package:lebenswiki_app/data/enums.dart';

class GetContent extends StatefulWidget {
  final int category;
  final Function reload;
  final ContentType contentType;
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
  bool isShort = false;
  bool provideCategory = false;
  String errorText = "";
  Function packFuture = () {};
  Widget card = Container();

  @override
  Widget build(BuildContext context) {
    _updateParameters();
    return FutureBuilder(
      future: getBlocked(),
      builder: (context, AsyncSnapshot blockedList) {
        if (!blockedList.hasData) {
          return Loading();
        } else {
          return FutureBuilder(
            future: packFuture(provideCategory ? widget.category : ""),
            builder: (context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return Loading();
              } else if ((snapshot.data.isEmpty) |
                  (snapshot.data[1].length == 0)) {
                return Center(
                  child: Text(errorText),
                );
              } else {
                //Fix Null error when switching screens
                /*if ((snapshot.data[0] == "short") &&
                        (widget.contentType == ContentType.packsByCategory) ||
                    ((snapshot.data[0] == "packs") &&
                        (widget.contentType == ContentType.shortsByCategory))) {
                  return Loading();
                }*/
                //If Category is new (categoryId: 99) then sort packs by creation date
                if (widget.category == 99 && snapshot.data[1].length > 1) {
                  snapshot.data[1] = _sortPacks(snapshot.data[1]);
                }
                //Filter out all blocked shorts
                snapshot.data[1] =
                    _filterBlocked(snapshot.data[1], blockedList.data);
                if ((snapshot.data.isEmpty) | (snapshot.data[1].length == 0)) {
                  return Center(
                    child: Text(errorText),
                  );
                }
                return Expanded(
                  child: ListView.builder(
                    addAutomaticKeepAlives: true,
                    shrinkWrap: true,
                    itemCount: snapshot.data![1].length,
                    itemBuilder: (context, index) {
                      var currentPack = snapshot.data[1][index];
                      switch (widget.contentType) {
                        case ContentType.packsByCategory:
                          return PackCard(
                            packData: currentPack,
                          );
                        case ContentType.shortsByCategory:
                          return ShortCardScaffold(
                            packData: currentPack,
                            voteReload: widget.reload,
                            contentType: widget.contentType,
                            menuCallback: widget.menuCallback,
                          );
                        case ContentType.shortBookmarks:
                          return ShortCardScaffold(
                            packData: currentPack,
                            voteReload: widget.reload,
                            contentType: widget.contentType,
                            menuCallback: widget.menuCallback,
                          );
                        case ContentType.packBookmarks:
                          return PackCard(
                            packData: currentPack,
                          );
                        case ContentType.drafts:
                          return ShortCardMinimal(
                            reload: widget.reload,
                            packData: currentPack,
                            contentType: widget.contentType,
                          );
                        case ContentType.yourShorts:
                          return ShortCardMinimal(
                            reload: widget.reload,
                            packData: currentPack,
                            contentType: widget.contentType,
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
    Map pack = packList[0];
    var date = pack["creationDate"];
    DateTime parseDt = DateTime.parse(date);

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
      case ContentType.packsByCategory:
        packFuture = widget.category == 99 ? getAllPosts : getPostsByCategory;
        provideCategory = true;
        errorText = "Keine Packs für diese Kategorie gefunden";
        break;
      case ContentType.shortsByCategory:
        packFuture = widget.category == 99 ? getAllShorts : getShortsByCategory;
        provideCategory = widget.category == 99 ? false : true;
        errorText = "Keine Shorts für diese Kategorie gefunden";
        break;
      case ContentType.shortBookmarks:
        packFuture = getBookmarkedShorts;
        errorText = "Du hast noch keine Shorts gespeichert";
        break;
      case ContentType.packBookmarks:
        packFuture = getBookmarkedShorts;
        errorText = "Du hast noch keine Packs gespeichert";
        break;
      case ContentType.drafts:
        packFuture = getDrafts;
        errorText = "Du hast noch keine Shorts entworfen";
        break;
      case ContentType.yourShorts:
        packFuture = getCreatorShorts;
        errorText = "Du hast noch keine Shorts veröffentlicht";
        break;
      default:
        break;
    }
  }
}
