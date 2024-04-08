import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lebenswiki_app/application/other/loading_helper.dart';
import 'package:lebenswiki_app/domain/models/error.model.dart';
import 'package:lebenswiki_app/presentation/providers/providers.dart';
import 'package:lebenswiki_app/presentation/widgets/common/extensions.dart';
import 'package:lebenswiki_app/presentation/widgets/cards/short_card.dart';
import 'package:lebenswiki_app/domain/models/short.model.dart';
import 'package:lebenswiki_app/data/short_api.dart';

class CommunityView extends ConsumerStatefulWidget {
  const CommunityView({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CommunityViewState();
}

class _CommunityViewState extends ConsumerState<CommunityView> {
  late List<Short> shorts;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: ShortApi().getAllShorts(),
        builder: (BuildContext context,
            AsyncSnapshot<Either<CustomError, List<Short>>> snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return LoadingHelper.loadingIndicator();
          }
          if (snapshot.data == null || snapshot.data!.isLeft) {
            return const Text("Something went wrong");
          }
          shorts = snapshot.data!.right;
          return RefreshIndicator(
            onRefresh: () async {
              ref.read(reloadProvider).reload();
            },
            child: ListView(
              children: [
                //TODO Reimplement
                // Text(
                //   "Kürzlich Angesehen",
                //   style: Theme.of(context).textTheme.headlineLarge,
                // ).addPadding(),
                // CarouselSlider(
                //   items: List<Widget>.from(shorts.map(
                //     (Short short) => Padding(
                //       padding: const EdgeInsets.only(right: 20),
                //       child: Column(
                //         children: [
                //           ShortCard(short: short),
                //         ],
                //       ),
                //     ),
                //   )),
                //   options: CarouselOptions(
                //     padEnds: true,
                //     height: 260,
                //     enableInfiniteScroll: false,
                //   ),
                // ),
                Text(
                  "Alle Shorts",
                  style: Theme.of(context).textTheme.headlineLarge,
                ).addPadding(),
                ...shorts.map((Short short) => Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 8),
                      child: ShortCard(short: short),
                    ))
              ],
            ),
          );
        });
  }
}
