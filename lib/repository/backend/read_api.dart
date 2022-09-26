import 'dart:convert';
import 'package:either_dart/either.dart';
import 'package:http/http.dart';
import 'package:lebenswiki_app/domain/models/error_model.dart';
import 'package:lebenswiki_app/domain/models/read_model.dart';
import 'package:lebenswiki_app/repository/backend/base_api.dart';
import 'package:lebenswiki_app/repository/backend/error_handler.dart';

class ReadApi extends BaseApi {
  late ApiErrorHandler apiErrorHandler;

  ReadApi() {
    apiErrorHandler = ApiErrorHandler();
  }

  Future<Either<CustomError, List<Read>>> getAll() async {
    Response res = await get(
      Uri.parse("$serverIp/reads"),
      headers: await requestHeader(),
    );
    if (statusIsSuccess(res.statusCode)) {
      List<Read> reads =
          jsonDecode(res.body)["reads"].map((read) => Read.fromJson(read));
      return Right(reads);
    } else {
      apiErrorHandler.logRes(res);
      return const Left(CustomError(error: "Irgendwas ist schiefgelaufen"));
    }
  }

  Future<Either<CustomError, String>> create({required int packId}) async {
    Response res = await post(
      Uri.parse("$serverIp/reads/create/$packId"),
      headers: await requestHeader(),
    );
    if (statusIsSuccess(res.statusCode)) {
      return const Right("Pack Gestarted");
    } else {
      apiErrorHandler.logRes(res);
      return const Left(CustomError(error: "Irgendwas ist schiefgelaufen"));
    }
  }

  Future<Either<CustomError, String>> update(
      {required int id, required int newProgress}) async {
    Response res = await post(
      Uri.parse("$serverIp/reads/update/$id"),
      headers: await requestHeader(),
      body: jsonEncode({
        "progress": newProgress,
      }),
    );
    if (statusIsSuccess(res.statusCode)) {
      return const Right("Progress Updates");
    } else {
      apiErrorHandler.logRes(res);
      return const Left(CustomError(error: "Irgendwas ist schiefgelaufen"));
    }
  }
}
