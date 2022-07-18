import 'package:flutter/material.dart';

class AppLocale extends ChangeNotifier {
  Locale? _locale;

  Locale get locale => _locale ?? const Locale('de');

  void changeLocale(Locale newLocale) {
    if (newLocale == const Locale('es')) {
      _locale = const Locale('es');
    } else {
      _locale = const Locale('en');
    }
    notifyListeners();
  }
}
