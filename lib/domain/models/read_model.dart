import 'package:lebenswiki_app/domain/models/pack_model.dart';

class Read {
  final Pack pack;
  final int progress;
  final int packId;
  final int userId;

  const Read({
    required this.pack,
    this.progress = 0,
    required this.packId,
    required this.userId,
  });

  Read.fromJson(Map json)
      : pack = Pack.fromJson(json["pack"]),
        packId = json["packId"],
        userId = json["userId"],
        progress = json["progress"];

  Map<String, dynamic> toJson() => {
        "pack": pack.toJson(),
        "userId": userId,
        "packId": packId,
        "progress": progress,
      };
}
