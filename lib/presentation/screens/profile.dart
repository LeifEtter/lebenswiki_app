import 'dart:ui';
import 'package:either_dart/either.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lebenswiki_app/repository/backend/user_api.dart';
import 'package:lebenswiki_app/presentation/widgets/hacks.dart';
import 'package:lebenswiki_app/presentation/widgets/other.dart';
import 'package:lebenswiki_app/presentation/widgets/top_nav.dart';
import 'package:lebenswiki_app/presentation/widgets/colors.dart';
import 'package:lebenswiki_app/presentation/widgets/lw.dart';
import 'package:lebenswiki_app/application/loading_helper.dart';
import 'package:lebenswiki_app/presentation/widgets/custom_flushbar.dart';
import 'package:lebenswiki_app/domain/models/user_model.dart';
import 'package:lebenswiki_app/repository/constants/shadows.dart';

class ProfileView extends ConsumerStatefulWidget {
  const ProfileView({
    Key? key,
  }) : super(key: key);

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
  TextEditingController nameController = TextEditingController();
  TextEditingController biographyController = TextEditingController();

  late String chosenAvatar;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("Rebuilding whole widget");
    return FutureBuilder(
      future: UserApi().getUserData(),
      builder: (BuildContext context,
          AsyncSnapshot<Either<CustomError, User>> snapshot) {
        if (LoadingHelper.isLoading(snapshot)) {
          return LoadingHelper.loadingIndicator();
        }
        return snapshot.data!.fold(
          (left) => Text(left.error),
          (user) {
            nameController.text = user.name;
            biographyController.text = user.biography;
            chosenAvatar = user.profileImage;
            return StatefulBuilder(
              builder: (context, setInnerState) {
                return Scaffold(
                  body: Stack(
                    children: [
                      Container(
                        padding:
                            const EdgeInsets.only(left: 20, right: 20, top: 10),
                        child: ListView(
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            const TopNavIOS(title: "Profil"),
                            const SizedBox(height: 160),
                            ExpandablePageView(
                              controller: pageController,
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
                                _buildShowProfile(user),
                                _buildEditProfile(setInnerState, user: user),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: isPickingAvatar,
                        child: _buildAvatarPicker(setInnerState),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 530),
                        child: Center(child: _buildAvatar()),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildShowProfile(User user) => ListView(
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
            action: () => pageController.animateToPage(1,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut),
          ),
          S.h40(),
          const Divider(),
          _buildLinkTile(text: "Account Einstellungen", onPressed: () {}),
          const Divider(),
          _buildLinkTile(text: "Privacy Policy", onPressed: () {}),
          const Divider(),
          _buildLinkTile(text: "Deine Shorts", onPressed: () {}),
        ],
      );

  Widget _buildEditProfile(Function setInnerState, {required User user}) =>
      ListView(
        padding: const EdgeInsets.only(bottom: 50),
        shrinkWrap: true,
        children: [
          TextButton(
              onPressed: () => setInnerState(() {
                    isPickingAvatar = true;
                  }),
              child: Text(
                "Profilbild ändern",
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
          singleInputField(controller: nameController),
          S.h20(),
          Text(
            "Biografie",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          S.h10(),
          singleInputField(controller: biographyController, isMultiline: true),
          S.h20(),
          LW.buttons.normal(
            text: "Speichern",
            action: () async {
              Either<CustomError, String> updateResult =
                  await UserApi().updateProfile(
                      user: User(
                profileImage: chosenAvatar,
                name: nameController.text,
                biography: biographyController.text,
                email: user.email,
              ));

              updateResult.fold(
                  (left) =>
                      CustomFlushbar.error(message: left.error).show(context),
                  (right) =>
                      CustomFlushbar.success(message: right).show(context));
              setState(() {});
              pageController.animateToPage(0,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut);
            },
            color: CustomColors.blue,
            borderRadius: 15,
          ),
        ],
      );

  Widget singleInputField({
    required TextEditingController controller,
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
        ),
      );

  Widget _buildAvatar() => Container(
        width: 130,
        height: 130,
        decoration: BoxDecoration(
          boxShadow: [LebenswikiShadows.cardShadow],
          shape: BoxShape.circle,
          image: chosenAvatar.startsWith("assets/")
              ? DecorationImage(image: AssetImage(chosenAvatar))
              : DecorationImage(
                  image: NetworkImage(chosenAvatar),
                ),
        ),
      );

  Widget _buildLinkTile({required String text, required Function onPressed}) =>
      Row(
        children: [
          TextButton(
            onPressed: () {},
            child: Text(
              text,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: CustomColors.blue),
            ),
          ),
        ],
      );

  Widget _buildAvatarPicker(Function setInnerState) => GestureDetector(
        onTap: () => setState(() {
          isPickingAvatar = false;
        }),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 1.5,
            sigmaY: 1.5,
          ),
          child: Container(
            color: const Color.fromRGBO(255, 255, 255, 0.2),
            child: Center(
              child: GestureDetector(
                onTap: () {},
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
                    padding: const EdgeInsets.all(20),
                    children: profileAvatars
                        .map((String avatarName) => _buildSingleAvatar(
                            context, setInnerState,
                            avatarName: avatarName + ".png"))
                        .toList(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1,
                      mainAxisSpacing: 10.0,
                      crossAxisSpacing: 10.0,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

  Widget _buildSingleAvatar(
    BuildContext context,
    Function setInnerState, {
    required String avatarName,
  }) {
    return GestureDetector(
      onTap: () => setInnerState(() {
        chosenAvatar = "assets/avatars/$avatarName";
        isPickingAvatar = false;
      }),
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
}
