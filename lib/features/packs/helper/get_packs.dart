import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lebenswiki_app/api/pack_api.dart';
import 'package:lebenswiki_app/api/general/result_model_api.dart';
import 'package:lebenswiki_app/features/action_menu/components/report_popup.dart';
import 'package:lebenswiki_app/features/packs/components/pack_card.dart';
import 'package:lebenswiki_app/features/packs/components/pack_card_editable.dart';
import 'package:lebenswiki_app/features/common/components/is_loading.dart';
import 'package:lebenswiki_app/models/category_model.dart';
import 'package:lebenswiki_app/models/enums.dart';
import 'package:lebenswiki_app/models/pack_model.dart';
import 'package:lebenswiki_app/models/user_model.dart';
import 'package:lebenswiki_app/providers/providers.dart';

class GetPacks extends ConsumerStatefulWidget {
  final ContentCategory? category;
  final Function reload;
  final CardType cardType;

  const GetPacks({
    Key? key,
    this.category,
    required this.reload,
    required this.cardType,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GetPacksState();
}

class _GetPacksState extends ConsumerState<GetPacks> {
  final PackApi packApi = PackApi();
  bool provideCategory = false;
  late Function packFuture;
  late Function(Pack, Function) returnCard;

  @override
  Widget build(BuildContext context) {
    //TODO fix blockedList
    final List<User> blockedList = ref.watch(blockedListProvider).blockedList;
    _updateParameters();
    return FutureBuilder(
      future: provideCategory
          ? packFuture(category: widget.category)
          : packFuture(),
      builder: (context, AsyncSnapshot<ResultModel> snapshot) {
        //print(snapshot.data);
        if (LoadingHelper.isLoading(snapshot)) {
          return LoadingHelper.loadingIndicator();
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

  void _updateParameters() {
    switch (widget.cardType) {
      case CardType.packsByCategory:
        provideCategory = true;
        packFuture = packApi.getPacksByCategory;
        returnCard = (pack, reload) => PackCard(pack: pack, reload: reload);
        break;
      case CardType.packBookmarks:
        packFuture = packApi.getBookmarkedPacks;
        returnCard = returnCard =
            (pack, reload) => PackCardEdit(pack: pack, reload: reload);
        break;
      case CardType.yourPacks:
        packFuture = packApi.getOwnPublishedpacks;
        returnCard = returnCard =
            (pack, reload) => PackCardEdit(pack: pack, reload: reload);
        break;
      case CardType.packDrafts:
        packFuture = () {};
        returnCard = returnCard =
            (pack, reload) => PackCardEdit(pack: pack, reload: reload);
        break;
      default:
        break;
    }
  }
}
