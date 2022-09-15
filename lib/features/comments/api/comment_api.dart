import 'dart:convert';
import 'package:either_dart/either.dart';
import 'package:http/http.dart';
import 'package:lebenswiki_app/api/general/base_api.dart';
import 'package:lebenswiki_app/api/general/error_handler.dart';
import 'package:lebenswiki_app/api/general/result_model_api.dart';
import 'package:lebenswiki_app/features/a_new_common/other.dart';
import 'package:lebenswiki_app/features/comments/models/comment_model.dart';
import 'package:lebenswiki_app/models/enums.dart';

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
          successMessage: "Commented on short successfully",
          errorMessage: "Couldn't comment on short",
          comment: comment);

  Future<Either<CustomError, String>> createCommentPack({
    required int id,
    required String comment,
  }) =>
      _createComment(
          url: "comments/create/pack/$id",
          successMessage: "Commented on pack successfully",
          errorMessage: "Couldn't comment on pack",
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
      return Right("success");
    } else {
      apiErrorHandler.logRes(res);
      return const Left(CustomError(error: "Du konntest nicht kommentieren"));
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

  Future<ResultModel> upvoteComment(id) => _interactComment(
      url: "comments/upvote/$id",
      successMessage: "Successfully Upvoted Comment",
      errorMessage: "Couldn't Upvote Comment");

  Future<ResultModel> downvoteComment(id) => _interactComment(
      url: "comments/downvote/$id",
      successMessage: "Successfully Downvoted Comment",
      errorMessage: "Couldn't Downvote Comment");

  Future<ResultModel> removeUpvoteComment(id) => _interactComment(
      url: "comments/upvote/remove/$id",
      successMessage: "Successfully Removed Upvote from Comment",
      errorMessage: "Couldn't Remove Upvote Comment");

  Future<ResultModel> removeDownvoteComment(id) => _interactComment(
      url: "comments/downvote/remove/$id",
      successMessage: "Successfully Removed Downvote Comment",
      errorMessage: "Couldn't Remove Downvote Comment");

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
        apiErrorHandler.handleAndLog(reponseData: jsonDecode(res.body));
      }
    }).catchError((error) {
      apiErrorHandler.handleAndLog(reponseData: error);
    });
    return result;
  }

  Future<ResultModel> deleteComment({
    required int id,
  }) async {
    ResultModel result = ResultModel(
      type: ResultType.failure,
      message: "Couldn't delete comment",
    );
    await delete(
      Uri.parse("$serverIp/comments/delete/$id"),
      headers: await requestHeader(),
    ).then((Response res) {
      if (statusIsSuccess(res.statusCode)) {
        result = ResultModel(
          type: ResultType.success,
          message: "Comment successfully deleted",
        );
      } else {
        apiErrorHandler.handleAndLog(reponseData: jsonDecode(res.body));
      }
    }).catchError((error) {
      apiErrorHandler.handleAndLog(reponseData: error);
    });
    return result;
  }
}
