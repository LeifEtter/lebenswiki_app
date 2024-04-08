import 'dart:convert';
import 'package:http/http.dart';
import 'package:lebenswiki_app/application/auth/token_handler.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lebenswiki_app/domain/models/error.model.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

String API_URL = dotenv.env['API_URL']!;

class BaseApi {
  final serverIp = API_URL;

  BaseApi();

  Future<Map<String, String>> requestHeader() async {
    Map<String, String> header = {"Content-type": "application/json"};
    String? token = await TokenHandler().get();
    if (token != null) {
      header["authorization"] = "Bearer $token";
    }
    return header;
  }

  CustomError handleError(Response res) {
    ApiError apiError;
    try {
      int? userId;
      Map body = jsonDecode(res.body);
      if (body.containsKey("id")) {
        apiError = ApiError.fromJson(body);
        if (res.headers["authorization"] != null) {
          Map payload =
              JWT.decode(res.headers["authorization"]!.split(' ')[1]).payload;
          userId = payload["id"];
        }
        Sentry.captureException(SentryEvent(tags: {
          "requestPath": res.request!.url.toString(),
          "responseCode": res.statusCode.toString(),
          "body": res.body,
          "userId": userId.toString(),
        }));
        return CustomError(error: apiError.message);
      } else {
        Sentry.captureException(SentryEvent(tags: {
          "requestPath": res.request!.url.toString(),
          "responseCode": res.statusCode.toString(),
          "body": res.body,
          "userId": userId.toString(),
        }));
        return CustomError(error: ApiError.forUnknown().message);
      }
    } catch (error) {
      Sentry.captureException(
          SentryException(type: "Unknown Exception", value: error.toString()));
      return CustomError(error: ApiError.forUnknown().message);
    }
  }

  bool statusIsSuccess(int statusCode) {
    if (statusCode >= 200 && statusCode <= 202) {
      return true;
    } else {
      return false;
    }
  }
}
