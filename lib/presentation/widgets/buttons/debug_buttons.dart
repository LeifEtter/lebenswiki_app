import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:lebenswiki_app/application/auth/token_handler.dart';

class DebugButtons extends StatelessWidget {
  const DebugButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(
          onPressed: () async => {
            print(await FlutterSecureStorage().readAll()),
          },
          child: Text("Print Secure Storage"),
        ),
        TextButton(
          onPressed: () async => {
            print(await TokenHandler().get()),
          },
          child: Text("Get JWT token"),
        ),
        TextButton(
          onPressed: () async => {
            print(await TokenHandler().set("imawrongjwttoken")),
          },
          child: Text("Set False JWT"),
        ),
      ],
    );
  }
}
