import 'package:flutter/material.dart';
import 'package:lebenswiki_app/api/user_api.dart';
import 'package:lebenswiki_app/features/common/components/buttons/main_buttons.dart';
import 'package:lebenswiki_app/features/styling/input_styling.dart';
import 'package:lebenswiki_app/features/common/components/top_nav.dart';

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
                Image.network(
                  "https://i.ibb.co/74PBzW8/6207c565b83821547c42e94a-BMFSFJ-gefo-rdert-vom.jpg%22%20alt=%226207c565b83821547c42e94a-BMFSFJ-gefo-rdert-vom",
                  width: MediaQuery.of(context).size.width * 0.4,
                ),
                const SizedBox(width: 20),
                Image.network(
                  "https://i.ibb.co/Bf24khm/jugendstrategie-logo-aktionsplan-1.png",
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
                const Text(
                  "Evangelische Akademie Loccum",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.w500,
                  ),
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
                        children: const [
                          Text(
                            "Kontakt",
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text("+49 (0) 5766 81-0 \n"
                              "eal@evlka.de \n"),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Text(
                      "Lebenswiki",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.w500,
                      ),
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
                        children: const [
                          Text(
                            "Anschrift",
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
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
                        children: const [
                          Text(
                            "Kontakt",
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text("+49 (0) 171 517-3435 \n"
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
                    const Text(
                      "Feedback Formular",
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 30.0, right: 30.0, top: 25.0),
                      child: AuthInputBiography(
                        child: TextFormField(
                          controller: _feedbackController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(10.0),
                          ),
                          minLines: 5,
                          maxLines: 10,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Row(
                        children: [
                          Expanded(
                          child: lebenswikiBlueButtonNormal(
                              text: "Feedback abschicken",
                              callback: () {
                                userApi.createFeedback(
                                    feedback:
                                        _feedbackController.text.toString());
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
}
