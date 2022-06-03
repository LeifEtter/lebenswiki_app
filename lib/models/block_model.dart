import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:lebenswiki_app/helper/date_helper.dart';
import 'package:lebenswiki_app/models/user_model.dart';

Block blockFromJson(String str) => Block.fromJson(json.decode(str));
String blockToJson(Block data) => json.encode(data.toJson());

class Block {
    Block({
        required this.reason,
        required this.blocker,
        required this.blockerId,
        this.blocked = const [],
        required this.creationDate,
    });

    String reason;
    User blocker;
    int blockerId;
    List<User> blocked;
    DateTime creationDate;

    factory Block.fromJson(Map<String, dynamic> json) => Block(
        reason: json["reason"],
        blocker: User.fromJson(json["blocker"]),
        blockerId: json["blockerId"],
        blocked: List<User>.from(json["blocked"].map((e) => User.fromJson(e))),
        creationDate: DateTime.parse(json["creationDate"]),
    );

    Map<String, dynamic> toJson() => {
        "reason": reason,
        "blocker": blocker.toJson(),
        "blockerId": blockerId,
        "blocked": List<String>.from(blocked.map((User user) => user.toJson())),
        "creationDate": DateHelper().convertToString(creationDate),
    };
}
