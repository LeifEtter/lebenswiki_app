import 'dart:convert';
import 'package:either_dart/either.dart';
import 'package:http/http.dart';
import 'package:lebenswiki_app/domain/models/error_model.dart';
import 'package:lebenswiki_app/repository/backend/base_api.dart';
import 'package:lebenswiki_app/repository/backend/error_handler.dart';
import 'package:lebenswiki_app/repository/backend/result_model_api.dart';
import 'package:lebenswiki_app/domain/models/enums.dart';

class CommentApi extends BaseApi {
  late ApiErrorHandler apiErrorHandler;

  CommentApi() {
    apiErrorHandler = ApiErrorHandler();
  }

  Future<Either<CustomError, String>> createCommentShort({
    required int id,
    required String comment,
  }) =>
      _createComment(
        url: "comments/create/shorts/$id",
        successMessage: "Erfolgreich Kommentiert",
        errorMessage: "Kommentar konnte nicht erstellt werden",
        comment: comment,
      );

  Future<Either<CustomError, String>> createCommentPack({
    required int id,
    required String comment,
  }) =>
      _createComment(
          url: "comments/create/pack/$id",
          successMessage: "Erfolgreich Kommentiert",
          errorMessage: "Kommentar konnte nicht erstellt werden",
          comment: comment);

  Future<Either<CustomError, String>> _createComment({
    required String url,
    required String successMessage,
    required String errorMessage,
    required String comment,
  }) async {
    Response res = await post(
      Uri.parse("$serverIp/$url"),
      headers: await requestHeader(),
      body: jsonEncode({"comment": comment}),
    );

    if (statusIsSuccess(res.statusCode)) {
      return Right(successMessage);
    } else {
      apiErrorHandler.logRes(res, StackTrace.current);
      return Left(CustomError(error: errorMessage));
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
      apiErrorHandler.handleAndLog(
          reponseData: jsonDecode(res.body), trace: StackTrace.current);
      return ResultModel(
        type: ResultType.failure,
        message: "Konnte nicht reagieren",
      );
    }
  }

  Future<ResultModel> upvoteComment(id) => _interactComment(
      url: "comments/upvote/$id",
      successMessage: "Kommentar bewertet",
      errorMessage: "Kommentar konnte nicht bewertet werden");

  Future<ResultModel> downvoteComment(id) => _interactComment(
      url: "comments/downvote/$id",
      successMessage: "Kommentar bewertet",
      errorMessage: "Kommentar konnte nicht bewertet werden");

  Future<ResultModel> removeUpvoteComment(id) => _interactComment(
      url: "comments/upvote/remove/$id",
      successMessage: "Bewertung wurde entfernt",
      errorMessage: "Bewertung konnte nicht entfernt werden");

  Future<ResultModel> removeDownvoteComment(id) => _interactComment(
      url: "comments/downvote/remove/$id",
      successMessage: "Bewertung wurde entfernt",
      errorMessage: "Bewertung konnte nicht entfernt werden");

  Future<ResultModel> _interactComment({
    required String url,
    required String successMessage,
    required String errorMessage,
  }) async {
    ResultModel result = ResultModel(type: ResultType.failure);
    await put(
      Uri.parse("$serverIp/$url"),
      headers: await requestHeader(),
    ).then((Response res) {
      if (statusIsSuccess(res.statusCode)) {
        result = ResultModel(
          type: ResultType.success,
          message: successMessage,
        );
      } else {
        apiErrorHandler.handleAndLog(
            reponseData: jsonDecode(res.body), trace: StackTrace.current);
      }
    }).catchError((error) {
      apiErrorHandler.handleAndLog(
          reponseData: error, trace: StackTrace.current);
    });
    return result;
  }

  Future<Either<CustomError, String>> deleteComment({
    required int id,
  }) async {
    Response res = await delete(
      Uri.parse("$serverIp/comments/delete/$id"),
      headers: await requestHeader(),
    );
    if (statusIsSuccess(res.statusCode)) {
      return const Right("Dein Kommentar wurde gelöscht.");
    } else {
      return const Left(
          CustomError(error: "Dein Kommentar konnte nicht gelöscht werden"));
    }
  }
}
