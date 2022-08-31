import 'package:flutter/material.dart';
import 'package:lebenswiki_app/api/user_api.dart';
import 'package:lebenswiki_app/features/common/components/buttons/buttons.dart';
import 'package:lebenswiki_app/features/common/components/nav/top_nav.dart';
import 'package:lebenswiki_app/features/menu/views/feedback_view.dart';

class DeveloperInfoView extends StatefulWidget {
  const DeveloperInfoView({Key? key}) : super(key: key);

  @override
  _DeveloperInfoViewState createState() => _DeveloperInfoViewState();
}

class _DeveloperInfoViewState extends State<DeveloperInfoView> {
  final UserApi userApi = UserApi();
  final TextEditingController _feedbackController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: ListView(
        children: [
          const TopNav(pageName: "Kontakt/Feedback", backName: "Menu"),
          const SizedBox(
            height: 20.0,
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                Image.asset(
                  "assets/images/BMFSFJ_logo.png",
                  width: MediaQuery.of(context).size.width * 0.4,
                ),
                const SizedBox(width: 20),
                Image.asset(
                  "assets/images/jugendstrategie-logo.png",
                  width: MediaQuery.of(context).size.width * 0.4,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Evangelische Akademie Loccum",
                  textAlign: TextAlign.start,
                  style: _title(),
                ),
                const Divider(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Anschrift",
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            "Evangelische Akademie \nLoccum \n"
                            "Münchehäger Straße 6 \n"
                            "31547 Rehburg-Loccum \n",
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20.0, top: 20.0),
                      child: Container(
                          height: 80,
                          width: 1,
                          color: Colors.grey.withOpacity(0.5)),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Kontakt",
                            style: _subtitle(),
                          ),
                          const Text("+49 (0) 5766 81-0 \n"
                              "eal@evlka.de \n"),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Lebenswiki",
                      textAlign: TextAlign.center,
                      style: _title(),
                    ),
                  ],
                ),
                const Divider(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Anschrift",
                            style: _subtitle(),
                          ),
                          const Text(
                            "Max Brenner \n"
                            "Lohmühlenstraße 65 \n"
                            "12435 Berlin \n",
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20.0, top: 20.0),
                      child: Container(
                          height: 80,
                          width: 1,
                          color: Colors.grey.withOpacity(0.5)),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Kontakt",
                            style: _subtitle(),
                          ),
                          const Text("+49 (0) 171 517-3435 \n"
                              "lebenswiki@gmail.com \n"),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Divider(),
                const SizedBox(height: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Feedback Formular",
                      style: _title(),
                    ),
                    const SizedBox(height: 10.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Row(
                        children: [
                          Expanded(
                            child:
                                LebenswikiButtons.textButton.blueButtonNormal(
                              text: "Feedback abschicken",
                              callback: () {
                                /*userApi.createFeedback(
                                    feedback:
                                        _feedbackController.text.toString());*/
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) =>
                                            const FeedbackScreen())));
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30.0),
              ],
            ),
          ),
        ],
      ),
    ));
  }

  TextStyle _title() => const TextStyle(
        fontSize: 25.0,
        fontWeight: FontWeight.w500,
      );

  TextStyle _subtitle() => const TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.w500,
      );
}
