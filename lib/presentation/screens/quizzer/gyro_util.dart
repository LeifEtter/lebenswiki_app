import 'package:flutter/material.dart';
import 'package:lebenswiki_app/presentation/screens/quizzer/gyro_handler.dart';

Alignment gyroDirectionToAlignment(GyroDirection direction) {
  if (direction == GyroDirection.top) {
    return Alignment.topCenter;
  } else if (direction == GyroDirection.bottom) {
    return Alignment.bottomCenter;
  } else if (direction == GyroDirection.left) {
    return Alignment.centerLeft;
  } else {
    return Alignment.centerRight;
  }
}

bool gyroDirectionIsHorizontal(GyroDirection direction) {
  if (direction == GyroDirection.left || direction == GyroDirection.right) {
    return true;
  } else {
    return false;
  }
}

bool alignmentIsHorizontal(Alignment alignment) {
  if (alignment == Alignment.centerLeft || alignment == Alignment.centerRight) {
    return true;
  } else {
    return false;
  }
}
