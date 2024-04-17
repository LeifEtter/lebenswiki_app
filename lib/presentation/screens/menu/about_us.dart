import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:lebenswiki_app/presentation/constants/colors.dart';
import 'package:lebenswiki_app/presentation/constants/shadows.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsView extends StatefulWidget {
  const AboutUsView({Key? key}) : super(key: key);

  @override
  State<AboutUsView> createState() => _AboutUsViewState();
}

class _AboutUsViewState extends State<AboutUsView> {
  bool ealInfoExpanded = false;
  bool lwInfoExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leadingWidth: 100,
            leading: Row(
              children: [
                GestureDetector(
                  onTap: () => context.pop(),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(255, 255, 255, 0.85),
                        boxShadow: [LebenswikiShadows.fancyShadow],
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      height: 50,
                      width: 50,
                      child: Icon(
                        Icons.arrow_back_ios_rounded,
                        color: CustomColors.veryDarkGrey,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: CustomColors.blue,
            expandedHeight: 180,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: CustomColors.blueGradientSliver,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Center(child: _buildSliverBackgroundImage()),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 30,
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(15.0),
                            topRight: Radius.circular(15.0)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
            sliver: SliverList(
              delegate: SliverChildListDelegate.fixed([
                Center(
                  child: Text(
                    "Über Uns",
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                ),
                const SizedBox(height: 25),
                const Center(
                  child: Text(
                    "Das Lebenswiki ist eine App für junge Erwachsene, in der Grundlagenwissen in den Bereichen Finanzen, Steuern, Beruf, Versicherungen und Wohnen vermittelt werden.",
                  ),
                ),
                const SizedBox(height: 20),
                const Center(
                  child: Text(
                    "Das Projekt Lebenswiki wird im Rahmen des Jugend-Budgets vom Bundesministerium für Familie, Senioren, Frauen und Jugend gefördert. Aus diesem Grund ist es uns möglich, die App kostenlos und ohne jegliche Werbung anzubieten. Expertinnen und Experten arbeiten ehrenamtlich - ihr Engagement macht das Lebenswiki möglich!",
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Flexible(
                      flex: 50,
                      child: GestureDetector(
                        onTap: () async {
                          await launchUrl(Uri.parse("https://www.bmfsfj.de/"));
                        },
                        child: SvgPicture.asset(
                          "assets/images/Bundesministerium_Logo.svg",
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 50,
                      child: GestureDetector(
                        onTap: () async {
                          await launchUrl(Uri.parse(
                              "https://www.bmfsfj.de/bmfsfj/themen/kinder-und-jugend/jugendbildung/jugendstrategie?view="));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Image.asset(
                            "assets/images/jugendstrategie-logo.png",
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    "Kontakt",
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                ),
                const SizedBox(height: 20),
                ExpansionTile(
                  iconColor: CustomColors.offBlack,
                  title: Text(
                    "Lebenswiki",
                    style: TextStyle(
                      color: CustomColors.offBlack,
                      fontWeight:
                          ealInfoExpanded ? FontWeight.w500 : FontWeight.w400,
                    ),
                  ),
                  onExpansionChanged: (bool newState) => setState(() {
                    ealInfoExpanded = newState;
                  }),
                  childrenPadding:
                      const EdgeInsets.only(left: 30, right: 30, bottom: 20),
                  children: [
                    _buildInfoTile(
                        icon: Icons.person_outline_rounded,
                        text: "Max Brenner"),
                    _buildInfoTile(
                        icon: Icons.phone_outlined,
                        text: "+49 (0) 171 517-3435"),
                    _buildInfoTile(
                        icon: Icons.alternate_email_rounded,
                        text: "lebenswiki@gmail.com"),
                    _buildInfoTile(
                        icon: Icons.home_outlined,
                        text: "Lohmühlenstraße 65\n12435 Berlin"),
                  ],
                ),
                ExpansionTile(
                  iconColor: CustomColors.offBlack,
                  title: Text(
                    "Evangelische Akademie Loccum",
                    style: TextStyle(
                      color: CustomColors.offBlack,
                      fontWeight:
                          lwInfoExpanded ? FontWeight.w500 : FontWeight.w400,
                    ),
                  ),
                  onExpansionChanged: (bool newState) => setState(() {
                    lwInfoExpanded = newState;
                  }),
                  childrenPadding:
                      const EdgeInsets.only(left: 30, right: 30, bottom: 20),
                  children: [
                    _buildInfoTile(
                        icon: Icons.person_outline_rounded,
                        text: "Evangelische Akademie Loccum"),
                    _buildInfoTile(
                        icon: Icons.phone_outlined, text: "+49 (0) 5766 81-0"),
                    _buildInfoTile(
                        icon: Icons.alternate_email_rounded,
                        text: "eal@evlka.de"),
                    _buildInfoTile(
                        icon: Icons.home_outlined,
                        text: "Münchehäger Straße 6 \n31547 Rehburg-Loccum"),
                  ],
                ),
                const SizedBox(height: 100),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String text,
    String? imagePath,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 5),
      child: Row(
        children: [
          imagePath != null
              ? Image.asset(imagePath, width: 30, height: 30)
              : Icon(icon, size: 30, color: CustomColors.veryDarkGrey),
          const SizedBox(width: 20),
          SelectableText(text),
        ],
      ),
    );
  }

  Container _buildSliverBackgroundImage() => Container(
        width: 120,
        height: 120,
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.contain,
            image: AssetImage(
              "assets/icons/Lebenswiki_Logo_no-background.png",
            ),
          ),
        ),
      );
}
