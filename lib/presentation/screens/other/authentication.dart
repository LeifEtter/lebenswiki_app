import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lebenswiki_app/presentation/screens/other/avatar_screen.dart';
import 'package:lebenswiki_app/presentation/widgets/interactions/custom_flushbar.dart';
import 'package:lebenswiki_app/presentation/widgets/lw.dart';
import 'package:lebenswiki_app/repository/backend/user_api.dart';
import 'package:lebenswiki_app/main_wrapper.dart';
import 'package:lebenswiki_app/presentation/widgets/input/custom_form_field.dart';
import 'package:lebenswiki_app/application/auth/authentication_functions.dart';
import 'package:lebenswiki_app/presentation/providers/auth_providers.dart';
import 'package:lebenswiki_app/repository/constants/colors.dart';
import 'package:lebenswiki_app/repository/constants/image_repo.dart';

class AuthenticationView extends ConsumerStatefulWidget {
  const AuthenticationView({Key? key}) : super(key: key);

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

  void toggleSignIn() => setState(() {
        isSignUp = !isSignUp;
        _formProvider.resetErrors();
      });

  void toggleAdminSignup() => setState(() {
        isAdminSignUp = !isAdminSignUp;
      });

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);
    double scHeight = queryData.size.height;
    _formProvider = ref.watch(formProvider);

    return Scaffold(
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
              const SizedBox(height: 10),
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
              Row(
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
              ),
              const SizedBox(height: 20),
              const SizedBox(height: 5),
              LW.buttons.normal(
                borderRadius: 15,
                text: isSignUp ? "Registrieren" : "Einloggen",
                color: CustomColors.blue,
                action: () async {
                  if (isSignUp) {
                    if (!_formProvider.validateForRegister) return;
                    await UserApi()
                        .register(_formProvider.convertToUser())
                        .fold((left) {
                      CustomFlushbar.error(message: left.error).show(context);
                    }, (right) {
                      CustomFlushbar.success(message: "Erfolgreich registriert")
                          .show(context);
                      toggleSignIn();
                    });
                  } else {
                    if (!_formProvider.validateForLogin) return;
                    await Authentication.login(_formProvider, ref).fold(
                      (left) {
                        CustomFlushbar.error(
                                message: "Irgendwas ist schiefgelaufen")
                            .show(context);
                      },
                      (right) {
                        if (right.profileImage ==
                            ImageRepo.standardProfileImage) {
                          navigateAvatar();
                        } else {
                          navigateFeed();
                        }
                      },
                    );
                  }
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
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
                        fontSize: 15,
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
            ],
          ),
        ),
      ),
    );
  }

  void navigateFeed() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: NavBarWrapper(),
        ),
      ),
    );
  }

  void navigateAvatar() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: AvatarScreen(),
        ),
      ),
    );
  }
}
