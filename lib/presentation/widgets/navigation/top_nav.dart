import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
                    Navigator.popUntil(
                        context, ModalRoute.withName("/wrapper"));
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
}
