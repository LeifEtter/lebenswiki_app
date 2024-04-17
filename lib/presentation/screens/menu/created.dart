import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:go_router/go_router.dart';
import 'package:lebenswiki_app/domain/models/error.model.dart';
import 'package:lebenswiki_app/domain/models/pack/pack.model.dart';
import 'package:lebenswiki_app/domain/models/short.model.dart';
import 'package:lebenswiki_app/domain/models/user/user.model.dart';
import 'package:lebenswiki_app/presentation/providers/providers.dart';
import 'package:lebenswiki_app/presentation/screens/creator/creator_information.dart';
import 'package:lebenswiki_app/presentation/screens/creator/creator.dart';
import 'package:lebenswiki_app/presentation/widgets/interactions/custom_flushbar.dart';
import 'package:lebenswiki_app/presentation/widgets/navigation/top_nav.dart';
import 'package:lebenswiki_app/data/pack_api.dart';
import 'package:lebenswiki_app/data/short_api.dart';
import 'package:lebenswiki_app/presentation/constants/colors.dart';
import 'package:lebenswiki_app/presentation/widgets/cards/pack_card.dart';
import 'package:lebenswiki_app/presentation/widgets/cards/short_card.dart';
import 'package:lebenswiki_app/application/other/loading_helper.dart';

class PackShortLists {
  List<Pack> packs = [];
  List<Short> shorts = [];

  PackShortLists();
}

class CreatedView extends ConsumerStatefulWidget {
  final bool startWithShorts;

