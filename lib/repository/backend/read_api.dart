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
      List<Map> readList = List<Map>.from(jsonDecode(res.body)["reads"]);
      List<Read> reads = readList.map((read) {
        return Read.fromJson(read);
      }).toList();
      return Right(reads);
    } else {
      apiErrorHandler.logRes(res);
      return const Left(CustomError(error: "Irgendwas ist schiefgelaufen"));
    }
  }

  Future<Either<CustomError, Read>> create({required int packId}) async {
    Response res = await post(
      Uri.parse("$serverIp/reads/create/$packId"),
      headers: await requestHeader(),
    );
    if (statusIsSuccess(res.statusCode)) {
      return Right(Read.fromJson(jsonDecode(res.body)["read"]));
    } else {
      apiErrorHandler.logRes(res);
      return const Left(CustomError(error: "Irgendwas ist schiefgelaufen"));
    }
  }

  Future<Either<CustomError, String>> update(
      {required int id, required int newProgress}) async {
    Response res = await put(
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
