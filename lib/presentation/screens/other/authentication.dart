import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lebenswiki_app/presentation/widgets/interactions/custom_flushbar.dart';
import 'package:lebenswiki_app/presentation/widgets/lw.dart';
import 'package:lebenswiki_app/repository/backend/result_model_api.dart';
import 'package:lebenswiki_app/repository/backend/user_api.dart';
import 'package:lebenswiki_app/main_wrapper.dart';
import 'package:lebenswiki_app/presentation/widgets/input/custom_form_field.dart';
import 'package:lebenswiki_app/application/auth/authentication_functions.dart';
import 'package:lebenswiki_app/presentation/providers/auth_providers.dart';
import 'package:lebenswiki_app/domain/models/enums.dart';
import 'package:lebenswiki_app/repository/constants/colors.dart';

//TODO Add profile pick upload
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
  bool _defaultProfilePic = false;
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
                ),
              ),
              const SizedBox(height: 30.0),
              Visibility(
                visible: isSignUp ? true : false,
                child: CustomInputField(
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
              CustomInputField(
                paddingTop: 5,
                hintText: "Email Adresse",
                onChanged: _formProvider.validateEmail,
                errorText: _formProvider.email.error,
                icon: const Icon(Icons.local_post_office),
              ),
              Visibility(
                visible: isSignUp ? true : false,
                child: CustomInputField(
                  paddingTop: 5,
                  isMultiline: true,
                  hintText: "Biography",
                  onChanged: _formProvider.validateBiography,
                  errorText: _formProvider.biography.error,
                  icon: const Icon(Icons.note_alt_rounded),
                ),
              ),
              CustomInputField(
                paddingTop: 5,
                hintText: "Passwort",
                onChanged: _formProvider.validatePassword,
                errorText: _formProvider.password.error,
                icon: const Icon(Icons.key),
                isPassword: true,
              ),
              Visibility(
                visible: isSignUp,
                child: CustomInputField(
                  paddingTop: 5,
                  hintText: "Passwort Wiederholen",
                  onChanged: _formProvider.validateRepeatPassword,
                  errorText: _formProvider.repeatPassword.error,
                  icon: const Icon(Icons.key),
                  isPassword: true,
                ),
              ),
              const SizedBox(height: 10),
              Visibility(
                visible: isSignUp,
                child: Row(
                  children: [
                    const SizedBox(width: 9),
                    SizedBox(
                      height: 30,
                      width: 30,
                      child: Checkbox(
                          value: _defaultProfilePic,
                          onChanged: (value) => setState(() {
                                _defaultProfilePic = value!;
                              })),
                    ),
                    const Text("Das Standardprofilbild verwenden")
                  ],
                ),
              ),
              Visibility(
                visible: isSignUp ? true : false,
                child: CustomInputField(
                  enabled: !_defaultProfilePic,
                  hintText: "Profilbild",
                  errorText: _formProvider.profileImage.error,
                  onChanged: _formProvider.validateProfileImage,
                  icon: const Icon(Icons.image),
                ),
              ),
              LW.buttons.normal(
                borderRadius: 15,
                text: isSignUp ? "Registrieren" : "Einloggen",
                color: CustomColors.blue,
                action: () async {
                  if (isSignUp) {
                    if (await register()) {
                      CustomFlushbar.success(message: "Erfolgreich registriert")
                          .show(context);
                      toggleSignIn();
                    } else {
                      CustomFlushbar.error(
                          message: "Registrierung fehlgeschlagen");
                    }
                  } else {
                    if (await login()) {
                      navigateFeed();
                    } else {
                      CustomFlushbar.error(message: "Login fehlgeschlagen")
                          .show(context);
                    }
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 30),
                child: TextButton(
                  child: Text(
                    isSignUp
                        ? "Du hast schon ein Account?"
                        : "Du bist noch nicht registriert?",
                  ),
                  onPressed: () {
                    _formProvider.resetErrors();
                    toggleSignIn();
                  },
                ),
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

  Future<bool> register() async {
    if (!_formProvider.validateForRegister) return false;

    ResultModel result = await Authentication.register(_formProvider);
    return result.type == ResultType.failure ? false : true;
  }

  Future<bool> login() async {
    if (!_formProvider.validateForLogin) return false;

    ResultModel result = await Authentication.login(_formProvider, ref);
    return result.type == ResultType.failure ? false : true;
  }
}
