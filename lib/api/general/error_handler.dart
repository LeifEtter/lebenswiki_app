import 'dart:developer';

class ApiErrorHandler {
  ApiErrorHandler();

  String handleAndLog({
    required Map reponseData,
  }) {
    log("API Error: $reponseData");
    return "Error";
  }
}
