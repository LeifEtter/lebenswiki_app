import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lebenswiki_app/api/general/result_model_api.dart';
import 'package:lebenswiki_app/api/token/token_handler.dart';
import 'package:lebenswiki_app/api/user_api.dart';
import 'package:lebenswiki_app/features/authentication/components/custom_form_field.dart';
import 'package:lebenswiki_app/features/authentication/providers/auth_providers.dart';
import 'package:lebenswiki_app/repos/image_repo.dart';
import 'package:lebenswiki_app/features/common/components/buttons/authentication_buttons.dart';
import 'package:lebenswiki_app/features/styling/colors.dart';
import 'package:lebenswiki_app/features/styling/text_styles.dart';
import 'package:lebenswiki_app/main.dart';
import 'package:lebenswiki_app/models/enums.dart';
import 'package:lebenswiki_app/models/user_model.dart';
import 'package:lebenswiki_app/providers/providers.dart';

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
      body: SizedBox(
        child: Padding(
          padding: EdgeInsets.only(
              top: scHeight / (isSignUp ? 12 : 6), left: 30, right: 30.0),
          child: Form(
            key: _authFormKey,
            child: ListView(
              children: [
                Center(
                  child: Text(
                    isSignUp ? "Registrieren" : "Login",
                    style: LebenswikiTextStyles
                        .authenticationContent.authenticationTitle,
                  ),
                ),
                const SizedBox(height: 30.0),
                CustomInputField(
                  paddingTop: 5,
                  hintText: "Vorname Nachname",
                  errorText: _formProvider.name.error,
                  iconData: Icons.person,
                  onChanged: _formProvider.validateName,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r"[a-zA-Z]+|\s"),
                    )
                  ],
                ),
                CustomInputField(
                  paddingTop: 5,
                  hintText: "Email Adresse",
                  onChanged: _formProvider.validateEmail,
                  errorText: _formProvider.email.error,
                  iconData: Icons.local_post_office,
                ),
                Visibility(
                  visible: isSignUp ? true : false,
                  child: CustomInputField(
                    hintText: "Biography",
                    onChanged: _formProvider.validateBiography,
                    errorText: _formProvider.biography.error,
                    iconData: Icons.note_alt_rounded,
                  ),
                ),
                CustomInputField(
                  paddingTop: 5,
                  hintText: "Passwort",
                  onChanged: _formProvider.validatePassword,
                  errorText: _formProvider.password.error,
                  iconData: Icons.key,
                  isPassword: true,
                ),
                Visibility(
                  visible: isSignUp,
                  child: CustomInputField(
                    paddingTop: 5,
                    hintText: "Passwort Wiederholen",
                    onChanged: _formProvider.validateRepeatPassword,
                    errorText: _formProvider.repeatPassword.error,
                    iconData: Icons.key,
                    isPassword: true,
                  ),
                ),
                Visibility(
                  visible: isSignUp,
                  child: Row(
                    children: [
                      Checkbox(
                          value: _defaultProfilePic,
                          onChanged: (value) => setState(() {
                                _defaultProfilePic = value!;
                              })),
                      const Text("Das Standardprofilbild verwenden")
                    ],
                  ),
                ),
                Visibility(
                  visible: isSignUp ? true : false,
                  child: CustomInputField(
                    paddingTop: 5,
                    hintText: "Profilbild",
                    errorText: _formProvider.profileImage.error,
                    onChanged: _formProvider.validateProfileImage,
                    iconData: Icons.image,
                  ),
                ),
                Consumer(
                  builder: (context, WidgetRef ref, child) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: AuthenticationButton(
                        text: isSignUp ? "Registrieren" : "Einloggen",
                        color: LebenswikiColors.createPackButton,
                        onPress: () {
                          if (isSignUp && _formProvider.validateForRegister) {
                            signUp();
                          } else if (!isSignUp &&
                              _formProvider.validateForLogin) {
                            signIn(ref);
                          }
                        },
                      ),
                    );
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
                    onPressed: () => toggleSignIn(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration customInputDecoration(hintText, prefixIcon) {
    return InputDecoration(
      hintText: hintText,
      prefixIcon: Icon(
        prefixIcon,
        color: const Color.fromRGBO(115, 148, 192, 1),
      ),
      border: InputBorder.none,
      hintStyle: const TextStyle(
        fontWeight: FontWeight.w500,
        color: Colors.black38,
      ),
    );
  }

  //TODO encrypt password
  void signUp() {
    User user = User(
      email: _formProvider.email.value,
      name: _formProvider.name.value ?? "",
      password: _formProvider.password.value,
      biography: _formProvider.biography.value ?? "",
      profileImage:
          _formProvider.profileImage.value ?? ImageRepo.standardProfileImage,
    );

    userApi.register(user).then((ResultModel result) {
      if (result.type == ResultType.failure) {
        setState(() {});
      } else {
        setState(() {
          isSignUp = false;
        });
      }
    });
  }

  //TODO encrypt password
  void signIn(WidgetRef ref) async {
    userApi
        .login(
            email: _formProvider.email.value ?? "",
            password: _formProvider.password.value ?? "")
        .then((ResultModel result) async {
      if (result.type == ResultType.failure) {
        setState(() {});
      } else {
        ResultModel userRequestResult = await userApi.getUserData();
        User user = userRequestResult.responseItem;
        setProviders(ref, result.responseItem, user);
        TokenHandler().set(result.responseItem);
        navigateFeed();
      }
    });
  }

  void setProviders(WidgetRef ref, String token, User user) {
    ref.read(tokenProvider).token = token;
    ref.read(userProvider).user = user;
    ref.read(userIdProvider).userId = user.id;
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
}
