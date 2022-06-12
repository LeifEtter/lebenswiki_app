import 'package:lebenswiki_app/models/block_model.dart';
import 'package:lebenswiki_app/models/enums.dart';
import 'package:lebenswiki_app/models/pack_model.dart';
import 'package:lebenswiki_app/models/short_model.dart';
import 'package:lebenswiki_app/models/user_model.dart';

class ResultModel {
  ResultType type;
  List<Short>? shorts;
  List<Pack>? packs;
  List<Block>? blocks;
  Short? short;
  Pack? pack;
  String? message;
  String? token;
  User? user;

  ResultModel({
    required this.type,
    this.shorts,
    this.packs,
    this.short,
    this.pack,
    this.message,
    this.token,
    this.user,
    this.blocks,
  });
}
