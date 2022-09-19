import 'package:lebenswiki_app/application/date_helper.dart';
import 'package:lebenswiki_app/domain/models/user_model.dart';

class Block {
  Block({
    required this.reason,
    required this.blocker,
    required this.blockerId,
    required this.blocked,
    required this.blockedId,
    required this.creationDate,
  });

  String reason;
  int blockerId;
  User blocker;
  int blockedId;
  User blocked;
  DateTime creationDate;

  factory Block.fromJson(Map<String, dynamic> json) => Block(
        reason: json["reason"],
        blocker: User.forContent(json["blocker"]),
        blockerId: json["blockerId"],
        blocked: User.forContent(json["blocked"]),
        blockedId: json["blockedId"],
        creationDate: DateTime.parse(json["creationDate"]),
      );

  Map<String, dynamic> toJson() => {
        "reason": reason,
        "blocker": blocker.toJson(),
        "blockerId": blockerId,
        "blocked": blocked.toJson(),
        "blockedId": blockedId,
        "creationDate": DateHelper().convertToString(creationDate),
      };
}
