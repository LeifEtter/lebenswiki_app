import 'package:flutter/material.dart';

class FutureHandling {
  late AsyncSnapshot snapshot;
  late String errorMessage;

  FutureHandling({snapshot, errorMessage});

  bool isLoading(AsyncSnapshot snapshot) {
    if (!snapshot.hasData || snapshot.data == null) {
      return true;
    } else {
      return false;
    }
  }

  bool listIsEmpty(AsyncSnapshot snapshot) {
    if (snapshot.data.length == 0) {
      return true;
    } else {
      return false;
    }
  }

  Widget errorNotFound(errorMessage) {
    return Center(child: Text(errorMessage));
  }

  Widget Loading() {
    return const Material(
      child: Center(child: CircularProgressIndicator()),
    );
  }
}
