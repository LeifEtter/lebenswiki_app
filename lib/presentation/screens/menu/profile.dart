import 'dart:ui';
import 'package:either_dart/either.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lebenswiki_app/application/auth/token_handler.dart';

import 'package:lebenswiki_app/presentation/providers/providers.dart';
import 'package:lebenswiki_app/data/user_api.dart';
import 'package:lebenswiki_app/presentation/widgets/common/hacks.dart';
import 'package:lebenswiki_app/presentation/widgets/navigation/top_nav.dart';
import 'package:lebenswiki_app/presentation/constants/colors.dart';
import 'package:lebenswiki_app/presentation/widgets/lw.dart';
import 'package:lebenswiki_app/application/other/loading_helper.dart';
import 'package:lebenswiki_app/presentation/widgets/interactions/custom_flushbar.dart';
import 'package:lebenswiki_app/domain/models/user/user.model.dart';
import 'package:lebenswiki_app/presentation/constants/shadows.dart';
import 'package:lebenswiki_app/presentation/constants/uri_repo.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileView extends ConsumerStatefulWidget {
  const ProfileView({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView> {
  final PageController pageController = PageController();
  final List<String> profileAvatars = [
    "001-bear",
    "002-dog",
    "003-cat",
    "004-rabbit",
    "005-koala",
    "006-rabbit-1",
    "007-fox",
    "008-panda",
    "009-weasel",
  ];
  bool isPickingAvatar = false;
  bool isEditingProfile = false;
  bool imageIsLoading = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController biographyController = TextEditingController();

  late String imageCurrentlyShowing;

  late String? chosenAvatar;
  late XFile? pickedImage;
  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    super.initState();
  }

  bool imageIsWeb(String image) => Uri.parse(image).isAbsolute;

  Future<void> logout() async {
    await TokenHandler().delete();
    ref.read(userProvider).removeUser();
    context.go("/login");
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: UserApi().getUserData(),
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        if (LoadingHelper.isLoading(snapshot)) {
          return LoadingHelper.loadingIndicator();
        }
        if (snapshot.data == null) {
          return const Text("error");
        }
        User user = snapshot.data!;
        imageCurrentlyShowing = user.profileImage ??
            user.avatar ??
            "assets/images/default_profile_image";

        nameController.text = user.name;
        biographyController.text = user.biography;
        return StatefulBuilder(
          builder: (context, setInnerState) {
            return Scaffold(
              body: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 20, right: 20, top: 0),
                    child: ListView(
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        const TopNavIOS(title: "Profil"),
                        const SizedBox(height: 20),
                        _buildAvatar(
                          user: user,
                          setInnerState: setInnerState,
                          pickImage: () async {
                            chosenAvatar = null;
                            XFile? file = await picker.pickImage(
                                source: ImageSource.gallery);

                            if (file != null) {
                              pickedImage = file;
                              setInnerState(
                                  () => imageCurrentlyShowing = file.path);
                            }
                          },
                        ),
                        ExpandablePageView(
                          controller: pageController,
                          onPageChanged: (index) => setInnerState(() =>
                              isEditingProfile = index == 0 ? false : true),
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            _buildShowProfile(
                                user: user,
                                deleteCallback: () => deleteAccount()),
                            _buildEditProfile(
                                user: user,
                                saveUser: () async {
                                  if (pickedImage != null) {
                                    user.avatar = null;
                                    await uploadImage(pickedImage!);
                                  } else if (chosenAvatar != null) {
                                    user.avatar =
                                        "assets/avatars/$chosenAvatar";
                                  }
                                  await updateProfile(user);
                                  Future.delayed(
                                      const Duration(milliseconds: 1000));
                                  setState(() {});
                                },
                                openAvatarPicker: () =>
                                    setInnerState(() => isPickingAvatar = true))
                          ],
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: isPickingAvatar,
                    child: _buildAvatarPicker(
                      avatarCallback: (avatarName) => setInnerState(() {
                        chosenAvatar = avatarName;
                        pickedImage = null;
                        imageCurrentlyShowing = "assets/avatars/$chosenAvatar";
                        isPickingAvatar = false;
                      }),
                      closeAvatarPicker: () =>
                          setInnerState(() => isPickingAvatar = false),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildShowProfile({
    required User user,
    required Function deleteCallback,
  }) =>
      ListView(
        shrinkWrap: true,
        children: [
          S.h20(),
          Center(
            child: Text(
              user.name,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          S.h10(),
          Center(
            child: Text(
              user.biography,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          S.h20(),
          LW.buttons.normal(
            borderRadius: 10,
            color: CustomColors.lightGrey,
            text: "Profil Bearbeiten",
            textColor: CustomColors.offBlack,
            action: () {
              //setInnerState(() {});
              pageController.animateToPage(1,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut);
            },
          ),
          S.h40(),
          const Divider(),
          _buildLinkTile(
              text: "Datenschutzerklärung",
              onPressed: () async {
                Uri _url = UriRepo.dataProtectionUrl;
                await canLaunchUrl(_url)
                    ? await launchUrl(_url)
                    : throw 'Could not launch $_url';
              }),
          const Divider(),
          _buildLinkTile(
            text: "Cookie-Richtlinie",
            onPressed: () async {
              Uri _url = UriRepo.cookieUrl;
              await canLaunchUrl(_url)
                  ? await launchUrl(_url)
                  : throw 'Could not launch $_url';
            },
          ),
          const Divider(),
          _buildLinkTile(
            text: "Account Löschen",
            textColor: Colors.redAccent,
            onPressed: deleteCallback,
          )
        ],
      );

  Widget _buildEditProfile(
          {required User user,
          required Function saveUser,
          required void Function() openAvatarPicker}) =>
      ListView(
        padding: const EdgeInsets.only(bottom: 50),
        shrinkWrap: true,
        children: [
          S.h20(),
          const Center(
              child: Text(
            "oder",
            style:
                TextStyle(fontWeight: FontWeight.w400, color: Colors.black54),
          )),
          TextButton(
              onPressed: openAvatarPicker,
              child: Text(
                "Avatar Verwenden",
                style: TextStyle(
                  color: CustomColors.blue,
                ),
              )),
          S.h20(),
          Text(
            "Name",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          S.h10(),
          singleInputField(
              controller: nameController,
              onChangeCallback: (value) => user.name = value),
          S.h20(),
          Text(
            "Biografie",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          S.h10(),
          singleInputField(
            controller: biographyController,
            isMultiline: true,
            onChangeCallback: (value) => user.biography = value,
          ),
          S.h20(),
          LW.buttons.normal(
            text: "Speichern",
            action: saveUser,
            color: CustomColors.blue,
            borderRadius: 15,
          ),
        ],
      );

  Widget singleInputField({
    required TextEditingController controller,
    required Function(String value) onChangeCallback,
    bool isMultiline = false,
  }) =>
      Container(
        decoration: BoxDecoration(
          color: CustomColors.lightGrey,
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: TextFormField(
          minLines: isMultiline ? 3 : 1,
          maxLines: isMultiline ? 5 : 1,
          controller: controller,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            border: InputBorder.none,
          ),
          onChanged: (value) => onChangeCallback(value),
        ),
      );

  Widget _buildAvatar({
    required User user,
    required Function setInnerState,
    required void Function() pickImage,
  }) =>
      GestureDetector(
        onTap: pickImage,
        child: Container(
          width: 130,
          height: 130,
          decoration: BoxDecoration(
            boxShadow: [LebenswikiShadows.cardShadow],
            shape: BoxShape.circle,
            image: DecorationImage(
              image: imageIsWeb(imageCurrentlyShowing)
                  ? NetworkImage(
                      imageCurrentlyShowing.replaceAll("https", "http"))
                  : AssetImage(imageCurrentlyShowing) as ImageProvider,
              fit: BoxFit.contain,
              // colorFilter: const ColorFilter.linearToSrgbGamma(),
            ),
          ),
          child: isEditingProfile
              ? const Icon(Icons.camera_alt, color: Colors.white, size: 40)
              : null,
        ),
      );

  Widget _buildLinkTile(
          {required String text,
          required Function onPressed,
          Color? textColor}) =>
      Row(
        children: [
          TextButton(
            onPressed: () => onPressed(),
            child: Text(
              text,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: textColor ?? CustomColors.blue),
            ),
          ),
        ],
      );

  Widget _buildAvatarPicker(
          {required void Function(String avatarName) avatarCallback,
          required void Function() closeAvatarPicker}) =>
      GestureDetector(
        onTap: closeAvatarPicker,
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 1.5,
            sigmaY: 1.5,
          ),
          child: Container(
            color: const Color.fromRGBO(255, 255, 255, 0.2),
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 10.0,
                        spreadRadius: 3.0,
                        color: Color.fromRGBO(200, 200, 200, 0.4),
                      ),
                    ]),
                width: 350,
                height: 350,
                child: GridView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(20),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1,
                    mainAxisSpacing: 10.0,
                    crossAxisSpacing: 10.0,
                  ),
                  children: profileAvatars
                      .map((String avatarName) => _buildSingleAvatar(
                          avatarCallback: avatarCallback,
                          avatarName: "$avatarName.png"))
                      .toList(),
                ),
              ),
            ),
          ),
        ),
      );

  Widget _buildSingleAvatar({
    required Function(String avatarName) avatarCallback,
    required String avatarName,
  }) {
    return GestureDetector(
      onTap: () => avatarCallback(avatarName),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          boxShadow: [LebenswikiShadows.cardShadow],
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(
              "assets/avatars/$avatarName",
            ),
          ),
        ),
      ),
    );
  }

  Future uploadImage(XFile file) async =>
      await UserApi().uploadAvatar(pathToImage: file.path).fold(
          (left) => CustomFlushbar.error(
                  message: "Avatar konnte nicht hochgeladen werden")
              .show(context), (right) {
        CustomFlushbar.success(message: "Avatar erfolgreich hochgeladen")
            .show(context);
        setState(() => imageIsLoading = false);
      });

  Future<void> updateProfile(User user) async {
    await UserApi()
        .updateProfile(user: user)
        .fold((left) => CustomFlushbar.error(message: left.error).show(context),
            (right) {
      CustomFlushbar.success(message: "Profil geändert").show(context);
      pageController.animateToPage(0,
          duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
    });
  }

  Future<void> deleteAccount() async => await showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text("Account löschen"),
                content:
                    const Text("Willst du dieses account wirklich löschen?"),
                actions: [
                  TextButton(
                    onPressed: () => context.pop(),
                    child: const Text("Löschen",
                        style: TextStyle(color: Colors.red)),
                  ),
                  TextButton(
                    onPressed: () => context.pop(),
                    child: const Text("Abbrechen"),
                  ),
                ],
              )).then((deleteConfirmed) async {
        if (deleteConfirmed) {
          await UserApi().deleteAccount().fold((left) {
            CustomFlushbar.error(message: left.error).show(context);
          }, (right) {
            CustomFlushbar.success(message: right).show(context);
            logout();
          });
        }
      });
}
