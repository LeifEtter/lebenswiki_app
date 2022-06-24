import 'package:flutter/material.dart';
import 'package:lebenswiki_app/api/pack_api.dart';
import 'package:lebenswiki_app/api/general/result_model_api.dart';
import 'package:lebenswiki_app/api/user_api.dart';
import 'package:lebenswiki_app/features/packs/components/pack_card.dart';
import 'package:lebenswiki_app/features/packs/components/pack_card_edit.dart';
import 'package:lebenswiki_app/features/common/components/loading.dart';
import 'package:lebenswiki_app/features/common/components/is_loading.dart';
import 'package:lebenswiki_app/models/category_model.dart';
import 'package:lebenswiki_app/models/enums.dart';
import 'package:lebenswiki_app/models/pack_model.dart';

class GetPacks extends StatefulWidget {
  final ContentCategory? category;
  final Function reload;
  final CardType cardType;
  final Function menuCallback;

  const GetPacks({
    Key? key,
    this.category,
    required this.reload,
    required this.cardType,
    required this.menuCallback,
  }) : super(key: key);

  @override
  _GetPacksState createState() => _GetPacksState();
}

class _GetPacksState extends State<GetPacks> {
  final PackApi packApi = PackApi();
  final UserApi userApi = UserApi();
  bool provideCategory = false;
  late Function packFuture;
  late Function(Pack, Function) returnCard;

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
                    Pack pack = responseList[index];
                    return returnCard(pack, widget.reload);
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
        provideCategory = true;
        packFuture = widget.category!.categoryName == "Neu"
            ? packApi.getAllPacks
            : packApi.getPacksByCategory;
        returnCard =
            (pack, reload) => CreatorPackCard(pack: pack, reload: reload);
        break;
      case CardType.packBookmarks:
        packFuture = packApi.getBookmarkedPacks;
        returnCard = returnCard =
            (pack, reload) => CreatorPackCardEdit(pack: pack, reload: reload);
        break;
      case CardType.yourPacks:
        packFuture = packApi.getOwnPublishedpacks;
        returnCard = returnCard =
            (pack, reload) => CreatorPackCardEdit(pack: pack, reload: reload);
        break;
      case CardType.packDrafts:
        packFuture = () {};
        returnCard = returnCard =
            (pack, reload) => CreatorPackCardEdit(pack: pack, reload: reload);
        break;
      default:
        break;
    }
  }
}
