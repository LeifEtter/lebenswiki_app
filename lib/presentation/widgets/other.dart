import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/foundation/key.dart';
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

class CustomError {
  final String error;

  const CustomError({required this.error});
}

class CheckData {
  static bool imageIsLocal(String image) {
    if (image.startsWith("assets/")) {
      return true;
    } else {
      return false;
    }
  }
}

class RoundAvatar extends StatelessWidget {
  final String image;
  final double size;

  const RoundAvatar({
    Key? key,
    required this.image,
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: CheckData.imageIsLocal(image)
            ? DecorationImage(image: AssetImage(image))
            : DecorationImage(image: NetworkImage(image)),
      ),
    );
  }
}
