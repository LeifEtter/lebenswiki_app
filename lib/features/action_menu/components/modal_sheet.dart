import 'package:flutter/material.dart';

Widget buildMenuItem(
    IconData icon, String title, String description, Function menuAction) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10.0),
    child: GestureDetector(
      onTap: () => menuAction(),
      child: Row(
        children: [
          Icon(
            icon,
            size: 40.0,
          ),
          const SizedBox(width: 20.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20.0,
                ),
              ),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 15.0,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
