import 'dart:convert';

import 'package:http/http.dart';
import 'package:lebenswiki_app/api/general/base_api.dart';
import 'package:lebenswiki_app/api/general/error_handler.dart';
import 'package:lebenswiki_app/api/general/result_model_api.dart';
import 'package:lebenswiki_app/models/enums.dart';

class CommentApi extends BaseApi {
  late ApiErrorHandler apiErrorHandler;

  CommentApi() {
    apiErrorHandler = ApiErrorHandler();
  }

  Future<ResultModel> commentPack({
    required int id,
    required String comment,
  }) async {
    Response res = await post(Uri.parse("$serverIp/comments/create/packs/$id"),
        headers: await requestHeader(), body: jsonEncode({"comment": comment}));
    if (statusIsSuccess(res.statusCode)) {
      return ResultModel(
        type: ResultType.success,
        message: "Erfolgreich Kommentiert",
      );
    } else {
      apiErrorHandler.handleAndLog(reponseData: jsonDecode(res.body));
      return ResultModel(
        type: ResultType.failure,
        message: "Kommentar konnte nicht erstellt werden",
      );
    }
  }

  Future<ResultModel> addCommentReaction({
    required int id,
    required String reaction,
  }) async {
    Response res = await post(
      Uri.parse("$serverIp/comments/reaction/$id"),
      headers: await requestHeader(),
      body: jsonEncode({"reaction": reaction}),
    );
    if (statusIsSuccess(res.statusCode)) {
      return ResultModel(
        type: ResultType.success,
        message: "Reagiert",
      );
    } else {
      apiErrorHandler.handleAndLog(reponseData: jsonDecode(res.body));
      return ResultModel(
        type: ResultType.failure,
        message: "Konnte nicht reagieren",
      );
    }
  }
}
