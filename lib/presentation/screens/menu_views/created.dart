import 'package:either_dart/either.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:lebenswiki_app/domain/models/error_model.dart';
import 'package:lebenswiki_app/domain/models/pack_model.dart';
import 'package:lebenswiki_app/domain/models/read_model.dart';
import 'package:lebenswiki_app/domain/models/short_model.dart';
import 'package:lebenswiki_app/presentation/providers/providers.dart';
import 'package:lebenswiki_app/presentation/screens/creator/new_creator_screen.dart';
import 'package:lebenswiki_app/presentation/screens/packs/creator_information.dart';
import 'package:lebenswiki_app/presentation/screens/packs/creator_overview.dart';
import 'package:lebenswiki_app/presentation/widgets/interactions/custom_flushbar.dart';
import 'package:lebenswiki_app/presentation/widgets/navigation/top_nav.dart';
import 'package:lebenswiki_app/repository/backend/pack_api.dart';
import 'package:lebenswiki_app/repository/backend/short_api.dart';
import 'package:lebenswiki_app/repository/constants/colors.dart';
import 'package:lebenswiki_app/presentation/widgets/cards/pack_card.dart';
import 'package:lebenswiki_app/presentation/widgets/cards/short_card.dart';
import 'package:lebenswiki_app/application/other/loading_helper.dart';

class PackShortLists {
  List<Pack> packs = [];
  List<Short> shorts = [];

  PackShortLists();
}

class CreatedView extends ConsumerStatefulWidget {
  const CreatedView({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreatedViewState();
}

class _CreatedViewState extends ConsumerState<CreatedView> {
  late int userId;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  Widget build(BuildContext context) {
    userId = ref.read(userProvider).user.id;
    return Scaffold(
      body: SafeArea(
        child: DefaultTabController(
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
                                ? _buildEmptyText(
                                    "Du hast noch keine Packs gespeichert")
                                : ListView.builder(
                                    padding: const EdgeInsets.all(30.0),
                                    shrinkWrap: true,
                                    itemCount: right.packs.length,
                                    itemBuilder: (context, index) {
                                      Pack currentPack = right.packs[index];
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 40),
                                        child: SizedBox(
                                          width: 300,
                                          height: 250,
                                          child: Stack(
                                            children: [
                                              PackCard(
                                                read: Read(
                                                  pack: currentPack,
                                                  packId: currentPack.id!,
                                                  progress: 0,
                                                  userId: userId,
                                                ),
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
    await PackApi().getOwnPublishedpacks().fold((left) {}, (right) {
      result.packs.addAll(right);
    });
    await ShortApi().getOwnPublishedShorts().fold((left) {}, (right) {
      result.shorts.addAll(right);
    });
    await PackApi().getOwnUnpublishedPacks().fold((left) {}, (right) {
      result.packs.addAll(right);
    });
    await ShortApi().getCreatorsDraftShorts().fold((left) {}, (right) {
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
        child: Icon(
          Icons.settings,
          color: CustomColors.textBlack,
          size: 28,
        ),
        children: [
          SpeedDialChild(
            onTap: () async {
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          CreatorPackInfo(pack: currentPack)));
              setState(() {});
            },
            child: const Icon(Icons.edit_note_outlined),
            label: "Informationen Bearbeiten",
          ),
          SpeedDialChild(
            onTap: () async {
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          NewCreatorScreen(pack: currentPack)));
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
                  await PackApi().deletePack(currentPack.id).fold(
                    (left) {
                      Navigator.pop(context);
                      CustomFlushbar.error(message: left.error).show(context);
                    },
                    (right) async {
                      if (currentPack.imageIdentifier != "something") {
                        await _storage
                            .ref("pack_images/${currentPack.imageIdentifier}")
                            .listAll()
                            .then((ListResult itemsInDir) {
                          for (Reference item in itemsInDir.items) {
                            _storage.ref(item.fullPath).delete();
                          }
                        });
                      }
                      Navigator.pop(context);
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
      child: Icon(
        Icons.settings,
        color: CustomColors.textBlack,
        size: 28,
      ),
      children: [
        currentShort.published
            ? SpeedDialChild(
                onTap: () async {
                  await ShortApi().unpublishShort(currentShort.id).fold((left) {
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
                  await ShortApi().publishShort(currentShort.id).fold((left) {
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
                await ShortApi().deleteShort(id: currentShort.id).fold(
                  (left) {
                    Navigator.pop(context);
                    CustomFlushbar.error(message: left.error).show(context);
                  },
                  (right) {
                    Navigator.pop(context);
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
                    Navigator.pop(context);
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
