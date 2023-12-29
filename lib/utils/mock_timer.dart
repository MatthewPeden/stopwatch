import 'package:mockito/mockito.dart';
import 'package:stopwatch/utils/timer_interface.dart';

class MockTimer extends Mock implements TimerInterface {
  void Function()? _tick;

  @override
  void start(Duration duration, void Function() callback) {
    _tick = callback;
  }

  @override
  void stop() {
    _tick = null;
  }

  void triggerTick() {
    _tick?.call();
  }

  void elapseTime(Duration duration) {
    int milliseconds = duration.inMilliseconds;
    int tickCount = milliseconds ~/ 10;

    for (int i=0; i<tickCount; i++) {
      triggerTick();
    }
  }
}
