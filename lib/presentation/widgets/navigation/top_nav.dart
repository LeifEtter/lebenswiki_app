import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lebenswiki_app/main_wrapper.dart';

class TopNavIOS extends StatelessWidget {
  final String title;
  final String? nextTitle;
  final Function? nextFunction;
  final bool isPopMenu;

  const TopNavIOS({
    Key? key,
    required this.title,
    this.nextTitle,
    this.nextFunction,
    this.isPopMenu = false,
  }) : super(key: key);

  const TopNavIOS.withNextButton({
    Key? key,
    required this.title,
    required this.nextTitle,
    required this.nextFunction,
    this.isPopMenu = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              width: 50,
              child: IconButton(
                onPressed: () {
                  if (isPopMenu) {
                    Navigator.of(context).push(_homeRoute());
                  } else {
                    Navigator.pop(context);
                  }
                },
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: nextTitle != null
                ? CupertinoButton(
                    child: Text(nextTitle!),
                    onPressed: () => nextFunction!(),
                  )
                : Container(
                    width: 50,
                  ),
          ),
        ],
      ),
    );
  }

  Route _homeRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const NavBarWrapper(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(-1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
