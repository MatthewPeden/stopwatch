import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final stopwatchProvider = StateNotifierProvider<StopwatchNotifier, StopwatchState>((ref) {
  return StopwatchNotifier();
});

class StopwatchState {
  final String time;
  final bool isRunning;

  StopwatchState({required this.time, required this.isRunning});
}

class StopwatchNotifier extends StateNotifier<StopwatchState> {
  StopwatchNotifier() : super(StopwatchState(time: '00:00.00', isRunning: false));

  int _intMinutes = 0;
  int _intSeconds = 0;
  int _intCentiseconds = 0;
  Timer? _timer;

  void startStop() {
    if (state.isRunning) {
      _timer?.cancel();
    } else {
      _timer = Timer.periodic(const Duration(milliseconds: 10), (_) => _updateTime());
    }
    state = StopwatchState(time: state.time, isRunning: !state.isRunning);
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

    _updateStopwatch();
  }

  void reset() {
    _intMinutes = 0;
    _intSeconds = 0;
    _intCentiseconds = 0;
    _updateStopwatch();
  }

  void _updateStopwatch() {
    final stringMinutes = _intMinutes.toString().padLeft(2, '0');
    final stringSeconds = _intSeconds.toString().padLeft(2, '0');
    final stringCentiseconds = _intCentiseconds.toString().padLeft(2, '0');
    state = StopwatchState(time: '$stringMinutes:$stringSeconds.$stringCentiseconds', isRunning: state.isRunning);
  }
}