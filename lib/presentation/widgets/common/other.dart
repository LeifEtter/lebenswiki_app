import 'package:flutter/material.dart';
import 'package:lebenswiki_app/domain/models/category_model.dart';



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
