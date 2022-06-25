import 'package:flutter/material.dart';
import 'package:lebenswiki_app/api/general/result_model_api.dart';
import 'package:lebenswiki_app/api/short_api.dart';
import 'package:lebenswiki_app/api/user_api.dart';
import 'package:lebenswiki_app/features/common/components/is_loading.dart';
import 'package:lebenswiki_app/features/common/components/loading.dart';
import 'package:lebenswiki_app/features/shorts/components/short_card_minimal.dart';
import 'package:lebenswiki_app/features/shorts/components/short_card_scaffold.dart';
import 'package:lebenswiki_app/models/category_model.dart';
import 'package:lebenswiki_app/models/enums.dart';
import 'package:lebenswiki_app/models/short_model.dart';

class GetShorts extends StatefulWidget {
  final ContentCategory? category;
  final Function reload;
  final CardType cardType;
  final Function menuCallback;

  const GetShorts({
    Key? key,
    this.category,
    required this.reload,
    required this.cardType,
    required this.menuCallback,
  }) : super(key: key);

  @override
  _GetShortsState createState() => _GetShortsState();
}

class _GetShortsState extends State<GetShorts> {
  final ShortApi shortApi = ShortApi();
  final UserApi userApi = UserApi();
  bool provideCategory = false;
  late Function packFuture;
  late Function(Short, Function) returnCard;

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
                    Short short = responseList[index];
                    return returnCard(short, widget.reload);
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
      case CardType.shortsByCategory:
        if (widget.category!.categoryName == "Neu") {
          provideCategory = false;
          packFuture = shortApi.getAllShorts;
        } else {
          provideCategory = true;
          packFuture = shortApi.getShortsByCategory;
        }
        returnCard = (short, reload) => ShortCardScaffold(
            short: short,
            reload: reload,
            menuCallback: widget.menuCallback,
            cardType: widget.cardType);
        break;
      case CardType.shortBookmarks:
        packFuture = shortApi.getBookmarkedShorts;
        returnCard = returnCard = (short, reload) => ShortCardMinimal(
              short: short,
              reload: reload,
              cardType: widget.cardType,
            );
        break;
      case CardType.yourShorts:
        packFuture = shortApi.getOwnPublishedShorts;
        returnCard = returnCard = (short, reload) => ShortCardMinimal(
              short: short,
              reload: reload,
              cardType: widget.cardType,
            );
        break;
      case CardType.shortDrafts:
        packFuture = shortApi.getCreatorsDraftShorts;
        returnCard = returnCard = (short, reload) => ShortCardMinimal(
              short: short,
              reload: reload,
              cardType: widget.cardType,
            );
        break;
      default:
        break;
    }
  }
}
