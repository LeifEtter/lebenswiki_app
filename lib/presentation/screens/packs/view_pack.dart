import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lebenswiki_app/domain/models/read_model.dart';
import 'package:lebenswiki_app/domain/models/user_model.dart';
import 'package:lebenswiki_app/presentation/providers/providers.dart';
import 'package:lebenswiki_app/presentation/screens/packs/view_pack_started.dart';
import 'package:lebenswiki_app/presentation/widgets/interactions/custom_flushbar.dart';
import 'package:lebenswiki_app/presentation/widgets/navigation/sliver_appbar.dart';
import 'package:lebenswiki_app/repository/backend/read_api.dart';
import 'package:lebenswiki_app/repository/constants/colors.dart';
import 'package:lebenswiki_app/presentation/widgets/lw.dart';
import 'package:lebenswiki_app/domain/models/pack_model.dart';

class ViewPack extends ConsumerStatefulWidget {
  final Pack pack;
  final String heroName;

  const ViewPack({
    Key? key,
    required this.pack,
    required this.heroName,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ViewPackState();
}

class _ViewPackState extends ConsumerState<ViewPack> {
  late String profileImage;
  late int fakeReads;
  late User user;
  late UserRole userRole;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    profileImage = widget.pack.creator!.profileImage;
    int unixTime = widget.pack.creationDate.millisecond;

    double calculated = unixTime / 2;
    user = ref.read(userProvider).user;
    userRole = ref.read(userRoleProvider).role;
    return Container(
      color: Colors.white,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                ViewerAppBar(
                  heroName: widget.heroName,
                  titleImage: widget.pack.titleImage,
                  categoryName: widget.pack.categories[0].categoryName,
                  clapCallback: () {},
                  shareCallback: () {},
                  bookmarkCallback: () {},
                  clapCount: widget.pack.claps.length,
                )
              ];
            },
            body: Container(
              padding: const EdgeInsets.all(15.0),
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  const SizedBox(height: 5),
                  Text(
                    widget.pack.title,
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      profileImage.startsWith('assets/')
                          ? CircleAvatar(
                              backgroundColor: Colors.white,
                              backgroundImage:
                                  AssetImage(widget.pack.creator!.profileImage),
                            )
                          : CircleAvatar(
                              backgroundColor: Colors.white,
                              backgroundImage: NetworkImage(
                                  widget.pack.creator!.profileImage),
                            ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                                style: Theme.of(context).textTheme.displaySmall,
                                children: [
                                  TextSpan(text: widget.pack.creator!.name),
                                  TextSpan(
                                    text: " für ",
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall!
                                        .copyWith(fontWeight: FontWeight.w400),
                                  ),
                                  TextSpan(text: widget.pack.initiative)
                                ]),
                          ),
                          Text(
                            "${DateFormat.MMMd().format(widget.pack.creationDate)}, ${DateFormat.y().format(widget.pack.creationDate)}",
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Text(
                    widget.pack.description,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: CustomColors.textMediumGrey),
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildInteractionLabel(
                        label: "Lesezeit",
                        indicator: widget.pack.pages.length.toString() + " Min",
                      ),
                      _buildVerticalDivider(),
                      _buildInteractionLabel(
                        label: "Leser",
                        indicator: calculated.round().toString(),
                      ),
                      _buildVerticalDivider(),
                      _buildInteractionLabel(
                        label: "Claps",
                        indicator: widget.pack.claps.length.toString(),
                      ),
                      _buildVerticalDivider(),
                      _buildInteractionLabel(
                        label: "Kommentare",
                        indicator: widget.pack.comments.length.toString(),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: Divider(
                      color: CustomColors.lightGrey,
                      thickness: 2,
                    ),
                  ),
                  Text(
                    "Über den Autor",
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.pack.creator!.biography,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 50),
                  LW.buttons.normal(
                    borderRadius: 15.0,
                    color: CustomColors.blue,
                    text: "Pack Starten",
                    action: () async {
                      if (userRole == UserRole.anonymous) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PackViewerStarted(
                                  read: Read(
                                    pack: widget.pack,
                                    packId: widget.pack.id!,
                                    userId: user.id,
                                  ),
                                  heroName: widget.heroName),
                            ));
                      } else {
                        await ReadApi().create(packId: widget.pack.id!).fold(
                            (left) {
                          CustomFlushbar.error(message: left.error)
                              .show(context);
                        }, (right) {
                          right.pack = widget.pack;
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PackViewerStarted(
                                        read: right,
                                        heroName: widget.heroName,
                                      )));
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInteractionLabel(
          {required String label, required String indicator}) =>
      Column(
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 5),
          Text(
            indicator,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      );

  Widget _buildVerticalDivider() => Padding(
        padding: const EdgeInsets.symmetric(),
        child: Container(
          color: CustomColors.lightGrey,
          width: 2,
          height: 40,
        ),
      );
}
