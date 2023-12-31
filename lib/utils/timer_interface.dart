import 'dart:async';

import 'package:mockito/mockito.dart';

abstract class TimerInterface {
  void start(void Function() callback);
  void stop();
  void reset();
  Duration get elapsedTime;
}

class RealTimer implements TimerInterface {
  final Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;

  @override
  void start(void Function() callback) {
    _stopwatch.start();
    _timer = Timer.periodic(const Duration(milliseconds: 10), (_) => callback());
  }

  @override
  void stop() {
    _stopwatch.stop();
    _timer?.cancel();
    _timer = null;
  }

  @override
  void reset() {
    _stopwatch.reset();
  }

  @override
  Duration get elapsedTime => _stopwatch.elapsed;
}

class MockTimer extends Mock implements TimerInterface {
  Duration _elapsedTime = Duration.zero;
  void Function()? _tick;
  bool _isRunning = false;

  @override
  void start(void Function() callback) {
    _tick = callback;
    _isRunning = true;
  }

  @override
  void stop() {
    _tick = null;
    _isRunning = false;
  }

  @override
  void reset() {
    _elapsedTime = Duration.zero;
  }

  void triggerTick() {
    if (_isRunning) {
      _elapsedTime += const Duration(milliseconds: 10);
      _tick?.call();
    }
  }

  void elapseTime(Duration duration) {
    int milliseconds = duration.inMilliseconds;
    int tickCount = milliseconds ~/ 10;

    for (int i=0; i<tickCount; i++) {
      triggerTick();
    }
  }

  @override
  Duration get elapsedTime => _elapsedTime;
}