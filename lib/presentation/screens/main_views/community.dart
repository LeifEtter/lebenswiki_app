import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lebenswiki_app/presentation/providers/providers.dart';
import 'package:lebenswiki_app/presentation/widgets/common/extensions.dart';
import 'package:lebenswiki_app/presentation/widgets/cards/short_card.dart';
import 'package:lebenswiki_app/application/data/short_list_helper.dart';
import 'package:lebenswiki_app/domain/models/short_model.dart';

class CommunityView extends ConsumerStatefulWidget {
  final ShortListHelper shortHelper;

  const CommunityView({
    Key? key,
    required this.shortHelper,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CommunityViewState();
}

class _CommunityViewState extends ConsumerState<CommunityView> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        ref.read(reloadProvider).reload();
      },
      child: ListView(
        children: [
          Text(
            "Kürzlich Angesehen",
            style: Theme.of(context).textTheme.headlineLarge,
          ).addPadding(),
          CarouselSlider(
            items: List<Widget>.from(widget.shortHelper.shorts.map(
              (Short short) => Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Column(
                  children: [
                    ShortCard(short: short),
                  ],
                ),
              ),
            )),
            options: CarouselOptions(
              padEnds: true,
              height: 260,
              enableInfiniteScroll: false,
            ),
          ),
          Text(
            "Alle Shorts",
            style: Theme.of(context).textTheme.headlineLarge,
          ).addPadding(),
          ...widget.shortHelper.shorts
              .map((Short short) => Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                    child: ShortCard(short: short),
                  ))
              .toList(),
        ],
      ),
    );
  }
}
