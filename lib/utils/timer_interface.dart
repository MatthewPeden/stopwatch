import 'dart:async';

abstract class TimerInterface {
  void start(Duration duration, void Function() callback);
  void stop();
}

class RealTimer implements TimerInterface {
  Timer? _timer;

  @override
  void start(Duration duration, void Function() callback) {
    _timer = Timer.periodic(duration, (_) => callback());
  }

  @override
  void stop() {
    _timer?.cancel();
    _timer = null;
  }
}