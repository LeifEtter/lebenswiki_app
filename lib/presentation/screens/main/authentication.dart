import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:lebenswiki_app/application/auth/prefs_handler.dart';
import 'package:lebenswiki_app/application/auth/token_handler.dart';
import 'package:lebenswiki_app/application/routing/router.dart';
import 'package:lebenswiki_app/domain/models/error.model.dart';
import 'package:lebenswiki_app/domain/models/user/user.model.dart';
import 'package:lebenswiki_app/presentation/providers/providers.dart';
import 'package:lebenswiki_app/presentation/widgets/interactions/custom_flushbar.dart';
import 'package:lebenswiki_app/presentation/widgets/lw.dart';
import 'package:lebenswiki_app/data/user_api.dart';
import 'package:lebenswiki_app/presentation/widgets/input/custom_form_field.dart';
import 'package:lebenswiki_app/presentation/providers/auth_providers.dart';
import 'package:lebenswiki_app/presentation/constants/colors.dart';
import 'package:lebenswiki_app/presentation/constants/uri_repo.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthenticationView extends ConsumerStatefulWidget {
  final bool? startWithRegister;

  const AuthenticationView({
    super.key,
    this.startWithRegister,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AuthenticationViewState();
}

class _AuthenticationViewState extends ConsumerState<AuthenticationView> {
  final UserApi userApi = UserApi();
  late FormNotifier _formProvider;
  bool isAdminSignUp = false;
  bool isSignUp = false;
  final GlobalKey<FormState> _authFormKey = GlobalKey<FormState>();
  bool acceptedToPolicy = false;

  void toggleSignIn() => setState(() {
        isSignUp = !isSignUp;
        _formProvider.resetErrors();
      });

  @override
  void initState() {
    if (widget.startWithRegister == true) {
      isSignUp = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);
    double scHeight = queryData.size.height;
    _formProvider = ref.watch(formProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.only(
            top: scHeight / (isSignUp ? 12 : 6), left: 30, right: 30.0),
        child: Form(
          key: _authFormKey,
          child: ListView(
            children: [
              Center(
                child: Text(
                  isSignUp ? "Registrieren" : "Login",
                  style: Theme.of(context)
                      .textTheme
                      .headlineLarge!
                      .copyWith(fontSize: 40, color: CustomColors.offBlack),
                ),
              ),
              const SizedBox(height: 30.0),
              Visibility(
                visible: isSignUp ? true : false,
                child: CustomInputField(
                  hasShadow: false,
                  backgroundColor: CustomColors.lightGrey,
                  paddingTop: 5,
                  hintText: "Vorname Nachname",
                  errorText: _formProvider.name.error,
                  icon: const Icon(Icons.person),
                  onChanged: _formProvider.validateName,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r"[a-zA-Z]+|\s"),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 5),
              CustomInputField(
                hasShadow: false,
                backgroundColor: CustomColors.lightGrey,
                paddingTop: 5,
                hintText: "Email Adresse",
                onChanged: _formProvider.validateEmail,
                errorText: _formProvider.email.error,
                icon: const Icon(Icons.local_post_office),
              ),
              const SizedBox(height: 5),
              Visibility(
                visible: isSignUp ? true : false,
                child: CustomInputField(
                  hasShadow: false,
                  backgroundColor: CustomColors.lightGrey,
                  paddingTop: 5,
                  isMultiline: true,
                  hintText: "Biography",
                  onChanged: _formProvider.validateBiography,
                  errorText: _formProvider.biography.error,
                  icon: const Icon(Icons.note_alt_rounded),
                ),
              ),
              SizedBox(height: isSignUp ? 10 : 0),
              CustomInputField(
                hasShadow: false,
                backgroundColor: CustomColors.lightGrey,
                paddingTop: 5,
                hintText: "Passwort",
                onChanged: _formProvider.validatePassword,
                errorText: _formProvider.password.error,
                icon: const Icon(Icons.key),
                isPassword: true,
              ),
              const SizedBox(height: 5),
              Visibility(
                visible: isSignUp,
                child: CustomInputField(
                  hasShadow: false,
                  backgroundColor: CustomColors.lightGrey,
                  paddingTop: 5,
                  hintText: "Passwort Wiederholen",
                  onChanged: _formProvider.validateRepeatPassword,
                  errorText: _formProvider.repeatPassword.error,
                  icon: const Icon(Icons.key),
                  isPassword: true,
                ),
              ),
              const SizedBox(height: 8),
              //TODO Add Forgot Password button
              /*Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Passwort Vergessen",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: CustomColors.darkBlue,
                    ),
                  )
                ],
              ),*/
              const SizedBox(height: 20),
              const SizedBox(height: 5),
              LW.buttons.normal(
                borderRadius: 15,
                text: isSignUp ? "Registrieren" : "Einloggen",
                color: CustomColors.blue,
                action: isSignUp ? handleRegister : handleLogin,
              ),
              Visibility(
                visible: isSignUp,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 30,
                      height: 15,
                      child: Checkbox(
                        value: acceptedToPolicy,
                        onChanged: (newValue) => setState(() {
                          acceptedToPolicy = newValue!;
                        }),
                      ),
                    ),
                    Row(
                      children: [
                        const Text(
                          "Hiermit akzeptiere ich die",
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(0),
                          child: SizedBox(
                            width: 40,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.only(left: 0),
                              ),
                              onPressed: showAGB,
                              child: Text(
                                "AGB",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: CustomColors.blue,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  isSignUp
                      ? Container()
                      : Text(
                          "Neu bei Lebenswiki?",
                          style: TextStyle(
                            fontSize: 15,
                            color: CustomColors.textGrey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                  TextButton(
                    child: Text(
                      isSignUp ? "Du hast schon ein Account?" : "Registrieren",
                      style: TextStyle(
                        fontSize: 14,
                        color: CustomColors.darkBlue,
                      ),
                    ),
                    onPressed: () {
                      _formProvider.resetErrors();
                      toggleSignIn();
                    },
                  ),
                ],
              ),
              TextButton(
                onPressed: handleAnonymousLogin,
                child: Text(
                  "Anonym Einloggen",
                  style: TextStyle(
                    fontSize: 14.0,
                    color: CustomColors.blue,
                  ),
                ),
              ),
              const SizedBox(height: 100),
              Row(
                children: [
                  Flexible(
                    flex: 50,
                    child: GestureDetector(
                      onTap: () async {
                        await launchUrl(Uri.parse("https://www.bmfsfj.de/"));
                      },
                      child: SvgPicture.asset(
                        "assets/images/Bundesministerium_Logo.svg",
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 50,
                    child: GestureDetector(
                      onTap: () async {
                        await launchUrl(Uri.parse(
                            "https://www.bmfsfj.de/bmfsfj/themen/kinder-und-jugend/jugendbildung/jugendstrategie?view="));
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Image.asset(
                          "assets/images/jugendstrategie-logo.png",
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void handleAnonymousLogin() async {
    await PrefHandler.setIsBrowsingAnonymously(true);
    // TODO: Add when adding onboarding
    // await PrefHandler.setHasCompletedOnboarding(true);
    await TokenHandler().delete();
    await navigateFeed();
  }

  void handleLogin() async {
    if (!_formProvider.validateForLogin) return;
    Either<CustomError, UserTokenResponse> userResult = await UserApi().login(
        email: _formProvider.email.value!,
        password: _formProvider.password.value!);
    if (userResult.isLeft) {
      CustomFlushbar.error(message: userResult.left.error);
    } else {
      User user = userResult.right.user;
      await PrefHandler.setIsBrowsingAnonymously(false);
      await TokenHandler().set(userResult.right.token);
      ref.read(userProvider).setUser(user);
      if (user.isFirstLogin == true) {
        await navigateAvatar();
      } else {
        await navigateFeed();
      }
    }
  }

  void handleRegister() async {
    if (!_formProvider.validateForRegister) return;
    if (!acceptedToPolicy) {
      CustomFlushbar.error(
              message:
                  "Du musst die AGB akzeptieren bevor du ein Account erstellen kannst")
          .show(context);
      return;
    }
    await UserApi().register(_formProvider.convertToUser()).fold((left) {
      CustomFlushbar.error(message: left.error).show(context);
    }, (right) {
      CustomFlushbar.success(message: "Erfolgreich registriert").show(context);
      toggleSignIn();
    });
  }

  void showAGB() async {
    Uri url = UriRepo.termsAndConditions;
    await canLaunchUrl(url)
        ? await launchUrl(url)
        : throw 'Could not launch $url';
  }

  Future<void> navigateFeed() async => context.go("/");
  Future<void> navigateAvatar() async => context.go("/setAvatar");
}
