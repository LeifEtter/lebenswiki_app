import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lebenswiki_app/features/authentication/helpers/string_validation_extensions.dart';

class ValidationModel {
  String? value;
  String? error;
  ValidationModel(this.value, this.error);
}

class FormNotifier extends ChangeNotifier {
  ValidationModel _name = ValidationModel(null, null);
  ValidationModel _email = ValidationModel(null, null);
  ValidationModel _password = ValidationModel(null, null);
  ValidationModel _biography = ValidationModel(null, null);
  ValidationModel _profileImage = ValidationModel(null, null);
  ValidationModel get name => _name;
  ValidationModel get email => _email;
  ValidationModel get password => _password;
  ValidationModel get biography => _biography;
  ValidationModel get profileImage => _profileImage;

  void validateEmail(String? val) {
    if (val != null && val.isValidEmail) {
      _email = ValidationModel(val, null);
    } else {
      _email = ValidationModel(null, 'Please Enter a Valid Email');
    }
    notifyListeners();
  }

  void validatePassword(String? val) {
    if (val != null && val.isValidPassword) {
      _password = ValidationModel(val, null);
    } else {
      _password = ValidationModel(null,
          'Password must contain an uppercase, lowercase, numeric digit and special character');
    }
    notifyListeners();
  }

  void validateName(String? val) {
    if (val != null && val.isValidName) {
      _name = ValidationModel(val, null);
    } else {
      _name = ValidationModel(null, 'Please enter a valid name');
    }
    notifyListeners();
  }

  //TODO generate Regex for biography
  void validateBiography(String? val) {
    _biography = ValidationModel(val, null);
    notifyListeners();
  }

  //TODO generate Regex for profile image (validate that val is link)
  void validateProfileImage(String? val) {
    _profileImage = ValidationModel(val, null);
    notifyListeners();
  }

  bool get validate {
    return _email.value != null &&
        _password.value != null &&
        _biography.value != null &&
        _name.value != null &&
        _profileImage.value != null;
  }
}

final formProvider = ChangeNotifierProvider(((ref) => FormNotifier()));
