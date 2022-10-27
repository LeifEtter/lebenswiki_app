import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lebenswiki_app/main_wrapper.dart';
import 'package:lebenswiki_app/presentation/providers/provider_helper.dart';
import 'package:lebenswiki_app/presentation/screens/other/authentication.dart';
import 'package:lebenswiki_app/presentation/widgets/common/expand_row.dart';
import 'package:lebenswiki_app/presentation/widgets/interactions/custom_flushbar.dart';
import 'package:lebenswiki_app/presentation/widgets/lw.dart';
import 'package:lebenswiki_app/repository/backend/token_handler.dart';
import 'package:lebenswiki_app/repository/backend/user_api.dart';
import 'package:lebenswiki_app/repository/constants/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingViewStart extends ConsumerStatefulWidget {
  const OnboardingViewStart({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _OnboardingViewStartState();
}

class _OnboardingViewStartState extends ConsumerState<OnboardingViewStart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
          gradient: CustomColors.blueGradient,
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(),
              Column(
                children: [
                  SizedBox(
                    height: 150,
                    child: Image.asset("assets/images/lebenswiki_logo.png"),
                  ),
                  Text(
                    "Willkommen bei Lebenswiki",
                    style: Theme.of(context)
                        .textTheme
                        .headlineLarge!
                        .copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      "Lerne von Experten und teile gleichzeitig dein Wissen, Erfahrungen und deine Fragen mit der Community.",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Colors.white,
                          ),
                    ),
                  ),
                ],
              ),
              //TODO implement onboarding view instead
              Column(
                children: [
                  ExpandButton(
                    child: LW.buttons.normal(
                      borderRadius: 10.0,
                      text: "Weiter",
                      action: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const AuthenticationView()));
                      },
                    ),
                  ),
                  const SizedBox(height: 15),
                  ExpandButton(
                    child: LW.buttons.normal(
                      borderRadius: 10.0,
                      color: Colors.transparent,
                      textColor: CustomColors.offBlack,
                      text: "Einloggen",
                      border:
                          Border.all(width: 2, color: CustomColors.offBlack),
                      action: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const AuthenticationView()));
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  LW.buttons.normal(
                    text: "Überspringen und als Gast fortfahren",
                    color: Colors.transparent,
                    textColor: CustomColors.offBlack,
                    action: () async {
                      SharedPreferences _preferences =
                          await SharedPreferences.getInstance();
                      await UserApi().loginAnonymously().fold(
                        (left) {
                          CustomFlushbar.error(
                                  message:
                                      "Anonyme Registrierung ist nicht möglich")
                              .show(context);
                        },
                        (right) async {
                          await TokenHandler().set(right);
                          await ProviderHelper
                              .getDataAndSessionProvidersForAnonymous(ref);

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Scaffold(
                                body: NavBarWrapper(),
                              ),
                            ),
                          );
                        },
                      );
                      _preferences.setBool("onboardingFinished", true);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OnboardingView extends StatefulWidget {
  const OnboardingView({Key? key}) : super(key: key);

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _pageController = PageController();
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: CustomColors.blueGradient,
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 100),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/lebenswiki_logo.png",
                    width: 200,
                  ),
                ],
              ),
            ),
            PageView(
              controller: _pageController,
              children: [
                _page1(),
              ],
            ),
            Positioned(
              top: 70,
              left: 20,
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 35,
                  color: Colors.white,
                ),
                onPressed: () {
                  if (!(_pageController.page == 0)) {
                    _pageController.previousPage(
                        duration: const Duration(milliseconds: 350),
                        curve: Curves.easeInOut);
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 50,
                left: 30,
                right: 30,
              ),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ExpandButton(
                    child: LW.buttons.normal(
                  text: "Weiter",
                  action: () {},
                  verticalPadding: 10,
                  fontSize: 20,
                  borderRadius: 10.0,
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _page1() {
    return Column(children: [
      const SizedBox(height: 270),
      Center(
          child: Text("Super!",
              style: _obdTitle().copyWith(color: Colors.white, fontSize: 40))),
      Padding(
        padding: const EdgeInsets.only(left: 30, right: 30, top: 30),
        child: Container(
          padding: const EdgeInsets.all(30.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  spreadRadius: 2,
                  blurRadius: 4,
                  offset: Offset(1, 2),
                ),
              ]),
          child: Column(
            children: [
              const SizedBox(height: 5),
              Text("Verratest du uns deinen Namen?", style: _obdSubtitle()),
              const SizedBox(height: 30),
              TextField(
                controller: _nameController,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 23,
                ),
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  filled: true,
                  fillColor: CustomColors.lightGrey,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: CustomColors.mediumGrey,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: const OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
      )
    ]);
  }

  TextStyle _obdTitle() => TextStyle(
        color: CustomColors.offBlack,
        fontSize: 30,
        fontWeight: FontWeight.w500,
      );

  TextStyle _obdSubtitle() {
    return TextStyle(
      color: CustomColors.textGrey,
      fontSize: 20,
      fontWeight: FontWeight.w400,
    );
  }
}
