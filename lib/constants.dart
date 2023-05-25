import 'package:flutter/material.dart';

const Duration timerDuration = Duration(seconds: 2);
final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>(debugLabel: 'main_scaffold');

void showSnackBar(String msg, [GlobalKey<ScaffoldMessengerState>? key]) {
  rootScaffoldMessengerKey.currentState?.hideCurrentSnackBar();
  if (key != null) {
    key.currentState?.showSnackBar(SnackBar(
      content: Text(msg),
      duration: const Duration(seconds: 1),
      backgroundColor: Colors.blueGrey,
    ));
    return;
  }
  rootScaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
    content: Text(msg),
    duration: const Duration(seconds: 1),
  ));
}
