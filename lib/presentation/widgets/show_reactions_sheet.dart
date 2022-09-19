import 'package:flutter/material.dart';
import 'package:lebenswiki_app/repository/constants/misc_repo.dart';

void showReactionMenu(
  BuildContext context, {
  required Function callback,
}) {
  showModalBottomSheet(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
    context: context,
    builder: (context) {
      return Container(
        height: 300,
        padding: const EdgeInsets.only(top: 20.0, left: 50.0, right: 50.0),
        child: Column(
          children: [
            const SizedBox(height: 10.0),
            const Text(
              "Wähle deine Reaktion",
              style: TextStyle(
                fontSize: 30.0,
              ),
            ),
            const SizedBox(height: 20.0),
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
              ),
              itemCount: MiscRepo.allReactions.length,
              itemBuilder: (BuildContext context, index) {
                String reaction = MiscRepo.allReactions[index].toUpperCase();
                return GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    callback(reaction);
                  },
                  child: Image.asset(
                    "assets/emojis/${reaction.toLowerCase()}.png",
                    width: 20,
                  ),
                );
              },
            ),
          ],
        ),
      );
    },
    isDismissible: true,
  );
}
