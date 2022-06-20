class ApiErrorHandler {
  ApiErrorHandler();

  String handleAndLog({
    required Map reponseData,
  }) {
    print(reponseData);
    return "Error";
  }
}
