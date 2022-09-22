import 'dart:developer';
import 'package:either_dart/either.dart';
import 'package:lebenswiki_app/application/image_helper.dart';
import 'package:lebenswiki_app/application/loading_helper.dart';
import 'package:lebenswiki_app/domain/models/error_model.dart';
import 'package:lebenswiki_app/domain/models/pack_model.dart';
import 'package:lebenswiki_app/domain/models/user_model.dart';
import 'package:lebenswiki_app/presentation/widgets/interactions/custom_flushbar.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lebenswiki_app/presentation/providers/providers.dart';
import 'package:lebenswiki_app/presentation/widgets/common/hacks.dart';
import 'package:lebenswiki_app/presentation/widgets/input/drop_down_menu.dart';
import 'package:lebenswiki_app/presentation/widgets/input/simplified_form_field.dart';
import 'package:lebenswiki_app/presentation/widgets/navigation/top_nav.dart';
import 'package:lebenswiki_app/domain/models/category_model.dart';
import 'package:lebenswiki_app/repository/backend/pack_api.dart';
import 'package:lebenswiki_app/repository/constants/colors.dart';
import 'package:lebenswiki_app/repository/constants/shadows.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CreatorPackInfo extends ConsumerStatefulWidget {
  final Pack? pack;

  const CreatorPackInfo({
    Key? key,
    this.pack,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreatorPackInfoState();
}

class _CreatorPackInfoState extends ConsumerState<CreatorPackInfo> {
  final FirebaseStorage storage = FirebaseStorage.instance;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _initiativeController = TextEditingController();

  bool _imageIsLoading = false;

  String? errorTitle;
  String? errorDescription;

  String? _chosenImageLink;
  final ImagePicker _picker = ImagePicker();

  String chosenCategory = "Neu";
  late List<ContentCategory> categories;
  late User user;

  @override
  void initState() {
    if (widget.pack != null) {
      _titleController.text = widget.pack!.title;
      _descriptionController.text = widget.pack!.description;
      _chosenImageLink = widget.pack!.titleImage;
      _initiativeController.text = widget.pack!.initiative ?? "";
      chosenCategory = widget.pack!.categories.first.categoryName;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    categories = ref.watch(categoryProvider).categories;
    user = ref.watch(userProvider).user;
    return Scaffold(
      body: ListView(
        children: [
          TopNavIOS.withNextButton(
            title: "Erstelle ein Pack",
            nextTitle: "Speichern",
            nextFunction: () => save(),
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
                onChanged: (_) {
                  if (errorTitle != null) {
                    setState(() {
                      errorTitle = null;
                    });
                  }
                },
              ),
              S.h20(),
              SimplifiedFormField.multiline(
                maxLength: 100,
                borderRadius: 15,
                color: CustomColors.lightGrey,
                controller: _descriptionController,
                errorText: errorDescription,
                labelText: "Beschreibung*",
                minLines: 3,
                maxLines: 5,
                onChanged: (_) {
                  if (errorDescription != null) {
                    setState(() {
                      errorDescription = null;
                    });
                  }
                },
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
                chosenValue: chosenCategory,
                onPress: (newCategory) => setState(() {
                  chosenCategory = newCategory;
                }),
                items: List<String>.from(categories
                    .map((ContentCategory cat) => cat.categoryName)
                    .toList()),
              ),
              S.h30(),
              GestureDetector(
                onTap: () => upload(context),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: [LebenswikiShadows.fancyShadow],
                    color: Colors.white,
                    image: _chosenImageLink != null
                        ? DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                              _chosenImageLink!,
                            ))
                        : null,
                  ),
                  width: double.infinity,
                  height: 200,
                  child: _imageIsLoading
                      ? LoadingHelper.loadingIndicator()
                      : _chosenImageLink != null
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

  void upload(context) async {
    setState(() => _imageIsLoading = true);
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      setState(() => _imageIsLoading = false);
      return;
    }
    if (_chosenImageLink != null) {
      await storage.refFromURL(_chosenImageLink!).delete();
    }
    Either<CustomError, String> result = await ImageHelper.uploadImage(context,
        chosenImage: File(pickedFile.path), userId: user.id, storage: storage);
    result.fold(
      (left) {
        CustomFlushbar.error(message: left.error).show(context);
      },
      (right) {
        CustomFlushbar.success(message: "Bild erfolgreich hochgeladen")
            .show(context);
        setState(() {
          _imageIsLoading = false;
          _chosenImageLink = right;
        });
      },
    );
  }

  void save() async {
    if (_titleController.text.isEmpty) {
      errorTitle = "Schreibe hier deinen Titel";
    }
    if (_descriptionController.text.isEmpty) {
      errorDescription = "Schreibe hier deine Beschreibung";
    }
    if (_descriptionController.text.isEmpty || _titleController.text.isEmpty) {
      setState(() {});
      return;
    }
    if (_initiativeController.text.isEmpty) {
      _initiativeController.text = "Keine Initiative";
    }

    Pack newPack = Pack(
      title: _titleController.text,
      description: _descriptionController.text,
      titleImage: _chosenImageLink ??
          "https://firebasestorage.googleapis.com/v0/b/lebenswiki-db.appspot.com/o/defaultImages%2Fpack_placeholder_image.jpg?alt=media&token=d61d13f9-0b5b-4f62-9d3e-c76a637392af",
      pages: [],
      creatorId: user.id,
      creator: user,
      initiative: _initiativeController.text,
      categories: [
        categories
            .where((ContentCategory cat) => cat.categoryName == chosenCategory)
            .first
      ],
      readTime: 0,
    );

    await PackApi().createPack(pack: newPack).fold((left) {
      CustomFlushbar.error(message: left.error);
    }, (right) {
      CustomFlushbar.success(message: "Pack wurde erstellt, id $right")
          .show(context);
    });
    return;
  }
}
