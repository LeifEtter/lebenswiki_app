import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:lebenswiki_app/api/api_models/base_api.dart';
import 'package:lebenswiki_app/api/api_models/error_handler.dart';
import 'package:lebenswiki_app/api/api_models/result_model_api.dart';
import 'package:lebenswiki_app/models/category_model.dart';
import 'package:lebenswiki_app/models/enums.dart';

class MiscApi extends BaseApi {
  late ApiErrorHandler apiErrorHandler;

  MiscApi() {
    apiErrorHandler = ApiErrorHandler();
  }

  Future<ResultModel> getCategories() async {
    Response res = await get(
      Uri.parse("$serverIp/categories"),
      headers: requestHeader(),
    );
    Map decodedBody = jsonDecode(res.body);
    if (statusIsSuccess(res.statusCode)) {
      return ResultModel(
          type: ResultType.categoryList,
          categories: decodedBody["categories"].map(
            (category) => ContentCategory.fromJson(category),
          ));
    } else {
      apiErrorHandler.handleAndLog(reponseData: jsonDecode(res.body));
      return ResultModel(
        type: ResultType.failure,
        message: "Keine Kategorien gefunden",
      );
    }
  }
}
