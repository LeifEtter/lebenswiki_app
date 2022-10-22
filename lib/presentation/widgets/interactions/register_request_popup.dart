import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lebenswiki_app/application/auth/authentication_functions.dart';
import 'package:lebenswiki_app/presentation/widgets/common/expand_row.dart';
import 'package:lebenswiki_app/presentation/widgets/lw.dart';
import 'package:lebenswiki_app/repository/constants/colors.dart';

class RegisterRequestPopup extends StatelessWidget {
  final WidgetRef ref;

  const RegisterRequestPopup(this.ref, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        title: const Padding(
          padding: EdgeInsets.only(top: 10, bottom: 0),
          child: Center(child: Text("Einloggen")),
        ),
        content: const Text(
          "Um fortzufahren musst du dich einloggen.",
          style: TextStyle(
            fontWeight: FontWeight.w400,
            color: Colors.black54,
            fontSize: 17,
          ),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
            child: Column(
              children: [
                ExpandButton(
                  child: LW.buttons.normal(
                    borderRadius: 12,
                    text: "Registrieren",
                    action: () {
                      Authentication.logout(context, ref);
                    },
                  ),
                ),
                const SizedBox(height: 10),
                ExpandButton(
                  child: LW.buttons.normal(
                    borderRadius: 12,
                    text: "Einloggen",
                    action: () {
                      Authentication.logout(context, ref);
                    },
                    color: CustomColors.mediumGrey,
                    textColor: CustomColors.offBlack,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
