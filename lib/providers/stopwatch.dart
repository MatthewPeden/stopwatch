import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/timer_interface.dart';

final stopwatchProvider = StateNotifierProvider<StopwatchNotifier, StopwatchState>((ref) {
  return StopwatchNotifier(RealTimer());
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
      laps: laps ?? this.laps,
    );
  }
}

class StopwatchNotifier extends StateNotifier<StopwatchState> {
  final TimerInterface timer;

  StopwatchNotifier(this.timer) : super(StopwatchState(time: '00:00.00', isRunning: false, laps: {}));

  int _intMinutes = 0;
  int _intSeconds = 0;
  int _intCentiseconds = 0;
  Map<String, String> _laps = {};

  void start() {
    timer.start(const Duration(milliseconds: 10), _updateTime);
    state = state.copyWith(isRunning: !state.isRunning);
  }

  void stop() {
    timer.stop();
    state = state.copyWith(isRunning: !state.isRunning);
  }

  void _updateTime() {
    if (_intCentiseconds == 99) {
      _intCentiseconds = 0;
      if (_intSeconds == 59) {
        _intSeconds = 0;
        _intMinutes++;
      } else {
        _intSeconds++;
      }
    } else {
      _intCentiseconds++;
    }

    final stringMinutes = _intMinutes.toString().padLeft(2, '0');
    final stringSeconds = _intSeconds.toString().padLeft(2, '0');
    final stringCentiseconds = _intCentiseconds.toString().padLeft(2, '0');

    state = state.copyWith(time: '$stringMinutes:$stringSeconds.$stringCentiseconds');
  }

  void reset() {
    _intMinutes = 0;
    _intSeconds = 0;
    _intCentiseconds = 0;
    _laps = {};
    state = state.copyWith(time: '00:00.00', laps: {});
  }

  void addLap() {
    _laps['Lap ${state.laps.length + 1}'] = state.time;
    state = state.copyWith(laps: _laps);
  }
}