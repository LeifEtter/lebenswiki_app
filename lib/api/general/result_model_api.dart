import 'package:lebenswiki_app/models/category_model.dart';
import 'package:lebenswiki_app/models/enums.dart';
import 'package:lebenswiki_app/models/pack_model.dart';
import 'package:lebenswiki_app/models/short_model.dart';
import 'package:lebenswiki_app/models/user_model.dart';

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

enum RequestStatus {
  success,
  failure,
}

class RequestResult {
  RequestStatus status;
  String? errorMessage;
  Pack? pack;
  Short? short;
  List<Pack>? packs;
  List<Short>? shorts;
  List<ContentCategory>? categories;
  User? user;
  List<User>? users;

  RequestResult({
    required this.status,
    this.errorMessage,
    this.pack,
    this.short,
    this.packs,
    this.shorts,
    this.categories,
    this.user,
    this.users,
  });
}
