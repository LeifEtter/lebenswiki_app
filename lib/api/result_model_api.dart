import 'package:lebenswiki_app/models/block_model.dart';
import 'package:lebenswiki_app/models/category_model.dart';
import 'package:lebenswiki_app/models/enums.dart';
import 'package:lebenswiki_app/models/pack_model.dart';
import 'package:lebenswiki_app/models/short_model.dart';
import 'package:lebenswiki_app/models/user_model.dart';

class ResultModel {
  ResultType type;
  List responseList;
  var responseItem;
  String? message;

  ResultModel({
    required this.type,
    this.responseList = const [],
    this.responseItem,
    this.message,
  });
}
