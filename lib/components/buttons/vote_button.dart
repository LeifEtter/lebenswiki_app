import 'package:flutter/material.dart';

class VoteButtonStack extends StatefulWidget {
  final int currentVotes;
  final Function changeVote;
  final bool hasUpvoted;
  final bool hasDownvoted;

  const VoteButtonStack({
    Key? key,
    required this.currentVotes,
    required this.changeVote,
    required this.hasUpvoted,
    required this.hasDownvoted,
  }) : super(key: key);

  @override
  _VoteButtonStackState createState() => _VoteButtonStackState();
}

class _VoteButtonStackState extends State<VoteButtonStack> {
  @override
  Widget build(BuildContext context) {
    var votes = widget.currentVotes;
    return Stack(
      children: [
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: SizedBox(
              child: Center(
                  child: Text(
                "$votes",
                style: const TextStyle(
                  fontSize: 18.0,
                  height: 1.0,
                ),
              )),
              height: 16,
              width: 25,
            ),
          ),
        ),
        SizedBox(
          width: 50,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  widget.changeVote(true);
                },
                child: ImageIcon(
                  const AssetImage(
                    "assets/icons/upvote.png",
                  ),
                  color: widget.hasUpvoted
                      ? const Color.fromRGBO(115, 148, 192, 1)
                      : Colors.black,
                  size: 30.0,
                ),
              ),
              GestureDetector(
                onTap: () {
                  widget.changeVote(false);
                },
                child: ImageIcon(
                  const AssetImage(
                    "assets/icons/downvote.png",
                  ),
                  color: widget.hasDownvoted
                      ? const Color.fromRGBO(115, 148, 192, 1)
                      : Colors.black,
                  size: 30.0,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
