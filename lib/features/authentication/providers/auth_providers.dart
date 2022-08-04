import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lebenswiki_app/features/authentication/helpers/string_validation_extensions.dart';
import 'package:lebenswiki_app/models/user_model.dart';
import 'package:lebenswiki_app/repository/image_repo.dart';

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
  ValidationModel _profileImage =
      ValidationModel(ImageRepo.standardProfileImage, null);
  ValidationModel _repeatPassword = ValidationModel(null, null);
  ValidationModel _oldPassword = ValidationModel(null, null);
  ValidationModel get name => _name;
  ValidationModel get email => _email;
  ValidationModel get password => _password;
  ValidationModel get biography => _biography;
  ValidationModel get profileImage => _profileImage;
  ValidationModel get repeatPassword => _repeatPassword;
  ValidationModel get oldPassword => _oldPassword;

  void validateEmail(String? val) {
    if (val != null && val.isValidEmail) {
      _email = ValidationModel(val, null);
    } else {
      _email = ValidationModel(null, 'Bitte eine valide Email eingeben');
    }
    notifyListeners();
  }

  void validatePassword(String? val) {
    if (val != null && val.isValidPassword) {
      _password = ValidationModel(val, null);
    } else {
      _password = ValidationModel(null,
          'Password sollte mind. 6 Zeichen lang sein, einen Groß- und Kleinbuchstaben als auch eine Zahl enthalten');
    }
    notifyListeners();
  }

  void validateOldPassword(String? val) {
    if (val != null && val.isValidPassword) {
      _oldPassword = ValidationModel(val, null);
    } else {
      _oldPassword = ValidationModel(null,
          'Password sollte mind. 6 Zeichen lang sein, einen Groß- und Kleinbuchstaben als auch eine Zahl enthalten');
    }
    notifyListeners();
  }

  void validateRepeatPassword(String? val) {
    if (val != null && val == _password.value) {
      _repeatPassword = ValidationModel(val, null);
    } else {
      _repeatPassword =
          ValidationModel(null, 'Passwörter müssen übereinstimmen');
    }
    notifyListeners();
  }

  void validateName(String? val) {
    if (val != null && val.isValidName) {
      _name = ValidationModel(val, null);
    } else {
      _name = ValidationModel(null, 'Bitte gib einen Namen an');
    }
    notifyListeners();
  }

  void validateBiography(String? val) {
    _biography = ValidationModel(val, null);
    notifyListeners();
  }

  //TODO generate Regex for profile image (validate that val is link)
  void validateProfileImage(String? val) {
    _profileImage = ValidationModel(val, null);
    notifyListeners();
  }

  void resetErrors() {
    _name.error = null;
    _email.error = null;
    _biography.error = null;
    _password.error = null;
    _profileImage.error = null;
    _repeatPassword.error = null;
    _oldPassword.error = null;
    notifyListeners();
  }

  void convertFromUser(User user) {
    _name.value = user.name;
    _email.value = user.email;
    _biography.value = user.biography;
    _password.value = user.password;
    _profileImage.value = user.profileImage;
  }

  User convertToUser() => User(
        name: _name.value ?? "",
        email: _email.value,
        biography: _biography.value ?? "",
        password: password.value,
        profileImage: profileImage.value ?? "",
      );

  bool get validateForRegister {
    validateName(_name.value);
    validateEmail(_email.value);
    validatePassword(_password.value);
    validateRepeatPassword(_repeatPassword.value);
    validateBiography(_biography.value);
    validateProfileImage(_profileImage.value);
    return _email.value != null &&
        _password.value != null &&
        _name.value != null &&
        _profileImage.value != null &&
        _repeatPassword.value != null;
  }

  bool get validateForLogin {
    validateEmail(email.value);
    validatePassword(password.value);
    return _email.value != null && _password.value != null;
  }

  bool get validateForPasswordUpdate {
    return _oldPassword.value != null &&
        _password.value != null &&
        _repeatPassword.value != null;
  }

  bool get validateForProfileUpdate {
    return _email.value != null &&
        _biography.value != null &&
        _name.value != null &&
        _profileImage.value != null;
  }

  void handleApiError(String errorMessage) {
    switch (errorMessage) {
      case "user_not_found":
        _email.error = "Email konnte nicht gefunden werden";
        break;
      case "invalid_mail":
        _email.error = "Email und Passwort stimmen nicht überein";
        _password.error = "Email und Passwort stimmen nicht überein";
        break;
      case "email/password_is_incorrect":
        _email.error = "Email und Passwort stimmen nicht überein";
        _password.error = "Email und Passwort stimmen nicht überein";
        break;
      case "oldPassword_is_incorrect":
        _oldPassword.error = "Altes Password stimmt nicht";
    }
    notifyListeners();
  }
}

final formProvider = ChangeNotifierProvider(((ref) => FormNotifier()));
