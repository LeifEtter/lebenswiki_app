import 'package:lebenswiki_app/domain/models/category_model.dart';
import 'package:lebenswiki_app/domain/models/enums.dart';
import 'package:lebenswiki_app/domain/models/pack_model.dart';
import 'package:lebenswiki_app/domain/models/short_model.dart';
import 'package:lebenswiki_app/domain/models/user_model.dart';

class ResultModel {
  ResultType type;
  List responseList;
  var responseItem;
  String? message;
  String? token;

  ResultModel({
    required this.type,
    this.responseList = const [],
    this.responseItem,
    this.message,
    this.token,
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
