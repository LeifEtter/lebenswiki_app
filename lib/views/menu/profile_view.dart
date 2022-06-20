import 'package:flutter/material.dart';
import 'package:lebenswiki_app/api/result_model_api.dart';
import 'package:lebenswiki_app/api/user_api.dart';
import 'package:lebenswiki_app/helper/auth/authentication_functions.dart';
import 'package:lebenswiki_app/components/buttons/authentication_buttons.dart';
import 'package:lebenswiki_app/components/input/input_styling.dart';
import 'package:lebenswiki_app/components/navigation/top_nav.dart';
import 'package:lebenswiki_app/data/loading.dart';
import 'package:lebenswiki_app/models/enums.dart';
import 'package:lebenswiki_app/models/user_model.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final UserApi userApi = UserApi();
  final TextEditingController _profileImageController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatPasswordController =
      TextEditingController();
  final TextEditingController _biographyController = TextEditingController();

  late User user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: userApi.getUserData(),
          builder: (context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return const Loading();
            } else if (snapshot.data == null) {
              return const Text("Please log in");
            } else {
              User user = snapshot.data;
              _profileImageController.text = user.profileImage;
              _nameController.text = user.name;
              _emailController.text = user.email;
              _biographyController.text = user.biography;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ListView(
                  children: [
                    const TopNav(pageName: "Profil", backName: "Menu"),
                    const SizedBox(height: 10.0),
                    CircleAvatar(
                      child: ClipOval(
                        child: Image.network(
                          user.profileImage,
                        ),
                      ),
                      radius: 45,
                    ),
                    const SizedBox(height: 10.0),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Profilbild"),
                    ),
                    const SizedBox(height: 5.0),
                    AuthInputStyling(
                      child: TextFormField(
                        controller: _profileImageController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(10.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Biografie"),
                    ),
                    const SizedBox(height: 5),
                    AuthInputBiography(
                      child: TextFormField(
                        controller: _biographyController,
                        obscureText: false,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(10.0),
                        ),
                        minLines: 2,
                        maxLines: 5,
                      ),
                    ),
                    const SizedBox(height: 30.0),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Name"),
                    ),
                    const SizedBox(height: 5.0),
                    AuthInputStyling(
                      child: TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(10.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15.0),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Email Adresse"),
                    ),
                    const SizedBox(height: 5.0),
                    AuthInputStyling(
                      child: TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(10.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    AuthenticationButton(
                      text: "Änderungen Speichern",
                      color: Colors.blue,
                      onPress: () => update(),
                    ),
                    const SizedBox(height: 20),
                    const Divider(),
                    const SizedBox(height: 20),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Altes Passwort"),
                    ),
                    const SizedBox(height: 5.0),
                    AuthInputStyling(
                      child: TextFormField(
                        controller: _oldPasswordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(10.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Neues Passwort"),
                    ),
                    const SizedBox(height: 5.0),
                    AuthInputStyling(
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(10.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15.0),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Neues Passwort wiederholen"),
                    ),
                    const SizedBox(height: 5.0),
                    AuthInputStyling(
                      child: TextFormField(
                        controller: _repeatPasswordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(10.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    AuthenticationButton(
                      text: "Passwort Speichern",
                      color: Colors.blue,
                      onPress: () => changePassword(),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  void validationProfile() {
    errorMap["name"] =
        _nameController.text.toString().isEmpty ? "Bitte Namen eingeben" : "";
    errorMap["biography"] = _biographyController.text.toString().isEmpty
        ? "Bitte Biography ausfüllen"
        : "";
    errorMap["email"] = _emailController.text.toString().isEmpty
        ? "Bitte Email Adresse eingeben"
        : "";
    errorMap["profileImage"] = _profileImageController.text.toString().isEmpty
        ? "Bitte gültiges Profilbild eingeben"
        : "";

    var isValidated = true;
    errorMap.forEach((k, v) {
      v != "" ? isValidated = false : 0;
    });
  }

  void validationPassword() {
    errorMap["password"] = _passwordController.text.toString().isEmpty
        ? "Bitte Neues eingeben"
        : "";
    errorMap["oldPassword"] = _oldPasswordController.text.toString().isEmpty
        ? "Bitte Biography ausfüllen"
        : "";

    if (_repeatPasswordController.text.toString().isEmpty) {
      errorMap["repeatPassword"] = "Bitte Passwort nochmal eingebe";
    } else if (!(_passwordController.text.toString() ==
        _repeatPasswordController.text.toString())) {
      errorMap["repeatPassword"] = "Passwörter stimmen nicht überein";
    } else {
      errorMap["repeatPassword"] = "";
    }

    var isValidated = true;
    errorMap.forEach((k, v) {
      v != "" ? isValidated = false : 0;
    });
  }

  void update() {
    user.email = _emailController.text.toString();
    user.name = _nameController.text.toString();
    user.biography = _biographyController.text.toString();
    user.profileImage = _profileImageController.text.toString();

    userApi.updateProfile(user: user).then((ResultModel result) {
      if (result.type == ResultType.success) {
        List errorList = convertError(result.message);
        errorMap[errorList[0]] = errorList[1];
        setState(() {});
      } else {
        print("Show success message");
      }
    });
  }

  void changePassword() {
    userApi
        .updatePassword(
      oldpassword: _oldPasswordController.text.toString(),
      password: _passwordController.text.toString(),
    )
        .then((ResultModel result) {
      if (result.type == ResultType.success) {
        List errorList = convertError(result.message);
        errorMap[errorList[0]] = errorList[1];
        setState(() {});
      } else {
        print("Show Success message");
      }
    }).whenComplete(() {
      _oldPasswordController.text = "";
      _passwordController.text = "";
      _repeatPasswordController.text = "";
    });
  }
}
