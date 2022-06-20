import 'package:flutter/material.dart';
import 'package:lebenswiki_app/api/pack_api.dart';
import 'package:lebenswiki_app/api/result_model_api.dart';
import 'package:lebenswiki_app/api/short_api.dart';
import 'package:lebenswiki_app/api/user_api.dart';
import 'package:lebenswiki_app/components/cards/short_cards/short_card_minimal.dart';
import 'package:lebenswiki_app/components/cards/short_cards/short_card_scaffold.dart';
import 'package:lebenswiki_app/components/cards/pack_cards/pack_card.dart';
import 'package:lebenswiki_app/components/cards/pack_cards/pack_card_edit.dart';
import 'package:lebenswiki_app/data/loading.dart';
import 'package:lebenswiki_app/helper/is_loading.dart';
import 'package:lebenswiki_app/models/category_model.dart';
import 'package:lebenswiki_app/models/enums.dart';
import 'package:lebenswiki_app/models/pack_model.dart';

class GetContent extends StatefulWidget {
  final ContentCategory? category;
  final Function reload;
  final CardType cardType;
  final Function menuCallback;

  const GetContent({
    Key? key,
    this.category,
    required this.reload,
    required this.cardType,
    required this.menuCallback,
  }) : super(key: key);

  @override
  _GetContentState createState() => _GetContentState();
}

class _GetContentState extends State<GetContent> {
  final ShortApi shortApi = ShortApi();
  final PackApi packApi = PackApi();
  final UserApi userApi = UserApi();
  bool provideCategory = false;
  String errorText = "";
  late Function packFuture;
  late Widget card;

  late var contentList;

  @override
  Widget build(BuildContext context) {
    _updateParameters();
    return FutureBuilder(
      future: userApi.getBlockedUsers(),
      builder: (context, AsyncSnapshot blockedList) {
        if (!blockedList.hasData) {
          return const Loading();
        } else {
          return FutureBuilder(
            future: provideCategory
                ? packFuture(category: widget.category)
                : packFuture(),
            builder: (context, AsyncSnapshot<ResultModel> snapshot) {
              if (isLoading(snapshot)) {
                return const Loading();
              }
              ResultModel response = snapshot.data!;
              List responseList = response.responseList;
              if (responseList.isEmpty) {
                return Text(response.message!);
              }
              widget.category!.id == 99
                  ? responseList = _sortPacks(responseList)
                  : null;
              responseList = _filterBlocked(responseList, blockedList.data);
              return Expanded(
                child: ListView.builder(
                  addAutomaticKeepAlives: true,
                  shrinkWrap: true,
                  itemCount: responseList.length,
                  itemBuilder: (context, index) {
                    var currentPack = responseList[index];
                    switch (widget.cardType) {
                      case CardType.shortsByCategory:
                        return ShortCardScaffold(
                          short: currentPack,
                          voteReload: widget.reload,
                          cardType: widget.cardType,
                          menuCallback: widget.menuCallback,
                        );
                      case CardType.shortBookmarks:
                        return ShortCardScaffold(
                          short: currentPack,
                          voteReload: widget.reload,
                          cardType: widget.cardType,
                          menuCallback: widget.menuCallback,
                        );
                      case CardType.shortDrafts:
                        return ShortCardMinimal(
                          reload: widget.reload,
                          short: currentPack,
                          cardType: widget.cardType,
                        );
                      case CardType.yourShorts:
                        return ShortCardMinimal(
                          reload: widget.reload,
                          short: currentPack,
                          cardType: widget.cardType,
                        );
                      case CardType.packsByCategory:
                        return CreatorPackCard(
                            pack: Pack.fromJson(currentPack));
                      case CardType.packDrafts:
                        return CreatorPackCardEdit(
                          pack: Pack.fromJson(currentPack),
                          reload: widget.reload,
                        );
                      case CardType.yourPacks:
                        return CreatorPackCardEdit(
                          pack: Pack.fromJson(currentPack),
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
    switch (widget.cardType) {
      case CardType.packsByCategory:
        packFuture = widget.category == 99
            ? packApi.getAllPacks
            : packApi.getPacksByCategory;
        provideCategory = true;
        errorText = "Keine Packs für diese Kategorie gefunden";
        break;
      case CardType.shortsByCategory:
        packFuture = widget.category!.id == 99
            ? shortApi.getAllShorts
            : shortApi.getShortsByCategory;
        provideCategory = widget.category!.id == 99 ? false : true;
        errorText = "Keine Shorts für diese Kategorie gefunden";
        break;
      case CardType.shortBookmarks:
        packFuture = shortApi.getBookmarkedShorts;
        errorText = "Du hast noch keine Shorts gespeichert";
        break;
      case CardType.packBookmarks:
        packFuture = packApi.getBookmarkedPacks;
        errorText = "Du hast noch keine Packs gespeichert";
        break;
      case CardType.shortDrafts:
        packFuture = shortApi.getCreatorsDraftShorts;
        errorText = "Du hast noch keine Shorts entworfen";
        break;
      case CardType.yourShorts:
        packFuture = shortApi.getOwnPublishedShorts;
        errorText = "Du hast noch keine Shorts veröffentlicht";
        break;
      case CardType.yourPacks:
        packFuture = packApi.getOwnPublishedpacks;
        errorText = "Du hast noch keine Lernpacks veröffentlicht";
        break;
      case CardType.packDrafts:
        packFuture = () {};
        errorText = "Du hast noch keine Lernpacks entworfen";
        break;
      default:
        break;
    }
  }

  void _filterContent() {}
}
