import 'dart:ui';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lebenswiki_app/features/a_new_common/hacks.dart';
import 'package:lebenswiki_app/features/a_new_common/top_nav.dart';
import 'package:lebenswiki_app/features/a_new_widget_repo/colors.dart';
import 'package:lebenswiki_app/features/a_new_widget_repo/lw.dart';
import 'package:lebenswiki_app/features/authentication/components/custom_form_field.dart';
import 'package:lebenswiki_app/features/authentication/providers/auth_providers.dart';
import 'package:lebenswiki_app/models/user_model.dart';
import 'package:lebenswiki_app/providers/providers.dart';
import 'package:lebenswiki_app/repository/shadows.dart';

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
  late FormNotifier _formProvider;

  @override
  Widget build(BuildContext context) {
    User user = ref.read(userProvider).user;
    _formProvider = ref.watch(formProvider);
    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
            child: ListView(
              physics: const NeverScrollableScrollPhysics(),
              children: [
                const TopNavIOS(title: "Profil"),
                S.h100(),
                S.h90(),
                ExpandablePageView(
                  controller: pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    ListView(
                      shrinkWrap: true,
                      children: [
                        Center(
                          child: Text(
                            "Fritz Haber",
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
                        _buildLinkTile(
                            text: "Account Einstellungen", onPressed: () {}),
                        const Divider(),
                        _buildLinkTile(
                            text: "Privacy Policy", onPressed: () {}),
                        const Divider(),
                        _buildLinkTile(text: "Deine Shorts", onPressed: () {}),
                      ],
                    ),
                    ListView(
                      padding: const EdgeInsets.only(bottom: 50),
                      shrinkWrap: true,
                      children: [
                        TextButton(
                            onPressed: () => setState(() {
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
                        CustomInputField(
                          hasShadow: false,
                          hintText: "Vorname Nachname",
                          errorText: _formProvider.name.error,
                          onChanged: _formProvider.validateName,
                          borderRadius: 10.0,
                          backgroundColor: CustomColors.lightGrey,
                        ),
                        S.h20(),
                        Text(
                          "Biografie",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        S.h10(),
                        CustomInputField(
                          hasShadow: false,
                          hintText: "Biografie",
                          errorText: _formProvider.biography.error,
                          onChanged: _formProvider.validateBiography,
                          borderRadius: 10.0,
                          isMultiline: true,
                          backgroundColor: CustomColors.lightGrey,
                        ),
                        S.h20(),
                        LW.buttons.normal(
                          text: "Speichern",
                          action: () {
                            //Speichern
                            pageController.animateToPage(0,
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.easeInOut);
                          },
                          color: CustomColors.blue,
                          borderRadius: 15,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Visibility(
            visible: isPickingAvatar,
            child: _buildAvatarPicker(),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 530),
            child: Center(child: _buildAvatar(user: user)),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar({required User user}) => Container(
        width: 130,
        height: 130,
        decoration: BoxDecoration(
          boxShadow: [LebenswikiShadows.cardShadow],
          shape: BoxShape.circle,
          image: user.profileImage.startsWith("assets/")
              ? DecorationImage(image: AssetImage(user.profileImage))
              : DecorationImage(
                  image: NetworkImage(user.profileImage),
                ),
        ),
      );

  Widget _buildSingleAvatar(
    BuildContext context, {
    required String avatarName,
  }) {
    User user = ref.read(userProvider).user;
    return GestureDetector(
      onTap: () {
        setState(() {
          user.profileImage = "assets/avatars/$avatarName";
        });
      },
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

  Widget _buildAvatarPicker() => GestureDetector(
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
                        .map((String avatarName) => _buildSingleAvatar(context,
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
}
