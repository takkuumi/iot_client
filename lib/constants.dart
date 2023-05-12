import 'package:flutter/material.dart';

final Duration timerDuration = Duration(seconds: 2);
final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>(debugLabel: 'main_scaffold');

void showSnackBar(String msg, [GlobalKey<ScaffoldMessengerState>? key]) {
  debugPrint(key == null ? 'null' : 'not null');
  rootScaffoldMessengerKey.currentState?.hideCurrentSnackBar();
  if (key != null) {
    key.currentState?.showSnackBar(SnackBar(
      content: Text(msg),
      duration: Duration(seconds: 1),
    ));
    return;
  }
  rootScaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
    content: Text(msg),
    duration: Duration(seconds: 1),
  ));
}
