import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lebenswiki_app/api/misc_api.dart';
import 'package:lebenswiki_app/features/a_new_common/hacks.dart';
import 'package:lebenswiki_app/features/a_new_common/other.dart';
import 'package:lebenswiki_app/features/a_new_common/top_nav.dart';
import 'package:lebenswiki_app/features/a_new_widget_repo/colors.dart';
import 'package:lebenswiki_app/features/a_new_widget_repo/lw.dart';
import 'package:lebenswiki_app/features/snackbar/components/custom_flushbar.dart';
import 'package:lebenswiki_app/repository/shadows.dart';

class ContactView extends ConsumerStatefulWidget {
  const ContactView({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ContactViewState();
}

class _ContactViewState extends ConsumerState<ContactView> {
  TextEditingController submissionController = TextEditingController();
  String chosenReason = "Frage";
  List<String> contactReason = [
    "Frage",
    "Bug",
    "Problem",
    "Feedback",
    "Anderes",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(left: 20, right: 20),
          children: [
            const TopNavIOS(title: "Kontakt"),
            S.h30(),
            Container(
              padding: const EdgeInsets.only(
                  left: 20.0, right: 20.0, top: 5, bottom: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: Colors.white,
                boxShadow: [LebenswikiShadows.fancyShadow],
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  borderRadius: BorderRadius.circular(15.0),
                  value: chosenReason,
                  items: contactReason
                      .map<DropdownMenuItem<String>>(
                          (String value) => DropdownMenuItem(
                                value: value,
                                child: Text(value),
                              ))
                      .toList(),
                  onChanged: (String? something) {},
                ),
              ),
            ),
            S.h20(),
            Container(
              decoration: BoxDecoration(
                color: CustomColors.lightGrey,
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: TextFormField(
                controller: submissionController,
                minLines: 10,
                maxLines: 99,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(15.0),
                  hintText: "Beschreibe worüber du uns kontaktieren willst...",
                  hintStyle: TextStyle(
                    color: CustomColors.mediumGrey,
                  ),
                ),
              ),
            ),
            S.h20(),
            LW.buttons.normal(
              borderRadius: 10.0,
              text: "Einreichen",
              action: () async {
                Either<CustomError, String> feedbackResult = await MiscApi()
                    .createFeedback(feedback: submissionController.text);
                feedbackResult.fold(
                  (left) =>
                      CustomFlushbar.error(message: left.error).show(context),
                  (right) => CustomFlushbar.info(message: right).show(context),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
