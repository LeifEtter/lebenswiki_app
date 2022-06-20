import 'package:flutter/material.dart';
import 'package:lebenswiki_app/components/buttons/main_buttons.dart';
import 'package:lebenswiki_app/data/colors.dart';
import 'package:lebenswiki_app/data/custom_safe_area.dart';
import 'package:lebenswiki_app/data/shadows.dart';
import 'package:lebenswiki_app/testing/border.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({Key? key}) : super(key: key);

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _pageController = PageController();
  List<Widget> _onboardingPages = [];
  late double screenWidth;
  int currentPage = 0;

  //Things for progress bar
  double indicatorSectionWidth = 0;
  double fullIndicatorWidth = 0;

  @override
  void initState() {
    _onboardingPages = [
      _page1(),
      _pageScaffold(title: "something", subtitle: "somthing"),
      _pageScaffold(title: "something", subtitle: "somthing"),
      _pageScaffold(title: "something", subtitle: "somthing"),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 20.0),
                child:
                    lebenswikiBlueButtonNormal(text: "Weiter", callback: next),
              ),
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

  Widget _pageScaffold({
    required String title,
    required String subtitle,
  }) {
    return Column(
      children: [
        Text("Title"),
        Row(
          children: [
            TextButton(
              child: Text("Previous"),
              onPressed: () {},
            ),
            TextButton(
              child: Text("Next"),
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }

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

  TextStyle title() => const TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 20,
      );

  TextStyle subtitle() => const TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 14,
        color: Colors.black38,
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
