import 'package:lebenswiki_app/models/enums.dart';

//TODO refactor response model to be more specific
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
