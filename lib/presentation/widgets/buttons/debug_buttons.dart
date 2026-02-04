import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
            print(await TokenHandler().set(
                "eyJ1c2VyX2lkIjo4MCwiaWF0IjoxNzA3ODY5NzU5LCJleHAiOjE3MDc4NzY5NTl9.0puX_2aPrbKI5X3ig5r1dUfDuZbI6N69voFutqsmT8I")),
          },
          child: Text("Set False JWT"),
        ),
      ],
    );
  }
}
