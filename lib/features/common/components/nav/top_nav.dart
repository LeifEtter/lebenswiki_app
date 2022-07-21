import 'package:flutter/material.dart';
import 'package:lebenswiki_app/features/routing/routing_constants.dart';
import 'package:lebenswiki_app/main.dart';
import 'package:lebenswiki_app/repository/shadows.dart';

class TopNav extends StatelessWidget {
  final String pageName;
  final String backName;

  const TopNav({
    Key? key,
    required this.pageName,
    required this.backName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Row(
                children: [
                  const Icon(Icons.arrow_back_ios),
                  Text(
                    backName,
                    style: const TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Text(
            pageName,
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: TextButton(
              onPressed: () {
                Navigator.pushNamed(context, authenticationWrapperRoute);
              },
              child: const Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "Fertig",
                  style: TextStyle(
                    fontSize: 15.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TopNavYour extends StatelessWidget {
  final String pageName;
  final String backName;

  const TopNavYour({
    Key? key,
    required this.pageName,
    required this.backName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Row(
                children: [
                  const Icon(Icons.arrow_back_ios),
                  Text(
                    backName,
                    style: const TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Text(
            pageName,
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: TextButton(
              onPressed: () {
                Navigator.pushNamed(context, authenticationWrapperRoute);
              },
              child: const Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "Fertig",
                  style: TextStyle(
                    fontSize: 15.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TopNavCustom extends StatelessWidget {
  final String pageName;
  final String backName;
  final String nextName;
  final Function previousCallback;
  final Function nextCallback;

  const TopNavCustom({
    Key? key,
    required this.pageName,
    required this.backName,
    required this.nextName,
    required this.previousCallback,
    required this.nextCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          LebenswikiShadows.fancyShadow,
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 50.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => previousCallback(),
                child: Row(
                  children: [
                    const Icon(Icons.arrow_back_ios),
                    Text(
                      backName,
                      style: const TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Text(
              pageName,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            Expanded(
              child: TextButton(
                onPressed: () => nextCallback(),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    nextName,
                    style: const TextStyle(
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
