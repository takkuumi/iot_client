import 'dart:async';

import 'package:flutter/widgets.dart';

mixin AutoTimerMixin<T extends StatefulWidget> on State<T> {
  late Timer? _timer;
  late bool isTimerRunning = false;

  @override
  void initState() {
    super.initState();

    debugPrint("AutoTimerMixin init");
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer?.cancel();
      _timer = null;
    }
    isTimerRunning = false;
    super.dispose();
  }

  void setTimer(int seconds, Future<void> Function() fn) {
    if (!mounted) return;
    if (_timer != null) {
      _timer?.cancel();
      _timer = null;
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      isTimerRunning = true;
      if (mounted && timer.isActive) {
        isTimerRunning = true;
        fn().whenComplete(() {
          isTimerRunning = false;
        });
      }
    });
  }
}
