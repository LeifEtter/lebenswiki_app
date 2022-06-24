import 'package:flutter/material.dart';

bool isLoading(AsyncSnapshot snapshot) {
  if (snapshot.data == null) {
    return true;
  } else {
    return false;
  }
}
