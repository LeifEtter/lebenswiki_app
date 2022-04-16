import 'package:flutter/material.dart';

bool isLoading(AsyncSnapshot snapshot) {
  if (!snapshot.hasData || snapshot.data == null) {
    return true;
  } else {
    return false;
  }
}
