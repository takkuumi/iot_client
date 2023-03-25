import 'package:flutter/material.dart';

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>(debugLabel: 'main_scaffold');

void showSnackBar(String msg, [GlobalKey<ScaffoldMessengerState>? key]) {
  debugPrint(key == null ? 'null' : 'not null');
  if (key != null) {
    key.currentState?.showSnackBar(SnackBar(
      content: Text(msg),
    ));
    return;
  }
  rootScaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
    content: Text(msg),
  ));
}
