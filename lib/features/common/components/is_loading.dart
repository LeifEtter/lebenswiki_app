import 'package:flutter/material.dart';

class LoadingHelper {
  static bool isLoading(AsyncSnapshot snapshot) =>
      snapshot.data == null ? true : false;

  static Widget loadingIndicator() =>
      const Material(child: Center(child: CircularProgressIndicator()));
}
