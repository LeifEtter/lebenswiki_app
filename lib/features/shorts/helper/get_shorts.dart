import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lebenswiki_app/api/general/result_model_api.dart';
import 'package:lebenswiki_app/features/shorts/api/short_api.dart';
import 'package:lebenswiki_app/features/common/components/is_loading.dart';
import 'package:lebenswiki_app/features/shorts/components/short_card_minimal.dart';
import 'package:lebenswiki_app/features/shorts/components/short_card_scaffold.dart';
import 'package:lebenswiki_app/models/category_model.dart';
import 'package:lebenswiki_app/models/enums.dart';
import 'package:lebenswiki_app/features/shorts/models/short_model.dart';
import 'package:lebenswiki_app/providers/providers.dart';

class GetShorts extends ConsumerStatefulWidget {
  final ContentCategory? category;
  final Function reload;
  final CardType cardType;

  const GetShorts({
    Key? key,
    this.category,
    required this.reload,
    required this.cardType,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GetShortsState();
}

class _GetShortsState extends ConsumerState<GetShorts> {
  final ShortApi shortApi = ShortApi();
  bool provideCategory = false;
  late Function packFuture;
  late Function(Short, Function) returnCard;

  @override
  Widget build(BuildContext context) {
    print("rebuilding");
    final List<int> blockedIdList =
        ref.watch(blockedListProvider).blockedIdList;
    _updateParameters();
    return FutureBuilder(
      future: provideCategory
          ? packFuture(category: widget.category)
          : packFuture(),
      builder: (context, AsyncSnapshot<ResultModel> snapshot) {
        if (LoadingHelper.isLoading(snapshot)) {
          return LoadingHelper.loadingIndicator();
        }
        ResultModel response = snapshot.data!;
        List<Short> shorts = List<Short>.from(response.responseList);
        if (response.type == ResultType.failure) {
          return Text(response.message!);
        }
        if (response.responseList.isEmpty) {
          return Text(response.message!);
        }
        return Expanded(
          child: ListView.builder(
            addAutomaticKeepAlives: true,
            shrinkWrap: true,
            itemCount: shorts.length,
            itemBuilder: (context, index) {
              Short short = shorts[index];
              return returnCard(short, widget.reload);
            },
          ),
        );
      },
    );
  }

  void _updateParameters() {
    switch (widget.cardType) {
      case CardType.shortsByCategory:
        provideCategory = true;
        packFuture = shortApi.getShortsByCategory;
        returnCard = (short, reload) => ShortCardScaffold(
            short: short, reload: reload, cardType: widget.cardType);
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
