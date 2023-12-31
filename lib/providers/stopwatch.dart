import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stopwatch/providers/timer_interface.dart';

import '../utils/timer_interface.dart';

final stopwatchProvider = StateNotifierProvider<StopwatchNotifier, StopwatchState>((ref) {
  final timer = ref.watch(timerInterfaceProvider);
  return StopwatchNotifier(timer);
});

class StopwatchState {
  final String time;
  final bool isRunning;
  final Map<String, String> laps;

  StopwatchState({
    required this.time,
    required this.isRunning,
    required this.laps
  });

  StopwatchState copyWith({String? time, bool? isRunning, Map<String, String>? laps}) {
    return StopwatchState(
      time: time ?? this.time,
      isRunning: isRunning ?? this.isRunning,
      laps: laps ?? this.laps
    );
  }
}

class StopwatchNotifier extends StateNotifier<StopwatchState> {
  final TimerInterface timer;
  Map<String, String> _laps = {};

  StopwatchNotifier(this.timer) : super(StopwatchState(time: '00:00.00', isRunning: false, laps: {}));

  void start() {
    timer.start(_updateTime);
    state = state.copyWith(isRunning: true);
  }

  void stop() {
    timer.stop();
    state = state.copyWith(isRunning: false);
  }

  void reset() {
    timer.reset();
    _laps = {};
    state = state.copyWith(time: '00:00.00', laps: {});
  }

  void _updateTime() {
    final elapsedTime = timer.elapsedTime;
    final stringMinutes = elapsedTime.inMinutes.toString().padLeft(2, '0');
    final stringSeconds = (elapsedTime.inSeconds % 60).toString().padLeft(2, '0');
    final stringCentiseconds = ((elapsedTime.inMilliseconds % 1000) ~/ 10).toString().padLeft(2, '0');

    state = state.copyWith(time: '$stringMinutes:$stringSeconds.$stringCentiseconds');
  }

  void addLap() {
    _laps['Lap ${state.laps.length + 1}'] = state.time;
    state = state.copyWith(laps: _laps);
  }
}