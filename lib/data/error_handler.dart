import 'dart:developer';
import 'package:http/http.dart';

class ApiErrorHandler {
  ApiErrorHandler();

  String handleAndLog({
    required Map responseData,
    required StackTrace trace,
  }) {
    log("API Error: $responseData", stackTrace: trace);
    return "Error";
  }

  logRes(Response res, StackTrace trace) {
    log("API Error: ${res.body}", stackTrace: trace);
  }
}
