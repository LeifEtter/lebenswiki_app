import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';

class ReloadNotifier extends ChangeNotifier {
  void reload() {
    notifyListeners();
  }
}

final reloadProvider = ChangeNotifierProvider((ref) => ReloadNotifier());
