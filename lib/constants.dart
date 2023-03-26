import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

final Duration timerDuration = Duration(seconds: 10);
final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>(debugLabel: 'main_scaffold');

void showSnackBar(String msg, [GlobalKey<ScaffoldMessengerState>? key]) {
  debugPrint(key == null ? 'null' : 'not null');
  rootScaffoldMessengerKey.currentState?.hideCurrentSnackBar();
  if (key != null) {
    key.currentState?.showSnackBar(SnackBar(
      content: Text(msg),
      duration: Duration(milliseconds: 260),
    ));
    return;
  }
  rootScaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
    content: Text(msg),
    duration: Duration(milliseconds: 260),
  ));
}

Future<void> checkAndAskPermissions() async {
  if (defaultTargetPlatform == TargetPlatform.android) {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    if (androidInfo.version.sdkInt < 31) {
      // location
      await Permission.locationWhenInUse.request();
      await Permission.locationAlways.request();

      // bluetooth
      await Permission.bluetooth.request();
      await Permission.bluetoothScan.request();
      await Permission.bluetoothConnect.request();
    } else {
      // bluetooth for Android 12 and up
      await Permission.bluetoothScan.request();
      await Permission.bluetoothConnect.request();
    }
  } else {
    // bluetooth for iOS 13 and up
    await Permission.bluetooth.request();
  }
}
