import 'dart:io';
import 'package:either_dart/either.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lebenswiki_app/application/other/image_helper.dart';
import 'package:lebenswiki_app/application/other/loading_helper.dart';
import 'package:lebenswiki_app/domain/models/error_model.dart';
import 'package:lebenswiki_app/domain/models/user_model.dart';
import 'package:lebenswiki_app/main_wrapper.dart';
import 'package:lebenswiki_app/presentation/providers/providers.dart';
import 'package:lebenswiki_app/presentation/widgets/interactions/custom_flushbar.dart';
import 'package:lebenswiki_app/presentation/widgets/navigation/top_nav.dart';
import 'package:lebenswiki_app/repository/backend/user_api.dart';
import 'package:lebenswiki_app/repository/constants/shadows.dart';

class AvatarScreen extends ConsumerStatefulWidget {
  const AvatarScreen({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AvatarScreenState();
}

class _AvatarScreenState extends ConsumerState<AvatarScreen> {
  final FirebaseStorage storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();
  late User user;
  bool _imageIsLoading = false;
  String? _chosenImageLink;

  @override
  Widget build(BuildContext context) {
    user = ref.watch(userProvider).user;
    return Scaffold(
        body: ListView(
      children: [
        TopNavIOS.withNextButton(
          title: "Wähle einen Avatar",
          nextTitle: "Erstellen",
          nextFunction: () async {
            await UserApi()
                .updateProfileImage(
                    profileImage: _chosenImageLink ??
                        "https://firebasestorage.googleapis.com/v0/b/lebenswiki-db.appspot.com/o/default_profile_image.jpg?alt=media&token=baf25998-6056-4858-9f00-c323bd4bfc0a")
                .fold((left) {
              CustomFlushbar.error(message: left.error).show(context);
            }, (right) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const Scaffold(
                      body: Scaffold(
                    body: NavBarWrapper(),
                  )),
                ),
              );
            });
          },
        ),
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
                            color: const Color.fromRGBO(255, 255, 255, 0.6),
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
    ));
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
        pathToStore: "user_profile_images/${user.id}/",
        chosenImage: File(pickedFile.path),
        userId: user.id,
        storage: storage);
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
}
