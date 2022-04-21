import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  final int currentIndex;
  final Function onItemTapped;

  const BottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: BottomNavigationBar(
        backgroundColor: Colors.white,
        elevation: 10.0,
        showSelectedLabels: false,
        selectedItemColor: Colors.blue,
        showUnselectedLabels: false,
        currentIndex: widget.currentIndex,
        onTap: (index) {
          widget.onItemTapped(index);
        },
        items: [
          BottomNavigationBarItem(
            activeIcon: Image.asset("assets/icons/verified_person_filled.png",
                width: 50),
            icon: Image.asset("assets/icons/person_verified.png", width: 50),
            label: "Home",
          ),
          BottomNavigationBarItem(
            activeIcon:
                Image.asset("assets/icons/community_filled.png", width: 50),
            icon: Image.asset("assets/icons/community.png", width: 50),
            label: "Community",
          ),
        ],
      ),
    );
  }
}
