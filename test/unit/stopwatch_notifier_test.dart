import 'package:flutter_test/flutter_test.dart';
import 'package:stopwatch/providers/stopwatch.dart';
import 'package:stopwatch/utils/timer_interface.dart';

void main() {
  group('Stopwatch Notifier Tests', () {
    late StopwatchNotifier stopwatchNotifier;
    late MockTimer mockTimer;

    setUp(() {
      mockTimer = MockTimer();
      stopwatchNotifier = StopwatchNotifier(mockTimer);
    });

    test('Initial state is correct', () {
      expect(stopwatchNotifier.state.time, '00:00.00');
      expect(stopwatchNotifier.state.isRunning, false);
      expect(stopwatchNotifier.state.laps.isEmpty, true);
    });

    test('Start method successfully starts stopwatch', () {
      stopwatchNotifier.start();

      expect(stopwatchNotifier.state.isRunning, true);
    });

    test('Update time method successfully updates stopwatch time', () {
      stopwatchNotifier.start();
      mockTimer.elapseTime(const Duration(seconds: 1));
      stopwatchNotifier.stop();

      expect(stopwatchNotifier.state.time, equals('00:01.00'));
    });

    test('Stop method successfully stops stopwatch', () {
      stopwatchNotifier.start();
      mockTimer.elapseTime(const Duration(seconds: 1));
      stopwatchNotifier.stop();

      expect(stopwatchNotifier.state.isRunning, false);
    });

    test('Reset method successfully resets stopwatch and laps', () {
      stopwatchNotifier.start();
      mockTimer.elapseTime(const Duration(seconds: 1));
      stopwatchNotifier.stop();
      stopwatchNotifier.reset();

      expect(stopwatchNotifier.state.isRunning, false);
      expect(stopwatchNotifier.state.time, '00:00.00');
      expect(stopwatchNotifier.state.laps.isEmpty, true);
    });

    test('Add lap method successfully adds a lap', () {
      stopwatchNotifier.start();

      mockTimer.elapseTime(const Duration(seconds: 1));
      stopwatchNotifier.addLap();
      
      stopwatchNotifier.stop();

      expect(stopwatchNotifier.state.laps.isNotEmpty, true);
      expect(stopwatchNotifier.state.laps.length, 1);
    });

    test('Multiple add lap method calls successfully add multiple laps', () {
      stopwatchNotifier.start();
      
      mockTimer.elapseTime(const Duration(milliseconds: 500));
      stopwatchNotifier.addLap();

      mockTimer.elapseTime(const Duration(milliseconds: 500));
      stopwatchNotifier.addLap();

      mockTimer.elapseTime(const Duration(milliseconds: 500));
      stopwatchNotifier.addLap();
      
      stopwatchNotifier.stop();

      expect(stopwatchNotifier.state.laps.length, 3);
    });

    test('Stopwatch continues correctly after stop and start', () {
      stopwatchNotifier.start();
      mockTimer.elapseTime(const Duration(seconds: 1));
      stopwatchNotifier.stop();

      stopwatchNotifier.start();
      mockTimer.elapseTime(const Duration(seconds: 1));
      stopwatchNotifier.stop();

      expect(stopwatchNotifier.state.time, equals('00:02.00'));
    });

    test('Stopwatch time format is correct', () {
      stopwatchNotifier.start();
      mockTimer.elapseTime(const Duration(seconds: 5, milliseconds: 50));
      stopwatchNotifier.stop();

      expect(stopwatchNotifier.state.time, matches(RegExp(r'\d{2}:\d{2}\.\d{2}')));
    });

    test('Stopwatch time is correct when switching to new time units', () {
      stopwatchNotifier.start();
      mockTimer.elapseTime(const Duration(seconds: 1, milliseconds: 10));
      stopwatchNotifier.stop();

      expect(stopwatchNotifier.state.time, '00:01.01');

      stopwatchNotifier.reset();

      stopwatchNotifier.start();
      mockTimer.elapseTime(const Duration(minutes: 1, milliseconds: 10));
      stopwatchNotifier.stop();

      expect(stopwatchNotifier.state.time, '01:00.01');
    });

    test('Time format for laps is correct', () {
      stopwatchNotifier.start();

      mockTimer.elapseTime(const Duration(milliseconds: 500));
      stopwatchNotifier.addLap();

      String firstLapTime = stopwatchNotifier.state.time;

      mockTimer.elapseTime(const Duration(milliseconds: 500));
      stopwatchNotifier.addLap();

      String secondLapTime = stopwatchNotifier.state.time;

      stopwatchNotifier.stop();

      expect(firstLapTime, matches(RegExp(r'\d{2}:\d{2}\.\d{2}')));
      expect(secondLapTime, matches(RegExp(r'\d{2}:\d{2}\.\d{2}')));
    });

    test('Order for laps is correct', () {
      stopwatchNotifier.start();

      mockTimer.elapseTime(const Duration(milliseconds: 500));
      stopwatchNotifier.addLap();

      String firstLapTime = stopwatchNotifier.state.time;

      mockTimer.elapseTime(const Duration(milliseconds: 500));
      stopwatchNotifier.addLap();

      String secondLapTime = stopwatchNotifier.state.time;

      stopwatchNotifier.stop();
      
      expect(firstLapTime.compareTo(secondLapTime) < 0, true);

      List<String> lapTimes = stopwatchNotifier.state.laps.values.toList();

      expect(lapTimes[0], firstLapTime);
      expect(lapTimes[1], secondLapTime);
    });
    
    test('Lap time is correct', () {
      stopwatchNotifier.start();
      mockTimer.elapseTime(const Duration(seconds: 1, milliseconds: 300));
      stopwatchNotifier.addLap();
      stopwatchNotifier.stop();

      expect(stopwatchNotifier.state.laps.values.first, '00:01.30');
    });

    test('Lap time is correct after stopping and starting stopwatch', () {
      stopwatchNotifier.start();
      mockTimer.elapseTime(const Duration(milliseconds:300));
      stopwatchNotifier.stop();

      mockTimer.elapseTime(const Duration(seconds: 1));

      stopwatchNotifier.start();
      mockTimer.elapseTime(const Duration(milliseconds:300));
      stopwatchNotifier.addLap();
      stopwatchNotifier.stop();

      expect(stopwatchNotifier.state.laps.values.first, '00:00.60');
    });
  });
}
