import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lebenswiki_app/features/packs/api/pack_api.dart';
import 'package:lebenswiki_app/api/general/result_model_api.dart';
import 'package:lebenswiki_app/features/packs/components/pack_card.dart';
import 'package:lebenswiki_app/features/packs/components/pack_card_editable.dart';
import 'package:lebenswiki_app/features/common/components/is_loading.dart';
import 'package:lebenswiki_app/features/packs/helper/packlist_functions.dart';
import 'package:lebenswiki_app/models/category_model.dart';
import 'package:lebenswiki_app/models/enums.dart';
import 'package:lebenswiki_app/features/packs/models/pack_model.dart';
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
        List<Pack> packs = List<Pack>.from(response.responseList);
        if (response.type == ResultType.failure) {
          return Text(response.message!);
        }
        if (response.responseList.isEmpty) {
          return Text(response.message!);
        }
        packs = PackListFunctions.filterBlocked(packs, blockedIdList);
        return Expanded(
          child: ListView.builder(
            addAutomaticKeepAlives: true,
            shrinkWrap: true,
            itemCount: packs.length,
            itemBuilder: (context, index) {
              Pack pack = packs[index];
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
        packFuture = packApi.getOwnUnpublishedPacks;
        returnCard = returnCard =
            (pack, reload) => PackCardEdit(pack: pack, reload: reload);
        break;
      default:
        break;
    }
  }
}
