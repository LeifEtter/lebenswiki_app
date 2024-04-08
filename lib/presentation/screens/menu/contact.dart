// import 'package:either_dart/either.dart';
// import 'package:lebenswiki_app/presentation/widgets/lw.dart';
// import 'package:lebenswiki_app/presentation/widgets/interactions/custom_flushbar.dart';
// import 'package:lebenswiki_app/repository/backend/misc_api.dart';
// import 'package:lebenswiki_app/domain/models/error.model.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lebenswiki_app/data/user_api.dart';
import 'package:lebenswiki_app/domain/models/error.model.dart';
import 'package:lebenswiki_app/domain/models/user/user.model.dart';
import 'package:lebenswiki_app/presentation/providers/providers.dart';
import 'package:lebenswiki_app/presentation/widgets/input/drop_down_menu.dart';
import 'package:lebenswiki_app/presentation/widgets/input/simplified_form_field.dart';
import 'package:lebenswiki_app/presentation/widgets/common/hacks.dart';
import 'package:lebenswiki_app/presentation/widgets/interactions/custom_flushbar.dart';
import 'package:lebenswiki_app/presentation/widgets/lw.dart';
import 'package:lebenswiki_app/presentation/widgets/navigation/top_nav.dart';
import 'package:lebenswiki_app/presentation/constants/colors.dart';
import 'package:lebenswiki_app/presentation/constants/shadows.dart';

class ContactView extends ConsumerStatefulWidget {
  const ContactView({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ContactViewState();
}

class _ContactViewState extends ConsumerState<ContactView> {
  TextEditingController submissionController = TextEditingController();
  List<String> contactReason = [
    "Frage",
    "Bug",
    "Problem",
    "Feedback",
    "Creator Bewerbung",
    "Anderes",
  ];
  late DropDownItem chosenItem;

  late String name;
  late List<DropDownItem> reasonItems;

  @override
  void initState() {
    reasonItems = contactReason
        .map((reason) =>
            DropDownItem(id: contactReason.indexOf(reason), name: reason))
        .toList();
    chosenItem = reasonItems[0];
    User? user = ref.read(userProvider).user;
    if (user != null) {
      name = user.name;
    } else {
      name = "Anonym";
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(left: 20, right: 20),
          children: [
            const TopNavIOS(title: "Kontakt"),
            S.h30(),
            CustomDropDownMenu(
              shadows: [LebenswikiShadows.fancyShadow],
              chosenValue: chosenItem,
              onPress: (DropDownItem item) => setState(() => chosenItem = item),
              items: reasonItems,
            ),
            S.h20(),
            SimplifiedFormField.multiline(
              controller: submissionController,
              minLines: 10,
              maxLines: 99,
              borderRadius: 15,
              color: CustomColors.lightGrey,
              hintText: "Beschreibe worüber du uns kontaktieren willst...",
            ),
            S.h20(),
            LW.buttons.normal(
              borderRadius: 10.0,
              text: "Einreichen",
              action: () async {
                Either<CustomError, String> feedbackResult = await UserApi()
                    .createFeedback(
                        type: chosenItem.name,
                        content: submissionController.text);
                feedbackResult.fold(
                  (left) =>
                      CustomFlushbar.error(message: left.error).show(context),
                  (right) =>
                      CustomFlushbar.success(message: right).show(context),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
