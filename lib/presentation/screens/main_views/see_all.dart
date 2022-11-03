import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lebenswiki_app/domain/models/category_model.dart';
import 'package:lebenswiki_app/domain/models/pack_model.dart';
import 'package:lebenswiki_app/presentation/widgets/cards/pack_card.dart';
import 'package:lebenswiki_app/presentation/widgets/navigation/top_nav.dart';
import 'package:lebenswiki_app/repository/constants/colors.dart';

enum SortingOption {
  newestFirst,
  mostRead,
  mostCommented,
}

class CatCheckboxEntry {
  ContentCategory cat;
  bool value;

  CatCheckboxEntry({required this.cat, required this.value});
}

class SeeAllView extends ConsumerStatefulWidget {
  final String title;
  final List<Pack> packs;
  final List<ContentCategory> categories;

  const SeeAllView({
    Key? key,
    required this.packs,
    required this.categories,
    required this.title,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SeeAllViewState();
}

class _SeeAllViewState extends ConsumerState<SeeAllView> {
  late ContentCategory chosenCategory;

  SortingOption chosenSortingOption = SortingOption.newestFirst;

  late List<CatCheckboxEntry> catCheckboxList;

  late List<Pack> packsToShow;

  @override
  void initState() {
    packsToShow = widget.packs;
    catCheckboxList = widget.categories
        .map((ContentCategory cat) => CatCheckboxEntry(
              cat: cat,
              value: false,
            ))
        .toList();
    chosenCategory = widget.categories[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    for (CatCheckboxEntry checkboxEntry in catCheckboxList) {
      if (checkboxEntry.cat == chosenCategory) {
        checkboxEntry.value = true;
      } else {
        checkboxEntry.value = false;
      }
    }
    List<Pack> newPacksToShow = [];

    newPacksToShow = preparePacksToShow();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15, top: 40.0),
        child: Column(
          children: [
            TopNavIOS(title: widget.title),
            Divider(
              thickness: 1.1,
              color: CustomColors.mediumGrey,
            ),
            _buildTopOptions(
              sortCallback: (SortingOption option) {
                chosenSortingOption = option;
                setState(() {});
              },
              filterCallback: (ContentCategory category) {
                chosenCategory = category;
                setState(() {});
              },
            ),
            Divider(
              thickness: 1.1,
              color: CustomColors.mediumGrey,
            ),
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: newPacksToShow.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 8),
                      child: SizedBox(
                        height: 250,
                        child: PackCard(
                          title: newPacksToShow[index].title,
                          heroParent: "",
                          pack: newPacksToShow[index],
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  List<Pack> preparePacksToShow() {
    List<Pack> result = [];
    if (chosenCategory.categoryName != "Neu") {
      result = widget.packs.where((Pack pack) {
        return pack.categories[0].id == chosenCategory.id;
      }).toList();
    } else {
      result = widget.packs;
    }

    switch (chosenSortingOption) {
      case SortingOption.newestFirst:
        result
            .sort((Pack a, Pack b) => b.creationDate.compareTo(a.creationDate));
        break;
      case SortingOption.mostCommented:
        result.sort(
            (Pack a, Pack b) => b.comments.length.compareTo(a.comments.length));
        break;
      case SortingOption.mostRead:
        result
            .sort((Pack a, Pack b) => b.claps.length.compareTo(a.claps.length));
    }
    return result;
  }

  Widget _buildTopOptions({
    required Function(SortingOption) sortCallback,
    required Function(ContentCategory) filterCallback,
  }) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Flexible(
            flex: 50,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () =>
                  _showFilteringOptions(filterCallback: filterCallback),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.filter_list_rounded, color: CustomColors.blue),
                  const SizedBox(width: 10),
                  Text("Filter",
                      style: TextStyle(
                          color: CustomColors.textGrey,
                          fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ),
          Container(
            height: 30,
            width: 1.1,
            color: CustomColors.mediumGrey,
          ),
          Flexible(
            flex: 50,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => _showSortingOptions(
                sortCallback: sortCallback,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RotatedBox(
                      quarterTurns: 1,
                      child: Icon(Icons.sync_alt_rounded,
                          color: CustomColors.blue)),
                  const SizedBox(width: 10),
                  Text("Sortieren",
                      style: TextStyle(
                          color: CustomColors.textGrey,
                          fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ),
        ],
      );

  void _showFilteringOptions(
      {required Function(ContentCategory) filterCallback}) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
        height: 300,
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.close_rounded, color: CustomColors.blue, size: 25),
                Text(
                  "Sortieren",
                  style: TextStyle(
                      color: CustomColors.offBlack,
                      fontWeight: FontWeight.w500,
                      fontSize: 18),
                ),
                Icon(Icons.check_rounded, color: CustomColors.blue, size: 25),
              ],
            ),
            const SizedBox(height: 20),
            ExpansionTile(
              tilePadding: const EdgeInsets.only(),
              title: Text(
                "Kategorien",
                style: TextStyle(
                  color: CustomColors.offBlack,
                  fontWeight: FontWeight.w500,
                ),
              ),
              children: [
                ...catCheckboxList
                    .map((CatCheckboxEntry catCheckbox) => Padding(
                          padding:
                              const EdgeInsets.only(left: 5, top: 5, bottom: 5),
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              Navigator.pop(context);
                              filterCallback(catCheckbox.cat);
                            },
                            child: Row(
                              children: [
                                SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: Checkbox(
                                    activeColor: CustomColors.offBlack,
                                    shape: const CircleBorder(),
                                    value: catCheckbox.value,
                                    onChanged: (bool? newValue) {
                                      //TODO setstate
                                    },
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Text(
                                  catCheckbox.cat.categoryName,
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: catCheckbox.value
                                        ? CustomColors.offBlack
                                        : CustomColors.textMediumGrey,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ))
                    .toList(),
                const SizedBox(height: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showSortingOptions({required Function(SortingOption) sortCallback}) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      context: context,
      builder: (context) => Container(
        height: 240,
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.close_rounded, color: CustomColors.blue, size: 25),
                Text(
                  "Sortieren",
                  style: TextStyle(
                      color: CustomColors.offBlack,
                      fontWeight: FontWeight.w500,
                      fontSize: 18),
                ),
                Icon(Icons.check_rounded, color: CustomColors.blue, size: 25),
              ],
            ),
            const SizedBox(height: 40),
            _buildSortingOptionTile(
              sortCallback: sortCallback,
              optionName: "Neueste",
              option: SortingOption.newestFirst,
            ),
            const Divider(height: 20),
            _buildSortingOptionTile(
                sortCallback: sortCallback,
                optionName: "Meist Gelesen",
                option: SortingOption.mostRead),
            const Divider(height: 20),
            _buildSortingOptionTile(
              sortCallback: sortCallback,
              optionName: "Meist Kommentiert",
              option: SortingOption.mostCommented,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSortingOptionTile({
    required Function(SortingOption) sortCallback,
    required String optionName,
    required SortingOption option,
  }) =>
      GestureDetector(
        onTap: () {
          Navigator.pop(context);
          sortCallback(option);
        },
        child: Text(
          optionName,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: option != chosenSortingOption
                  ? CustomColors.darkGrey
                  : CustomColors.offBlack),
        ),
      );
}
