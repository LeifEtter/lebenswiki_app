import 'package:flutter/material.dart';
import 'package:lebenswiki_app/models/enums.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReactionHelper {
  late int? userId;
  Map reactionsForContent;
  late bool userHasReacted;

  late Map _reactionMap;

  ReactionHelper({
    required this.reactionsForContent,
  }) {
    _initializeUserId();
    _setUserHasReacted();
  }

  void _setUserHasReacted() {
    if (reactionsForContent.containsKey(userId)) {
      userHasReacted = true;
    } else {
      userHasReacted = false;
    }
  }

  Future<void> _initializeUserId() async {
    var prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt("userId");
  }

  void _setReactions() {
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
    
    reactionsForContent.forEach((key, value) {
      reactionMap[key]
    });
    if (reactionData != null) {
      for (var reaction in reactionData) {
        if (reaction.containsKey("reaction")) {
          reactionMap[reaction["reaction"].toString().toLowerCase()] += 1;
        }
      }
    }
  }
}

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

Widget reactionBar({
  required Map reactionMap,
  required Function menuCallback,
  required var contentData,
  required bool isComment,
}) {
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
                contentData,
              );
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
