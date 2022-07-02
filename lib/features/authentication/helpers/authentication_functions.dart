import 'package:flutter/material.dart';
import 'package:lebenswiki_app/api/token/token_handler.dart';
import 'package:lebenswiki_app/main.dart';

class AuthenticationFunctions {
  void logout(context) async {
    TokenHandler().delete();
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const AuthWrapper(),
    ));
  }
}

List convertError(error) {
  switch (error) {
    case "User credential do not exist":
      return ["email", "No such Email is registered"];
    case "Email or Password Incorrect":
      return ["password", "Password is invalid"];
    case '"password" length must be at least 6 characters long':
      return ["password", "Password must be at least 6 characters long"];
    case '"email" must be a valid email':
      return ["email", "Email can't be verified"];
    default:
      return ["none", "No Error found"];
  }
}

Widget errorHint(error) {
  return Padding(
    padding: const EdgeInsets.only(left: 5.0, top: 5.0, bottom: 5.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Visibility(
          visible: (errorMap[error] != ""),
          child: Text(
            errorMap[error],
            style: errorHintStyle(),
          ),
        ),
      ],
    ),
  );
}

TextStyle errorHintStyle() {
  return const TextStyle(
    color: Colors.red,
    fontSize: 15.0,
    fontWeight: FontWeight.w500,
  );
}

Map errorMap = {
  "name": "",
  "email": "",
  "password": "",
  "repeatPassword": "",
  "oldPassword": "",
  "biography": "",
  "profileImage": "",
};
