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

  Future<ResultModel> createCommentShort({
    required int id,
    required String comment,
  }) =>
      _createComment(
          url: "comments/create/shorts/$id",
          successMessage: "Commented on short successfully",
          errorMessage: "Couldn't comment on short",
          comment: comment);

  Future<ResultModel> createCommentPack({
    required int id,
    required String comment,
  }) =>
      _createComment(
          url: "comments/create/packs/$id",
          successMessage: "Commented on pack successfully",
          errorMessage: "Couldn't comment on pack",
          comment: comment);

  Future<ResultModel> _createComment({
    required String url,
    required String successMessage,
    required String errorMessage,
    required String comment,
  }) async {
    await post(
      Uri.parse("$serverIp/$url"),
      headers: await requestHeader(),
      body: jsonEncode({"comment": comment}),
    ).then((Response res) {
      if (statusIsSuccess(res.statusCode)) {
        return ResultModel(
          type: ResultType.success,
          message: successMessage,
        );
      } else {
        apiErrorHandler.handleAndLog(reponseData: jsonDecode(res.body));
      }
    }).catchError((error) {
      apiErrorHandler.handleAndLog(reponseData: error);
    });
    return ResultModel(
      type: ResultType.failure,
      message: errorMessage,
    );
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
