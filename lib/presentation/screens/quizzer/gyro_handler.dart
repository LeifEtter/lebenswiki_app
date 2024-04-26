import 'package:lebenswiki_app/domain/models/custom_timer.dart';
import 'package:sensors_plus/sensors_plus.dart';

enum GyroDirection { none, top, right, bottom, left }

class GyroHandler {
  final Function(GyroDirection direction) updateDirectionCallback;
  late CustomTimer gyroTimer;
  final int timeBetweenDetections;

  GyroHandler({
    required this.updateDirectionCallback,
    required this.timeBetweenDetections,
  }) {
    gyroTimer = CustomTimer();
    initListener();
  }

  void initListener() {
    gyroscopeEventStream().listen(
      checkGyroForDirection,
      onError: (error) => print(error),
      cancelOnError: false,
    );
  }

  void checkGyroForDirection(GyroscopeEvent event) {
    if (gyroTimer.isRunning) {
      if (gyroTimer.isTimeElapsed(timeBetweenDetections)) {
        gyroTimer.stop();
        updateDirectionCallback(GyroDirection.none);
      } else {
        return;
      }
    }
    GyroDirection newDirection = computeGyroDirection(event.x, event.y);
    if (newDirection != GyroDirection.none) {
      gyroTimer.start();
      updateDirectionCallback(newDirection);
    }
  }

  GyroDirection computeGyroDirection(double x, double y) {
    if (x > 3 && x.abs() > y.abs()) {
      return GyroDirection.bottom;
    }
    if (x < -3 && x.abs() > y.abs()) {
      return GyroDirection.top;
    }
    if (y < -3 && y.abs() > x.abs()) {
      return GyroDirection.left;
    }
    if (y > 3 && y.abs() > x.abs()) {
      return GyroDirection.right;
    }
    return GyroDirection.none;
  }
}
