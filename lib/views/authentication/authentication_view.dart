import 'package:flutter/material.dart';
import 'package:lebenswiki_app/api/api_authentication.dart';
import 'package:lebenswiki_app/helper/authentication_functions.dart';
import 'package:lebenswiki_app/components/buttons/authentication_buttons.dart';
import 'package:lebenswiki_app/components/input/input_styling.dart';
import 'package:lebenswiki_app/data/colors.dart';
import 'package:lebenswiki_app/data/text_styles.dart';
import 'package:lebenswiki_app/main.dart';

class AuthenticationView extends StatefulWidget {
  const AuthenticationView({Key? key}) : super(key: key);

  @override
  _AuthenticationViewState createState() => _AuthenticationViewState();
}

class _AuthenticationViewState extends State<AuthenticationView> {
  bool isAdminSignUp = false;
  bool isSignUp = false;
  bool? _defaultProfilePic = false;
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
    return SizedBox(
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
                    decoration:
                        customInputDecoration("Vorname Nachname", Icons.person),
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
                          _defaultProfilePic = value;
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
                  isDeactivated: _defaultProfilePic!,
                  child: TextFormField(
                    enabled: !_defaultProfilePic!,
                    controller: _profileImageController,
                    decoration:
                        customInputDecoration("Profilbild", Icons.image),
                  ),
                ),
              ),
              errorHint("profileImage"),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: AuthenticationButton(
                  text: isSignUp ? "Registrieren" : "Einloggen",
                  color: LebenswikiColors.createPackButton,
                  onPress: () {
                    validation();
                  },
                ),
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

  void validation() {
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

    if (!_defaultProfilePic! && isSignUp) {
      errorMap["profileImage"] = _profileImageController.text.toString().isEmpty
          ? "Bitte gebe ein Profilbild an oder wähle das Standardprofilbild."
          : "";
    }

    //errorMap["profileImage"] = _profileImageController.text.toString().contains("");

    var isValidated = true;
    errorMap.forEach((k, v) {
      v != "" ? isValidated = false : 0;
    });

    isValidated ? {isSignUp ? signUp() : signIn()} : setState(() {});
  }

  void signUp() {
    register(
      _emailController.text.toString(),
      _passwordController.text.toString(),
      _nameController.text.toString(),
      _biographyController.text.toString(),
      _defaultProfilePic!
          ? "https://t3.ftcdn.net/jpg/01/18/01/98/360_F_118019822_6CKXP6rXmVhDOzbXZlLqEM2ya4HhYzSV.jpg"
          : _profileImageController.text.toString(),
      isAdminSignUp == true ? true : false,
    ).then((responseMap) {
      if (responseMap["error"] != "") {
        List errorList = convertError(responseMap["error"]);
        errorMap[errorList[0]] = errorList[1];
        setState(() {});
      } else {
        setState(() {
          isSignUp = false;
        });
      }
    });
  }

  void signIn() {
    login(
      _emailController.text.toString(),
      _passwordController.text.toString(),
    ).then((responseMap) {
      if (responseMap["error"] != "") {
        List errorList = convertError(responseMap["error"]);
        errorMap[errorList[0]] = errorList[1];
        setState(() {});
      } else {
        navigateFeed();
      }
    });
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
