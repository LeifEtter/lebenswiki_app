import 'dart:developer';

import 'package:http/http.dart';

class ApiErrorHandler {
  ApiErrorHandler();

  String handleAndLog({
    required Map reponseData,
    required StackTrace trace,
  }) {
    log("API Error: $reponseData", stackTrace: trace);
    return "Error";
  }

  logRes(Response res, StackTrace trace) {
    log("API Error: ${res.body}", stackTrace: trace);
  }
}
