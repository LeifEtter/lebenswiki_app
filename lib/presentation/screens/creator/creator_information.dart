import 'package:either_dart/either.dart';
import 'package:go_router/go_router.dart';
import 'package:lebenswiki_app/application/other/loading_helper.dart';

import 'package:lebenswiki_app/domain/models/error.model.dart';
import 'package:lebenswiki_app/domain/models/pack/pack.model.dart';
import 'package:lebenswiki_app/domain/models/user/user.model.dart';
import 'package:lebenswiki_app/presentation/widgets/interactions/custom_flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lebenswiki_app/presentation/providers/providers.dart';
import 'package:lebenswiki_app/presentation/widgets/common/hacks.dart';
import 'package:lebenswiki_app/presentation/widgets/input/drop_down_menu.dart';
import 'package:lebenswiki_app/presentation/widgets/input/simplified_form_field.dart';
import 'package:lebenswiki_app/presentation/widgets/navigation/top_nav.dart';
import 'package:lebenswiki_app/domain/models/category.model.dart';
import 'package:lebenswiki_app/data/pack_api.dart';
import 'package:lebenswiki_app/presentation/constants/colors.dart';
import 'package:lebenswiki_app/presentation/constants/shadows.dart';

const String packPlaceholder = "assets/images/pack_placeholder_image.jpg";

class CreatorPackInfo extends ConsumerStatefulWidget {
  final Pack? pack;

  const CreatorPackInfo({super.key, this.pack});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreatorPackInfoState();
}

class _CreatorPackInfoState extends ConsumerState<CreatorPackInfo> {
  late User user;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _initiativeController = TextEditingController();

  String? errorTitle;
  String? errorDescription;

  final ImagePicker picker = ImagePicker();
  XFile? pickedImage;
  late String imageCurrentlyShowing;
  bool imageIsLoading = false;

  late List<DropDownItem> dropdownItems;
  late DropDownItem chosenItem;

  bool imageIsWeb(String image) => Uri.parse(image).isAbsolute;

  @override
  void initState() {
    dropdownItems = ref
        .read(categoryProvider)
        .categories
        .skip(0)
        .toList()
        .map<DropDownItem>((Category cat) => DropDownItem(
              id: cat.id,
              name: cat.name,
            ))
        .toList();

    user = ref.read(userProvider).user!;
    if (widget.pack != null) {
      _titleController.text = widget.pack!.title;
      _descriptionController.text = widget.pack!.description;
      _initiativeController.text = widget.pack!.initiative;
      // chosenItem = DropDownItem(
      //     id: widget.pack!.categories.first.id,
      //     name: widget.pack!.categories.first.name);
      chosenItem = dropdownItems
          .where((e) => e.id == widget.pack!.categories.first.id)
          .first;
      imageCurrentlyShowing = widget.pack!.titleImage!;
    } else {
      chosenItem = dropdownItems[0];
      imageCurrentlyShowing = packPlaceholder;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          TopNavIOS.withNextButton(
            title: "Erstelle ein Pack",
            nextTitle: "Speichern",
            nextFunction: () async {
              if (!validateFields()) {
                return;
              }
              Pack packToSave = Pack(
                title: _titleController.text,
                description: _descriptionController.text,
                pages: widget.pack != null ? widget.pack!.pages : [],
                initiative: _initiativeController.text,
                categories: [
                  Category(id: chosenItem.id, name: chosenItem.name),
                ],
                readTime: 1,
              );
              bool isUpdate = widget.pack != null;
              int packId;
              if (isUpdate) {
                Either<CustomError, Pack> updateRes =
                    await PackApi().updatePack(packToSave, widget.pack!.id!);
                if (updateRes.isLeft) {
                  CustomFlushbar.error(message: updateRes.left.error)
                      .show(context);
                  return;
                } else {
                  packId = updateRes.right.id!;
                }
              } else {
                Either<CustomError, Pack> createRes =
                    await PackApi().createPack(packToSave);

                if (createRes.isLeft) {
                  CustomFlushbar.error(message: createRes.left.error)
                      .show(context);
                  return;
                } else {
                  packId = createRes.right.id!;
                }
              }
              if (pickedImage != null) {
                print("Doing upload");
                Either<CustomError, String> imageUpload = await PackApi()
                    .uploadCoverImage(
                        pathToImage: pickedImage!.path, packId: packId);
                if (imageUpload.isLeft) {
                  CustomFlushbar.error(
                    message:
                        "Pack gespeichert, jedoch konnte das Bild nicht hochgeladen werden",
                  ).show(context);
                }
              }
              await context.push("/create/pack");
              CustomFlushbar.success(message: "Pack erfolgreich gespeichert")
                  .show(context);
            },
          ),
          ListView(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 100),
            shrinkWrap: true,
            children: [
              S.h30(),
              SimplifiedFormField(
                borderRadius: 15,
                color: CustomColors.lightGrey,
                controller: _titleController,
                errorText: errorTitle,
                labelText: "Titel*",
                onChanged: (newValue) => errorTitle != null
                    ? setState(() => errorTitle = null)
                    : null,
              ),
              S.h20(),
              SimplifiedFormField.multiline(
                maxLength: 500,
                borderRadius: 15,
                color: CustomColors.lightGrey,
                controller: _descriptionController,
                errorText: errorDescription,
                labelText: "Beschreibung*",
                minLines: 3,
                maxLines: 10,
                onChanged: (newValue) => errorDescription != null
                    ? setState(() => errorDescription = null)
                    : null,
              ),
              S.h20(),
              SimplifiedFormField(
                borderRadius: 15,
                color: CustomColors.lightGrey,
                controller: _initiativeController,
                labelText: "Initiative",
              ),
              S.h20(),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0, left: 3.0),
                child: Text(
                  "Kategorie Wählen",
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(fontSize: 16),
                ),
              ),
              CustomDropDownMenu(
                shadows: [LebenswikiShadows.fancyShadow],
                chosenValue: chosenItem,
                onPress: (DropDownItem item) =>
                    setState(() => chosenItem = item),
                items: dropdownItems,
              ),
              S.h30(),
              GestureDetector(
                onTap: () async {
                  XFile? file =
                      await picker.pickImage(source: ImageSource.gallery);

                  if (file != null) {
                    pickedImage = file;
                    setState(() => imageCurrentlyShowing = file.path);
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: [LebenswikiShadows.fancyShadow],
                    color: Colors.white,
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: imageIsWeb(imageCurrentlyShowing)
                            ? NetworkImage(imageCurrentlyShowing.replaceAll(
                                "https", "http"))
                            : AssetImage(imageCurrentlyShowing)
                                as ImageProvider),
                  ),
                  width: double.infinity,
                  height: 200,
                  child: imageIsLoading
                      ? LoadingHelper.loadingIndicator()
                      : imageCurrentlyShowing == packPlaceholder
                          ? Center(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromRGBO(255, 255, 255, 0.6),
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Text(
                                  "Bild Ändern",
                                  style: Theme.of(context).textTheme.labelSmall,
                                ),
                              ),
                            )
                          : Center(
                              child: Text(
                              "Wähle ein Bild",
                              style: Theme.of(context).textTheme.labelSmall,
                            )),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  bool validateFields() {
    if (_titleController.text.isEmpty) {
      errorTitle = "Schreibe hier deinen Titel";
    }
    if (_descriptionController.text.isEmpty) {
      errorDescription = "Schreibe hier deine Beschreibung";
    }
    if (_descriptionController.text.isEmpty || _titleController.text.isEmpty) {
      setState(() {});
      return false;
    }
    return true;
  }
}
