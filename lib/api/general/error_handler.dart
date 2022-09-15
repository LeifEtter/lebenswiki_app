import 'dart:developer';

import 'package:http/http.dart';

class ApiErrorHandler {
  ApiErrorHandler();

  String handleAndLog({
    required Map reponseData,
  }) {
    log("API Error: $reponseData");
    return "Error";
  }

  logRes(Response res) {
    log("API Error: ${res.body}");
  }
}
