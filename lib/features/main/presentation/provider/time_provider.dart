import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final timerProvider = StateNotifierProvider<TimerNotifier, int>((ref) => TimerNotifier());

class TimerNotifier extends StateNotifier<int> {
  TimerNotifier() : super(0);

  Timer? _timer;

  void start() {
    reset();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      state++;
    });
  }

  void reset() {
    _timer?.cancel();
    state = 0;
  }

  void stop() {
    _timer?.cancel();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
