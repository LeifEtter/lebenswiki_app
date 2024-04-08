import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lebenswiki_app/presentation/constants/colors.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:lebenswiki_app/presentation/constants/shadows.dart';

class CustomBottomBar extends ConsumerStatefulWidget {
  final int selectedIndex;
  final Function(int) onPressed;

  const CustomBottomBar({
    Key? key,
    required this.selectedIndex,
    required this.onPressed,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CustomBottomBarState();
}

class _CustomBottomBarState extends ConsumerState<CustomBottomBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [LebenswikiShadows.fancyShadow],
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(35.0),
          topRight: Radius.circular(35.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: GNav(
          textStyle: const TextStyle(
            color: Colors.white,
            fontSize: 18.0,
          ),
          tabBackgroundColor: CustomColors.offBlack,
          activeColor: Colors.white,
          color: CustomColors.offBlack,
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
          gap: 10,
          iconSize: 30.0,
          selectedIndex: widget.selectedIndex,
          onTabChange: (int index) => widget.onPressed(index),
          tabs: const [
            GButton(
              icon: Icons.home,
              text: "Home",
            ),
            GButton(
              icon: Icons.search,
              text: "Erkunden",
            ),
            GButton(
              icon: Icons.groups,
              text: "Community",
            ),
          ],
        ),
      ),
    );
  }
}
