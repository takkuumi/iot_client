import 'package:flutter/material.dart';

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>(debugLabel: 'main_scaffold');

void showSnackBar(String msg) {
  rootScaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
    content: Text(msg),
  ));
}
