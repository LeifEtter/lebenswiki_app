import 'package:lebenswiki_app/domain/enums/result_type_enum.dart';
import 'package:lebenswiki_app/domain/models/category.model.dart';
import 'package:lebenswiki_app/domain/models/pack/pack.model.dart';
import 'package:lebenswiki_app/domain/models/short.model.dart';
import 'package:lebenswiki_app/domain/models/user/user.model.dart';

class ResultModel {
  ResultType type;
  List responseList;
  String? message;
  String? token;

  ResultModel({
    required this.type,
    this.responseList = const [],
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
  List<Category>? categories;
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
