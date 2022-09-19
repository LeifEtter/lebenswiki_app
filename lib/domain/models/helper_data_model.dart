import 'package:lebenswiki_app/domain/models/category_model.dart';

class HelperData {
  final int currentUserId;
  final List<ContentCategory> categories;
  final List<int> blockedIdList;

  HelperData({
    required this.blockedIdList,
    required this.categories,
    required this.currentUserId,
  });
}
