import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lebenswiki_app/domain/models/pack_model.dart';
import 'package:lebenswiki_app/domain/models/short_model.dart';
import 'package:lebenswiki_app/presentation/widgets/navigation/top_nav.dart';
import 'package:lebenswiki_app/repository/constants/colors.dart';

enum SortingOption {
  newestFirst,
  mostRead,
  mostCommented,
}

class SeeAllView extends ConsumerStatefulWidget {
  final bool isShorts;
  final List<Pack>? packs;
  final List<Short>? shorts;

  const SeeAllView({
    Key? key,
    this.isShorts = false,
    this.packs = const [],
    this.shorts = const [],
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SeeAllViewState();
}

class _SeeAllViewState extends ConsumerState<SeeAllView> {
  SortingOption chosenSortingOption = SortingOption.newestFirst;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 50),
        children: [
          const TopNavIOS(title: "Irgendwas"),
          Divider(
            thickness: 1.1,
            color: CustomColors.mediumGrey,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () => _showFilteringOptions(),
                child: Row(
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
              Container(
                height: 30,
                width: 1.1,
                color: CustomColors.mediumGrey,
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => _showSortingOptions(),
                child: Row(
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
            ],
          ),
          Divider(
            thickness: 1.1,
            color: CustomColors.mediumGrey,
          ),
        ],
      ),
    );
  }

  void _showFilteringOptions() {}

  void _showSortingOptions() {
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
                optionName: "Neueste", option: SortingOption.newestFirst),
            const Divider(height: 20),
            _buildSortingOptionTile(
                optionName: "Meist Gelesen", option: SortingOption.mostRead),
            const Divider(height: 20),
            _buildSortingOptionTile(
              optionName: "Meist Kommentiert",
              option: SortingOption.mostCommented,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSortingOptionTile({
    required String optionName,
    required SortingOption option,
  }) =>
      GestureDetector(
        onTap: () {
          setState(() {
            chosenSortingOption = option;
          });
          Navigator.pop(context);
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
