import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:either_dart/either.dart';
import 'package:http/http.dart';
import 'package:lebenswiki_app/data/base_api.dart';
import 'package:lebenswiki_app/data/error_handler.dart';
import 'package:lebenswiki_app/domain/models/error.model.dart';

class LogApi extends BaseApi {
  late ApiErrorHandler apiErrorHandler;

  LogApi() {
    apiErrorHandler = ApiErrorHandler();
  }

  Future<String?> _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.id; // unique ID on Android
    }
    return null;
  }

  Future<Either<CustomError, String>> log({
    String? event,
    StackTrace? stackTrace,
  }) async {
    try {
      Response res = await post(
        Uri.parse("$serverIp/log/"),
        headers: await requestHeader(),
        body: jsonEncode({
          "platform": Platform.isAndroid ? "android" : "ios",
          "deviceId": await _getId(),
          "event": event,
          "stackTrace": stackTrace.toString(),
        }),
      );
      if (res.statusCode == 201) {
        return const Right("Event Logged Successfully");
      } else {
        return const Left(CustomError(error: "Log Creation not successful"));
      }
    } catch (error) {
      return const Left(CustomError(error: "Couldn't create Log"));
    }
  }
}
