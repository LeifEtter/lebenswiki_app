import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

class ValidationHelper {
  static bool validate(String email) {
    return EmailValidator.validate(email, true, true);
  }
}
