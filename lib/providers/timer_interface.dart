import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/timer_interface.dart';

final timerInterfaceProvider = Provider<TimerInterface>((ref) {
  return RealTimer();
});
