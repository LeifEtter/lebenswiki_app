import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lebenswiki_app/features/a_new_widget_repo/colors.dart';
import 'package:lebenswiki_app/features/a_new_widget_repo/lw.dart';

class FeedbackScreen extends ConsumerStatefulWidget {
  const FeedbackScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends ConsumerState<FeedbackScreen> {
  TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
        child: ListView(
          children: [
            //Top Bar
            Row(
              children: [
                Expanded(flex: 1, child: Container()),
                Expanded(
                  flex: 8,
                  child: Text(
                    'Report a Problem',
                    textAlign: TextAlign.center,
                    style: _pageTitle(),
                  ),
                ),
                const Expanded(flex: 1, child: CloseButton())
              ],
            ),
            const SizedBox(height: 30),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: CustomColors.lightGrey,
              ),
              child: TextFormField(
                controller: messageController,
                minLines: 8,
                maxLines: 10,
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      color: Colors.black38,
                    ),
                    hintText: "Beschreibe dein Problem...",
                    contentPadding: EdgeInsets.all(20.0)),
              ),
            ),
            const SizedBox(height: 25.0),
            LW.buttons.normal(
              text: "Einreichen",
              action: () {},
              borderRadius: 10.0,
            ),
          ],
        ),
      ),
    );
  }

  TextStyle _pageTitle() => const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 18.0,
      );
}
