class CustomTimer {
  bool _active = false;
  int? _lastTime;

  CustomTimer();

  bool get isRunning => _active;

  void start() {
    _lastTime = DateTime.now().millisecondsSinceEpoch;
    _active = true;
  }

  void stop() {
    _lastTime = null;
    _active = false;
  }

  int getTimeElapsed() {
    if (_active) {
      print("Getting new time");
      return DateTime.now().millisecondsSinceEpoch - _lastTime!;
    } else {
      return 0;
    }
  }

  bool isTimeElapsed(int seconds) {
    if (_active) {
      int elapsedTime = DateTime.now().millisecondsSinceEpoch - _lastTime!;
      return elapsedTime > seconds * 1000;
    }
    return true;
  }

  double getPercentageOfTimeElapsed(int seconds) {
    if (_active) {
      int elapsedTime = DateTime.now().millisecondsSinceEpoch - _lastTime!;
      return 1 / seconds * 1000 * (elapsedTime / 1000);
    }
    return 0;
  }
}
