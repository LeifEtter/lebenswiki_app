import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lebenswiki_app/api/general/result_model_api.dart';
import 'package:lebenswiki_app/api/token/token_handler.dart';
import 'package:lebenswiki_app/api/user_api.dart';
import 'package:lebenswiki_app/repos/image_repo.dart';
import 'package:lebenswiki_app/features/authentication/helpers/authentication_functions.dart';
import 'package:lebenswiki_app/features/common/components/buttons/authentication_buttons.dart';
import 'package:lebenswiki_app/features/styling/input_styling.dart';
import 'package:lebenswiki_app/features/styling/colors.dart';
import 'package:lebenswiki_app/features/styling/text_styles.dart';
import 'package:lebenswiki_app/main.dart';
import 'package:lebenswiki_app/models/enums.dart';
import 'package:lebenswiki_app/models/user_model.dart';
import 'package:lebenswiki_app/providers/providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationView extends StatefulWidget {
  const AuthenticationView({Key? key}) : super(key: key);

  @override
  _AuthenticationViewState createState() => _AuthenticationViewState();
}

class _AuthenticationViewState extends State<AuthenticationView> {
  final UserApi userApi = UserApi();
  bool isAdminSignUp = false;
  bool isSignUp = false;
  bool _defaultProfilePic = false;
  final GlobalKey<FormState> _authFormKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _biographyController = TextEditingController();
  final TextEditingController _profileImageController = TextEditingController();

  void toggleSignIn() {
    isSignUp ? isSignUp = false : isSignUp = true;
    errorMap.forEach((k, v) {
      errorMap[k] = "";
    });
    setState(() {});
  }

  void toggleAdminSignup() {
    isAdminSignUp ? isAdminSignUp = false : isAdminSignUp = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    return Scaffold(
      body: SizedBox(
        child: Padding(
          padding: EdgeInsets.only(
              top: queryData.size.height / (isSignUp ? 12 : 6),
              left: 30,
              right: 30.0),
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
                Visibility(
                  visible: isSignUp,
                  child: AuthInputStyling(
                    child: TextFormField(
                      controller: _nameController,
                      decoration: customInputDecoration(
                          "Vorname Nachname", Icons.person),
                    ),
                  ),
                ),
                errorHint("name"),
                const SizedBox(height: 5),
                AuthInputStyling(
                  child: TextFormField(
                    controller: _emailController,
                    decoration:
                        customInputDecoration("Email", Icons.local_post_office),
                  ),
                ),
                errorHint("email"),
                const SizedBox(height: 5),
                AuthInputStyling(
                  child: TextFormField(
                    obscureText: true,
                    controller: _passwordController,
                    decoration: customInputDecoration("Passwort", Icons.lock),
                  ),
                ),
                errorHint("password"),
                Visibility(
                  visible: isSignUp ? true : false,
                  child: AuthInputBiography(
                    child: TextFormField(
                      controller: _biographyController,
                      obscureText: false,
                      decoration: customInputDecoration(
                          "Erzähl uns was über dich", Icons.note_alt_rounded),
                      minLines: 2,
                      maxLines: 5,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Visibility(
                  visible: isSignUp,
                  child: Row(
                    children: [
                      Checkbox(
                        value: _defaultProfilePic,
                        onChanged: (value) {
                          setState(() {
                            _defaultProfilePic = value!;
                            errorMap.forEach((k, v) {
                              errorMap[k] = "";
                            });
                          });
                        },
                      ),
                      const Text("Das Standardprofilbild verwenden")
                    ],
                  ),
                ),
                Visibility(
                  visible: isSignUp ? true : false,
                  child: AuthInputStyling(
                    isDeactivated: _defaultProfilePic,
                    child: TextFormField(
                      enabled: _defaultProfilePic,
                      controller: _profileImageController,
                      decoration:
                          customInputDecoration("Profilbild", Icons.image),
                    ),
                  ),
                ),
                errorHint("profileImage"),
                Consumer(
                  builder: (context, WidgetRef ref, child) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: AuthenticationButton(
                        text: isSignUp ? "Registrieren" : "Einloggen",
                        color: LebenswikiColors.createPackButton,
                        onPress: () {
                          validation(ref);
                        },
                      ),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 30),
                  child: TextButton(
                    child: Text(isSignUp
                        ? "Du hast schon ein Account?"
                        : "Du bist noch nicht registriert?"),
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

  void validation(WidgetRef ref) {
    if (isSignUp) {
      errorMap["name"] =
          _nameController.text.toString().isEmpty ? "Bitte Namen eingeben" : "";
      errorMap["biography"] = _biographyController.text.toString().isEmpty
          ? "Bitte Biography ausfüllen"
          : "";
    }
    errorMap["email"] = _emailController.text.toString().isEmpty
        ? "Bitte Email Adresse eingeben"
        : "";
    errorMap["password"] = _passwordController.text.toString().isEmpty
        ? "Bitte gültiges Password eingeben"
        : "";

    if (!_defaultProfilePic && isSignUp) {
      errorMap["profileImage"] = _profileImageController.text.toString().isEmpty
          ? "Bitte gebe ein Profilbild an oder wähle das Standardprofilbild."
          : "";
    }

    var isValidated = true;
    /*errorMap.forEach((k, v) {
      v != "" ? isValidated = false : 0;
    });*/

    isValidated ? {isSignUp ? signUp() : signIn(ref)} : setState(() {});
  }

  void signUp() {
    User user = User(
      email: _emailController.text.toString(),
      name: _nameController.text.toString(),
      password: _passwordController.text.toString(),
      biography: _biographyController.text.toString(),
      profileImage: _defaultProfilePic
          ? ImageRepo.standardProfileImage
          : _profileImageController.text.toString(),
    );
    userApi.register(user).then((ResultModel result) {
      if (result.type == ResultType.failure) {
        List errorList = convertError(result.message);
        errorMap[errorList[0]] = errorList[1];
        setState(() {});
      } else {
        setState(() {
          isSignUp = false;
        });
      }
    });
  }

  void signIn(WidgetRef ref) async {
    userApi
        .login(
      email: _emailController.text.toString(),
      password: _passwordController.text.toString(),
    )
        .then((ResultModel result) async {
      if (result.type == ResultType.failure) {
        List errorList = convertError(result.message);
        errorMap[errorList[0]] = errorList[1];
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
