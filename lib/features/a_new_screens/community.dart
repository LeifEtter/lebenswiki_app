import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lebenswiki_app/features/a_new_common/extensions.dart';
import 'package:lebenswiki_app/features/a_new_widget_repo/short_card.dart';
import 'package:lebenswiki_app/features/shorts/helper/short_list_helper.dart';
import 'package:lebenswiki_app/features/shorts/models/short_model.dart';
import 'package:lebenswiki_app/features/testing/components/border.dart';

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
    return ListView(
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
                  NewShortCard(short: short),
                ],
              ),
            ),
          )),
          options: CarouselOptions(
            padEnds: true,
            height: 230,
            enableInfiniteScroll: false,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          "Alle Shorts",
          style: Theme.of(context).textTheme.headlineLarge,
        ).addPadding(),
        ...widget.shortHelper.shorts
            .map((Short short) => Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                  child: NewShortCard(short: short),
                ))
            .toList(),
      ],
    );
  }
}
