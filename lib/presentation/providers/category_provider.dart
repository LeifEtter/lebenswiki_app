import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lebenswiki_app/domain/models/category.model.dart';

class CategoryProvider extends ChangeNotifier {
  List<Category>? _categories;

  List<Category> get categories => _categories ?? [];

  void setCategories(List<Category> categories) {
    _categories = categories;
    // _categories!.insert(0, Category.forNew());
    notifyListeners();
  }

  void removeCategories() {
    _categories = null;
  }
}

final categoryProvider =
    ChangeNotifierProvider<CategoryProvider>(((ref) => CategoryProvider()));