  const CreatedView({
    super.key,
    this.startWithShorts = false,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreatedViewState();
}

class _CreatedViewState extends ConsumerState<CreatedView> {
  late User? user;

  @override
  Widget build(BuildContext context) {
    user = ref.read(userProvider).user;
    return Scaffold(
      body: SafeArea(
        child: DefaultTabController(
          initialIndex: widget.startWithShorts ? 1 : 0,
          length: 2,
          child: Column(
            children: [
              const TopNavIOS(
                title: "Erstellt",
                isPopMenu: true,
              ),
              SizedBox(
                height: 50,
                child: TabBar(
                  tabs: [
                    Tab(
                      child: Text("Packs",
                          style: Theme.of(context).textTheme.labelLarge),
                    ),
                    Tab(
                      child: Text("Shorts",
                          style: Theme.of(context).textTheme.labelLarge),
                    )
                  ],
                  isScrollable: true,
                  indicatorWeight: 4.0,
                  indicatorColor: CustomColors.blue,
                  labelColor: CustomColors.offBlack,
                  unselectedLabelColor: CustomColors.darkGrey,
                ),
              ),
              FutureBuilder(
                future: getDraftShortsAndPacks(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (LoadingHelper.isLoading(snapshot)) {
                    return LoadingHelper.loadingIndicator();
                  }
                  final Either<CustomError, PackShortLists> result =
                      snapshot.data;
                  return result.fold(
                    (left) => Text(left.error),
                    (right) {
                      return Expanded(
                        child: TabBarView(
                          children: [
                            right.packs.isEmpty
                                ? _buildEmptyText(user!.role!.level < 3
                                    ? "Du musst Creator werden um Packs zu erstellen"
                                    : "Du hast noch keine Packs gespeichert")
                                : ListView.builder(
                                    padding: const EdgeInsets.all(30.0),
                                    shrinkWrap: true,
                                    itemCount: right.packs.length + 1,
                                    itemBuilder: (context, index) {
                                      if (index == 0) {
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 20),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(15.0)),
                                                color: CustomColors.blue),
                                            child: TextButton(
                                              child: const Text(
                                                "Pack Erstellen",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              onPressed: () =>
                                                  context.go("/create/pack"),
                                            ),
                                          ),
                                        );
                                      }
                                      Pack currentPack = right.packs[index - 1];
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 40),
                                        child: SizedBox(
                                          width: 300,
                                          height: 250,
                                          child: Stack(
                                            children: [
                                              PackCard(
                                                isDraftView: true,
                                                pack: currentPack,
                                                heroParent: "created-packs",
                                              ),
                                              Align(
                                                alignment: Alignment.topRight,
                                                child: _buildActionMenu(context,
                                                    currentPack: currentPack),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                            right.shorts.isEmpty
                                ? _buildEmptyText(
                                    "Du hast noch keine Shorts gespeichert")
                                : ListView.builder(
                                    padding: const EdgeInsets.all(20.0),
                                    shrinkWrap: true,
                                    itemCount: right.shorts.length,
                                    itemBuilder: (context, index) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10.0),
                                      child: Stack(
                                        children: [
                                          ShortCard(
                                            short: right.shorts[index],
                                          ),
                                          Align(
                                            alignment: Alignment.topRight,
                                            child: _buildActionMenuShorts(
                                                currentShort:
                                                    right.shorts[index]),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Either<CustomError, PackShortLists>> getDraftShortsAndPacks() async {
    PackShortLists result = PackShortLists();
    await PackApi().getOwnPublishedPacks().fold((left) {}, (right) {
      result.packs.addAll(right);
    });
    await ShortApi().getPublishedShorts().fold((left) {}, (right) {
      result.shorts.addAll(right);
    });
    await PackApi().getOwnUnpublishedPacks().fold((left) {}, (right) {
      result.packs.addAll(right);
    });
    await ShortApi().getUnpublishedShorts().fold((left) {}, (right) {
      result.shorts.addAll(right);
    });
    return Right(result);
  }

  Widget _buildActionMenu(context, {required Pack currentPack}) => SpeedDial(
        elevation: 10,
        direction: SpeedDialDirection.down,
        backgroundColor: CustomColors.lightGrey,
        buttonSize: const Size(50, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        children: [
          SpeedDialChild(
            onTap: () async {
              context.go("/create/pack", extra: currentPack);
              // await Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) =>
              //             CreatorPackInfo(pack: currentPack)));
              //TODO Maybe remove this
              setState(() {});
            },
            child: const Icon(Icons.edit_note_outlined),
            label: "Informationen Bearbeiten",
          ),
          SpeedDialChild(
            onTap: () async {
              //TODO Implement Pack Editor
              // await Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => Creator(pack: currentPack)));
              context.go("/create/pages/", extra: currentPack);
              //TODO maybe remove this
              setState(() {});
            },
            child: const Icon(
              Icons.edit_outlined,
            ),
            label: "Inhalt Bearbeiten",
          ),
          currentPack.published
              ? SpeedDialChild(
                  onTap: () async {
                    await PackApi().unpublishPack(currentPack.id).fold((left) {
                      CustomFlushbar.error(message: left.error).show(context);
                    }, (right) {
                      CustomFlushbar.success(message: right).show(context);
                    });
                    setState(() {});
                  },
                  label: "Pack Privat Machen",
                  child: const Icon(Icons.public_off_rounded))
              : SpeedDialChild(
                  onTap: () async {
                    await PackApi().publishPack(currentPack.id).fold((left) {
                      CustomFlushbar.error(message: left.error).show(context);
                    }, (right) {
                      CustomFlushbar.success(message: right).show(context);
                    });
                    setState(() {});
                  },
                  child: const Icon(Icons.publish_outlined),
                  label: "Pack Veröffentlichen",
                ),
          SpeedDialChild(
            onTap: () async {
              await _buildDeleteDialog(
                onDelete: () async {
                  await PackApi().deletePack(currentPack.id!).fold(
                    (left) {
                      context.pop();
                      CustomFlushbar.error(message: left.error).show(context);
                    },
                    (right) async {
                      // if (currentPack.imageIdentifier != "something") {
                      //   await _storage
                      //       .ref("pack_images/${currentPack.imageIdentifier}")
                      //       .listAll()
                      //       .then((ListResult itemsInDir) {
                      //     for (Reference item in itemsInDir.items) {
                      //       _storage.ref(item.fullPath).delete();
                      //     }
                      //   });
                      // }
                      context.pop();
                      CustomFlushbar.success(message: right).show(context);
                    },
                  );
                },
                title: "Pack Löschen",
                body: "Willst du dieses Pack wirklich löschen",
              );
              setState(() {});
            },
            child: const Icon(Icons.delete_outline),
            label: "Pack Löschen",
          ),
        ],
        child: Icon(
          Icons.settings,
          color: CustomColors.textBlack,
          size: 28,
        ),
      );

  Widget _buildActionMenuShorts({required Short currentShort}) {
    return SpeedDial(
      elevation: 10,
      direction: SpeedDialDirection.down,
      backgroundColor: CustomColors.lightGrey,
      buttonSize: const Size(50, 50),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      children: [
        currentShort.published
            ? SpeedDialChild(
                onTap: () async {
                  await ShortApi().unpublishShort(currentShort.id!).fold(
                      (left) {
                    CustomFlushbar.error(message: left.error).show(context);
                  }, (right) {
                    CustomFlushbar.success(message: right).show(context);
                  });
                  setState(() {});
                },
                label: "Short Privat Machen",
                child: const Icon(Icons.public_off_rounded))
            : SpeedDialChild(
                onTap: () async {
                  await ShortApi().publishShort(currentShort.id!).fold((left) {
                    CustomFlushbar.error(message: left.error).show(context);
                  }, (right) {
                    CustomFlushbar.success(message: right).show(context);
                  });
                  setState(() {});
                },
                child: const Icon(Icons.publish_outlined),
                label: "Short Veröffentlichen",
              ),
        SpeedDialChild(
          onTap: () async {
            await _buildDeleteDialog(
              onDelete: () async {
                await ShortApi().deleteShort(currentShort.id!).fold(
                  (left) {
                    context.pop();
                    CustomFlushbar.error(message: left.error).show(context);
                  },
                  (right) {
                    context.pop();
                    CustomFlushbar.success(message: right).show(context);
                  },
                );
              },
              title: "Short Löschen",
              body: "Willst du diesen Short wirklich löschen",
            );
            setState(() {});
          },
          child: const Icon(Icons.delete_outline),
          label: "Short Löschen",
        ),
      ],
      child: Icon(
        Icons.settings,
        color: CustomColors.textBlack,
        size: 28,
      ),
    );
  }

  Widget _buildEmptyText(text) => Column(
        children: [
          const SizedBox(height: 100),
          Icon(
            Icons.info_outline_rounded,
            color: CustomColors.darkGrey,
            size: 40,
          ),
          Text(
            text,
            style: TextStyle(
              color: CustomColors.darkGrey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      );

  Future _buildDeleteDialog({
    required Function onDelete,
    required String title,
    required String body,
  }) async {
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(title),
              content: Text(body),
              actions: [
                TextButton(
                  onPressed: () => onDelete(),
                  child: const Text(
                    "Löschen",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    context.pop();
                  },
                  child: Text(
                    "Abbrechen",
                    style: TextStyle(
                      color: CustomColors.blue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ));
  }
}
