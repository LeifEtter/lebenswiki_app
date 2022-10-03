import 'package:lebenswiki_app/domain/models/pack_model.dart';

class Read {
  final int id;
  Pack? pack;
  final int progress;
  final int packId;
  final int userId;

  Read({
    this.id = 0,
    required this.pack,
    this.progress = 0,
    required this.packId,
    required this.userId,
  });

  Read.fromJson(Map json)
      : id = json["id"],
        pack = json["pack"] != null ? Pack.fromJson(json["pack"]) : null,
        packId = json["packId"],
        userId = json["userId"],
        progress = json["progress"];

  Map<String, dynamic> toJson() => {
        "id": id,
        "pack": pack!.toJson(),
        "userId": userId,
        "packId": packId,
        "progress": progress,
      };
}
