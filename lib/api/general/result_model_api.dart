import 'package:lebenswiki_app/models/enums.dart';

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
