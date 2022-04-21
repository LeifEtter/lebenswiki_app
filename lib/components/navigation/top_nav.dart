import 'package:flutter/material.dart';
import 'package:lebenswiki_app/data/routing_constants.dart';

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
