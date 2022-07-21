import 'package:flutter/material.dart';
import 'package:lebenswiki_app/models/enums.dart';

//Generates a Helper Object for a specific Pack, Short or Comment
//The Helper is able to convert reactions to a readable reaction Map
class ReactionHelper {
  int userId;
  List<Map> reactionsResponse;
  //List structure
  //  [ { id: 0, reaction: "" } ]

  //Reaction Notes:
  // * When sending reaction only send reaction string
  // * Receiving will be the list mentioned
  // * id refers to the user that has reacted

  late bool userHasReacted;

  //Will hold formatted usable reactions
  late Map _reactionMap;

  ReactionHelper({
    required this.userId,
    required this.reactionsResponse,
  }) {
    _generateReactionMap();
    _fillReactionMapAndDetectUserReaction();
  }

  void _generateReactionMap() {
    Map result = {};
    for (var value in Reactions.values) {
      result[value.name] = 0;
    }
    _reactionMap = result;
  }

  void _fillReactionMapAndDetectUserReaction() {
    for (Map reactionData in reactionsResponse) {
      if (reactionData.containsValue(userId)) userHasReacted = true;
      String reactionName = reactionData["reaction"];
      _reactionMap[reactionName.toLowerCase()] += 1;
    }
  }

  Widget reactionBar() {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: _reactionMap.length + 1,
      itemBuilder: (BuildContext context, int i) {
        //Return add Reactoin symbol
        if (i == _reactionMap.length) {
          return Padding(
            padding: const EdgeInsets.only(left: 10.0, bottom: 5.0),
            child: GestureDetector(
                child: Image.asset("assets/emojis/add_reaction.png"),
                onTap: () {} //TODO implement m,enu call,
                ),
          );
        } else {
          //Show Reaction with amount
          String reaction = _reactionMap.keys.elementAt(i);
          int amount = _reactionMap.values.elementAt(i);

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
}
