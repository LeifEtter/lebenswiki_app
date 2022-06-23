import 'package:flutter/material.dart';
import 'package:lebenswiki_app/data/colors.dart';
import 'package:lebenswiki_app/data/custom_safe_area.dart';
import 'package:lebenswiki_app/data/shadows.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({Key? key}) : super(key: key);

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _pageController = PageController();
  final TextEditingController _nameController = TextEditingController();
  List<Widget> _onboardingPages = [];
  late double screenWidth;
  int currentPage = 0;

  bool lernpacksActive = false;
  bool communityActive = false;
  bool visionActive = false;

  //Things for progress bar
  double indicatorSectionWidth = 0;
  double fullIndicatorWidth = 0;

  @override
  void initState() {
    _onboardingPages = [
      _pageWelcome(),
      _page1(),
      _page2(),
      _page3(),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _onboardingPages = [
      _pageWelcome(),
      _page1(),
      _page2(),
      _page3(),
    ];
    screenWidth = MediaQuery.of(context).size.width;
    _updateProgressBarValues();
    return CustomSafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              _progressBar(),
              Expanded(
                child: PageView(
                  onPageChanged: (value) {
                    currentPage = value;
                    setState(() {});
                  },
                  controller: _pageController,
                  children: _onboardingPages,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: navButton(),
              ),
              const SizedBox(height: 5),
            ],
          ),
        ),
      ),
    );
  }

  void _updateProgressBarValues() {
    indicatorSectionWidth = (screenWidth - 20) / (_onboardingPages.length);
    fullIndicatorWidth = indicatorSectionWidth * currentPage;
  }

  Widget _progressBar() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20, top: 10),
      child: Container(
        decoration: BoxDecoration(boxShadow: [
          LebenswikiShadows().fancyShadow,
        ]),
        child: Stack(
          children: [
            Container(
              width: screenWidth,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            AnimatedContainer(
              decoration: BoxDecoration(
                color: LebenswikiColors.blue,
                borderRadius: BorderRadius.circular(10.0),
              ),
              height: 20,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              width: fullIndicatorWidth,
            ),
          ],
        ),
      ),
    );
  }

  Widget _pageWelcome() => Column(
        children: [
          const SizedBox(height: 120),
          Text(
            "Hey,",
            style: title(),
          ),
          Text(
            "willkommen bei",
            style: title(),
          ),
          const SizedBox(height: 20),
          Text(
            "Lebenswiki",
            style: logoTitle(),
          ),
          const SizedBox(height: 40),
          Text(
            "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut",
            style: title(),
            textAlign: TextAlign.center,
          ),
        ],
      );

  Widget _page1() => Column(
        children: [
          const SizedBox(height: 50),
          Container(
            height: 300,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.red, width: 1),
            ),
          ),
          Text(
            "Hier findest du Lernpacks",
            style: title(),
          ),
          Text(
            "Lernpacks sind von uns zusammengestellte Interaktive Lernmodule",
            style: subtitle(),
          )
        ],
      );

  Widget _page2() => Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 100, bottom: 30),
            child: Text(
              "Wie heisst du eigentlich?",
              style: title(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [LebenswikiShadows().fancyShadow],
                    ),
                    child: TextField(
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20.0,
                      ),
                      controller: _nameController,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                        hintText: "Ayo",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );

  Widget _page3() => Column(
        children: [
          const SizedBox(height: 120),
          Text(
            "Was interessiert dich?",
            style: title(),
          ),
          const SizedBox(height: 50),
          clickableInfoCard(
            invertFunction: () {
              lernpacksActive = !lernpacksActive;
              communityActive = false;
              visionActive = false;
            },
            activated: lernpacksActive,
            title: "Lernpacks",
            description:
                "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et",
          ),
          const SizedBox(height: 20),
          clickableInfoCard(
            invertFunction: () {
              communityActive = !communityActive;
              lernpacksActive = false;
              visionActive = false;
            },
            activated: communityActive,
            title: "Community",
            description:
                "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et",
          ),
          const SizedBox(height: 20),
          clickableInfoCard(
            invertFunction: () {
              visionActive = !visionActive;
              lernpacksActive = false;
              communityActive = false;
            },
            activated: visionActive,
            title: "Unsere Vision",
            description:
                "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et",
          ),
        ],
      );

  Widget clickableInfoCard({
    required Function invertFunction,
    required bool activated,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          Expanded(
            child: Stack(
              children: [
                //Bottom Part
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  height: activated ? 200 : 0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.white,
                      boxShadow: [LebenswikiShadows().fancyShadow]),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 60, left: 20, right: 20, bottom: 20),
                    child: Text(
                      description,
                      style: const TextStyle(
                        fontSize: 17.0,
                      ),
                    ),
                  ),
                ),

                //Top Part
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: LebenswikiColors.blue,
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: TextButton(
                          child: Text(
                            title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                            ),
                          ),
                          onPressed: () => setState(() {
                            invertFunction();
                          }),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget navButton() => Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.0),
                  color: LebenswikiColors.blue,
                  boxShadow: [LebenswikiShadows().fancyShadow]),
              child: TextButton(
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    "Weiter",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                ),
                onPressed: () => next(),
              ),
            ),
          ),
        ],
      );

  TextStyle title() => const TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 20,
      );

  TextStyle subtitle() => const TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 14,
        color: Colors.black38,
      );

  TextStyle logoTitle() => const TextStyle(
        fontSize: 60,
        fontWeight: FontWeight.w400,
      );

  void next() {
    _pageController.nextPage(
        duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
  }

  void previous() {
    _pageController.previousPage(
        duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
  }
}
