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
  late bool provideCategory = false;
  String errorText = "";
  late Function packFuture;
  late Widget card;

  @override
  void initState() {
    if (widget.cardType == CardType.packsByCategory ||
        widget.cardType == CardType.shortsByCategory) {
      provideCategory = true;
    }
    super.initState();
  }

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
              //responseList = _filterBlocked(responseList, blockedList.data);
              return Expanded(
                child: ListView.builder(
                  addAutomaticKeepAlives: true,
                  shrinkWrap: true,
                  itemCount: responseList.length,
                  itemBuilder: (context, index) {
                    var currentContent = responseList[index];
                    switch (widget.cardType) {
                      case CardType.shortsByCategory:
                        return ShortCardScaffold(
                          short: currentContent,
                          voteReload: widget.reload,
                          cardType: widget.cardType,
                          menuCallback: widget.menuCallback,
                        );
                      case CardType.shortBookmarks:
                        return ShortCardScaffold(
                          short: currentContent,
                          voteReload: widget.reload,
                          cardType: widget.cardType,
                          menuCallback: widget.menuCallback,
                        );
                      case CardType.shortDrafts:
                        return ShortCardMinimal(
                          reload: widget.reload,
                          short: currentContent,
                          cardType: widget.cardType,
                        );
                      case CardType.yourShorts:
                        return ShortCardMinimal(
                          reload: widget.reload,
                          short: currentContent,
                          cardType: widget.cardType,
                        );
                      case CardType.packsByCategory:
                        return CreatorPackCard(
                          pack: currentContent,
                          reload: widget.reload,
                        );
                      case CardType.packDrafts:
                        return CreatorPackCardEdit(
                          pack: currentContent,
                          reload: widget.reload,
                        );
                      case CardType.yourPacks:
                        return CreatorPackCardEdit(
                          pack: currentContent,
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

  void _updateParameters() {
    switch (widget.cardType) {
      case CardType.packsByCategory:
        packFuture = widget.category!.id == 0
            ? packApi.getAllPacks
            : packApi.getPacksByCategory;
        provideCategory = true;
        errorText = "Keine Packs für diese Kategorie gefunden";
        break;
      case CardType.shortsByCategory:
        packFuture = widget.category!.id == 0
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
}
