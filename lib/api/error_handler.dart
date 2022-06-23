class ApiErrorHandler {
  ApiErrorHandler();

  String handleAndLog({
    required Map reponseData,
  }) {
    print("API Error: $reponseData");
    return "Error";
  }
}
