import 'package:flutter/material.dart';

class TopNavIOS extends StatelessWidget {
  final String title;

  const TopNavIOS({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 50,
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
          ),
        ),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        Container(
          width: 50,
        ),
      ],
    );
  }
}
