import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateHelper {
  
  String convertToString(DateTime dateTime) {
    return DateFormat("yyyy-MM-dd HH:mm:ss").format(dateTime);
  }
}