import 'dart:developer';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lebenswiki_app/application/other/loading_helper.dart';

import 'package:lebenswiki_app/domain/models/error.model.dart';
import 'package:lebenswiki_app/domain/models/user/user.model.dart';
import 'package:lebenswiki_app/presentation/widgets/interactions/custom_flushbar.dart';
import 'package:lebenswiki_app/presentation/widgets/navigation/top_nav.dart';
import 'package:lebenswiki_app/data/user_api.dart';
import 'package:lebenswiki_app/presentation/constants/shadows.dart';

class AvatarScreen extends ConsumerStatefulWidget {
  const AvatarScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AvatarScreenState();
}

class _AvatarScreenState extends ConsumerState<AvatarScreen> {
  final ImagePicker _picker = ImagePicker();
  late XFile? pickedImage;
  late User user;
  bool _imageIsLoading = false;
  String? _chosenImageLink;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: [
        TopNavIOS.withNextButton(
          title: "Wähle einen Avatar",
          nextTitle: "Fertig",
          nextFunction: () => context.go("/"),
        ),
        GestureDetector(
          onTap: () => pickAndUpload().fold(
              (left) => CustomFlushbar.error(
                    message: left.error,
                  ),
              (right) => CustomFlushbar.success(message: right)),
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
        TextButton(
          child: const Text("Ohne Avatar Fortfahren"),
          onPressed: () async {
            Either<CustomError, String> defaultAvatarResult =
                await UserApi().defaultAvatar();
            if (defaultAvatarResult.isLeft) {
              CustomFlushbar.error(message: "Irgendwas ist schiefgelaufen")
                  .show(context);
            } else {
              context.go("/");
            }
          },
        ),
      ],
    ));
  }

  Future<Either<CustomError, String>> pickAndUpload() async {
    try {
      setState(() => _imageIsLoading = true);
      pickedImage = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedImage == null) {
        setState(() => _imageIsLoading = false);
        return const Left(CustomError(error: "Kein Avatar ausgewählt"));
      }
      String pathToImage = pickedImage!.path;
      Either<CustomError, Map<String, dynamic>> uploadResult =
          await UserApi().uploadAvatar(pathToImage: pathToImage);
      if (uploadResult.isLeft) {
        return const Left(
            CustomError(error: "Bild konnte nicht hochgeladen werden"));
      } else {
        log(uploadResult.right["url"]);
        _imageIsLoading = false;
        setState(() => _chosenImageLink = uploadResult.right["url"]);
        return const Right("Avatar erfolgreich hochgeladen");
      }
    } catch (error) {
      log(inspect(error).toString());
      return const Left(
          CustomError(error: "Bild konnte nicht hochgeladen werden"));
    }
  }
}
