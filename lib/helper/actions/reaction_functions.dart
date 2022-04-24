import 'package:flutter/material.dart';
import 'package:lebenswiki_app/data/enums.dart';

List allReactions = [
  "happy",
  "catheart",
  "clap",
  "heart",
  "money",
  "laughing",
  "thumbsup",
  "thinking"
];

bool checkReaction(userId, reactions) {
  if (reactions == null) {
    return false;
  } else {
    for (var reaction in reactions) {
      if (reaction["id"] == userId) {
        return true;
      }
    }
    return false;
  }
}

Map convertReactions(reactionData) {
  Map reactionMap = {
    "happy": 0,
    "catheart": 0,
    "clap": 0,
    "heart": 0,
    "money": 0,
    "laughing": 0,
    "thumbsup": 0,
    "thinking": 0,
  };
  //Add Reactions from DB to Reaction Map
  if (reactionData != null) {
    for (var reaction in reactionData) {
      if (reaction.containsKey("reaction")) {
        reactionMap[reaction["reaction"].toString().toLowerCase()] += 1;
      }
    }
  }
  return reactionMap;
}

Widget reactionBar(reactionMap, Function menuCallback, packData, isComment) {
  return ListView.builder(
    shrinkWrap: true,
    scrollDirection: Axis.horizontal,
    itemCount: reactionMap.length + 1,
    itemBuilder: (context, i) {
      //Return add Reactoin symbol
      if (i == reactionMap.length) {
        return Padding(
          padding: const EdgeInsets.only(left: 10.0, bottom: 5.0),
          child: GestureDetector(
            child: Image.asset("assets/emojis/add_reaction.png"),
            onTap: () {
              menuCallback(
                isComment ? MenuType.reactShortComment : MenuType.reactShort,
                packData,
              );
              //openMenu();
              /*setState(() {
                reactionMenuOpen = true;
              });*/
            },
          ),
        );
      } else {
        //Show Reaction with amount
        String reaction = reactionMap.keys.elementAt(i);
        int amount = reactionMap.values.elementAt(i);

        if (amount != 0) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Image.asset("assets/emojis/$reaction.png"),
                ),
                Text(amount.toString()),
              ],
            ),
          );
        } else {
          return Container();
        }
      }
    },
  );
}
