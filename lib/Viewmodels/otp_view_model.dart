import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final otpViewModelProvider =
    StateNotifierProvider<OTPViewModel, int>((ref) => OTPViewModel());

class OTPViewModel extends StateNotifier<int> {
  OTPViewModel() : super(25) {
    startTimer();
  }

  Timer? _timer;

  void startTimer() {
    _timer?.cancel(); // Cancel if already running
    state = 25;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state == 0) {
        timer.cancel();
      } else {
        state = state - 1;
      }
    });
  }

  void resetTimer() {
    startTimer();
  }

  void disposeTimer() {
    _timer?.cancel();
  }
}
