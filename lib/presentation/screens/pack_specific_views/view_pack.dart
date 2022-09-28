import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lebenswiki_app/domain/models/error_model.dart';
import 'package:lebenswiki_app/domain/models/read_model.dart';
import 'package:lebenswiki_app/presentation/screens/pack_specific_views/view_pack_started.dart';
import 'package:lebenswiki_app/presentation/widgets/common/labels.dart';
import 'package:lebenswiki_app/presentation/widgets/interactions/custom_flushbar.dart';
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
  double opacity = 0;

  @override
  void initState() {
    fadeIn();
    super.initState();
  }

  void fadeIn() async {
    await Future.delayed(const Duration(milliseconds: 200));
    setState(() {
      opacity = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    profileImage = widget.pack.creator!.profileImage;
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
                SliverAppBar(
                  leadingWidth: 75,
                  toolbarHeight: 70,
                  leading: Padding(
                    padding: const EdgeInsets.only(bottom: 10, left: 10),
                    child: FloatingActionButton(
                      backgroundColor: const Color.fromRGBO(255, 255, 255, 0.8),
                      onPressed: () => Navigator.pop(context),
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: CustomColors.offBlack,
                        size: 28,
                      ),
                    ),
                  ),
                  systemOverlayStyle: SystemUiOverlayStyle.light,
                  elevation: 0,
                  backgroundColor: const Color.fromRGBO(0, 0, 0, 0),
                  pinned: false,
                  expandedHeight: 250,
                  flexibleSpace: FlexibleSpaceBar(
                    titlePadding: const EdgeInsets.all(0),
                    background: Hero(
                      tag: widget.heroName,
                      child: Image.network(
                        widget.pack.titleImage,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: AnimatedOpacity(
                      duration: const Duration(milliseconds: 500),
                      opacity: opacity,
                      child: Container(
                        height: 40,
                        padding: const EdgeInsets.only(
                          right: 20,
                          top: 15,
                          left: 10,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InfoLabel(
                              text: widget.pack.categories[0].categoryName,
                              backgroundColor: CustomColors.lightGrey,
                              fontSize: 8,
                            ),
                            const Spacer(),
                            const Icon(
                              Icons.file_upload_outlined,
                              size: 20,
                            ),
                            const SizedBox(width: 15),
                            Image.asset(
                              "assets/icons/clapping.png",
                              width: 20,
                              height: 20,
                            ),
                            const SizedBox(width: 15),
                            const Icon(
                              Icons.bookmark_add_outlined,
                              size: 20,
                            ),
                          ],
                        ),
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15.0),
                              topRight: Radius.circular(15.0),
                            )),
                      ),
                    ),
                  ),
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
                                    text: " for ",
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
                    "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et",
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
                        indicator: "5 Min",
                      ),
                      _buildVerticalDivider(),
                      _buildInteractionLabel(
                        label: "Leser",
                        indicator: "1,246",
                      ),
                      _buildVerticalDivider(),
                      _buildInteractionLabel(
                        label: "Claps",
                        indicator: "143",
                      ),
                      _buildVerticalDivider(),
                      _buildInteractionLabel(
                        label: "Kommentare",
                        indicator: "235",
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
                    "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 50),
                  LW.buttons.normal(
                    borderRadius: 15.0,
                    color: CustomColors.blue,
                    text: "Start Learning",
                    action: () async {
                      await ReadApi().create(packId: widget.pack.id!).fold(
                          (left) {
                        CustomFlushbar.error(message: left.error).show(context);
                      }, (right) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    PackViewerStarted(read: right)));
                      });
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
