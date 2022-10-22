import 'dart:convert';
import 'package:either_dart/either.dart';
import 'package:http/http.dart';
import 'package:lebenswiki_app/domain/models/error_model.dart';
import 'package:lebenswiki_app/repository/backend/base_api.dart';
import 'package:lebenswiki_app/repository/backend/error_handler.dart';
import 'package:lebenswiki_app/repository/backend/result_model_api.dart';
import 'package:lebenswiki_app/domain/models/category_model.dart';
import 'package:lebenswiki_app/domain/models/enums.dart';

class MiscApi extends BaseApi {
  late ApiErrorHandler apiErrorHandler;

  MiscApi() {
    apiErrorHandler = ApiErrorHandler();
  }

  Future<ResultModel> getCategories() async {
    Response res = await get(
      Uri.parse("$serverIp/categories"),
      headers: await requestHeader(),
    );
    Map decodedBody = jsonDecode(res.body);
    if (statusIsSuccess(res.statusCode)) {
      List<ContentCategory> categories = decodedBody["categories"]
          .map<ContentCategory>(
              (category) => ContentCategory.fromJson(category))
          .toList();
      //Sort categories
      categories.sort((a, b) => a.id.compareTo(b.id));
      return ResultModel(
        type: ResultType.categoryList,
        responseList: categories,
      );
    } else {
      apiErrorHandler.handleAndLog(
          reponseData: jsonDecode(res.body), trace: StackTrace.current);
      return ResultModel(
        type: ResultType.failure,
        message: "Keine Kategorien gefunden",
      );
    }
  }

  Future<Either<CustomError, String>> createFeedback(
      {required String feedback}) async {
    Response res = await post(
      Uri.parse("$serverIp/feedbacks/create"),
      headers: await requestHeader(),
      body: jsonEncode({
        "text": feedback,
      }),
    );
    if (statusIsSuccess(res.statusCode)) {
      return const Right("Feedback erfolgreich verschickt");
    } else {
      apiErrorHandler.logRes(res, StackTrace.current);
      return const Left(CustomError(
        error: "Feedback konnte nicht verschickt werden",
      ));
    }
  }
}
