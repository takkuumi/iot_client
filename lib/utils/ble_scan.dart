import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_scan_bluetooth/flutter_scan_bluetooth.dart';
import 'package:permission_handler/permission_handler.dart';

class BleScan {
  bool scanning = false;
  late FlutterScanBluetooth bluetooth;

  void initBluetooth() async {
    bluetooth = FlutterScanBluetooth();
  }

  void scanListen(
    void Function(BluetoothDevice)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    bluetooth.devices.listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  void scanStopped(
    void Function(bool)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    bluetooth.scanStopped.listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  void close() {
    bluetooth.close();
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
}
