import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart';
import 'package:lebenswiki_app/api/general/base_api.dart';
import 'package:lebenswiki_app/api/general/error_handler.dart';
import 'package:lebenswiki_app/api/general/result_model_api.dart';
import 'package:lebenswiki_app/models/enums.dart';
import 'package:lebenswiki_app/models/report_model.dart';

class ReportApi extends BaseApi {
  late ApiErrorHandler apiErrorHandler;

  ReportApi() {
    apiErrorHandler = ApiErrorHandler();
  }

  Future<ResultModel> reportPack({required Report report}) => createReport(
      url: "reports/create/pack/${report.reportedContentId}",
      successMessage: "Successfully Reported Pack",
      errorMessage: "Couldn't Report Pack",
      requestBody: {"reason": report.reason});

  Future<ResultModel> reportShort({required Report report}) => createReport(
      url: "reports/create/short/${report.reportedContentId}",
      successMessage: "Successfully Reported Short",
      errorMessage: "Couldn't Report Short",
      requestBody: {"reason": report.reason});

  Future<ResultModel> createReport({
    required String url,
    required String successMessage,
    required String errorMessage,
    required Map requestBody,
  }) async {
    ResultModel result = ResultModel(
      type: ResultType.failure,
      message: "Error",
    );
    await post(
      Uri.parse("$serverIp/$url"),
      headers: await requestHeader(),
      body: jsonEncode(requestBody),
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
}
