import 'package:flutter/material.dart';

Widget reactionBar(Map reactionMap, Function callback) {
  return ListView.builder(
    shrinkWrap: true,
    scrollDirection: Axis.horizontal,
    itemCount: reactionMap.length + 1,
    itemBuilder: (BuildContext context, int i) {
      //Return add Reactoin symbol
      if (i == reactionMap.length) {
        return Padding(
          padding: const EdgeInsets.only(left: 10.0, bottom: 5.0),
          child: GestureDetector(
            child: Image.asset("assets/emojis/add_reaction.png"),
            onTap: () => callback(),
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
