import 'dart:convert';
import 'dart:developer';
import 'package:either_dart/either.dart';
import 'package:http/http.dart';
import 'package:lebenswiki_app/domain/models/category.model.dart';
import 'package:lebenswiki_app/domain/models/error.model.dart';
import 'package:lebenswiki_app/data/error_handler.dart';
import 'package:lebenswiki_app/data/base_api.dart';

class CategoryApi extends BaseApi {
  late ApiErrorHandler apiErrorHandler;

  CategoryApi() {
    apiErrorHandler = ApiErrorHandler();
  }
  Future<Either<CustomError, List<Category>>>
      getCategorizedPacksAndShorts() async {
    try {
      Response res = await get(
        Uri.parse("$serverIp/category/packsAndShorts"),
        headers: await requestHeader(),
      );

      if (res.statusCode == 200) {
        List<dynamic> body = await jsonDecode(res.body);
        List<Category> categories =
            body.map((e) => Category.fromJson(e)).toList();
        return Right(categories);
      } else {
        // await Sentry.captureEvent(SentryEvent(message: SentryMessage("")),));
        apiErrorHandler.logRes(res, StackTrace.current);
        return const Left(CustomError(error: "Irgendwas ist schiefgelaufen"));
      }
    } catch (error) {
      log(error.toString());
      // await Sentry.captureException();
      return const Left(CustomError(error: "Something went wrong"));
    }
  }

  Future<List<Category>> getCategories() async {
    try {
      Response res = await get(
        Uri.parse("$serverIp/category/"),
        headers: await requestHeader(),
      );
      if (res.statusCode == 200) {
        List body = jsonDecode(res.body);
        List<Category> categories =
            body.map((e) => Category.fromJson(e)).toList();
        return categories;
      } else {
        log(res.body);
        throw "Couldn't fetch categories";
      }
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
