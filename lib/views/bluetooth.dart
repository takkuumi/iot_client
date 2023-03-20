import 'dart:async';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_scan_bluetooth/flutter_scan_bluetooth.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

class Bluetooth extends StatefulWidget {
  const Bluetooth({Key? key}) : super(key: key);

  @override
  State<Bluetooth> createState() => _BluetoothState();
}

class _BluetoothState extends State<Bluetooth> {
  bool _scanning = false;
  final FlutterScanBluetooth _bluetooth = FlutterScanBluetooth();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  List<String> devices = [];

  @override
  void initState() {
    super.initState();

    _bluetooth.devices.listen((device) {
      String name = device.name;
      if (name.startsWith('Mesh') && !devices.contains(name)) {
        setState(() {
          devices.add(device.name);
        });
      }
    });
    _bluetooth.scanStopped.listen((device) {
      setState(() {
        _scanning = false;
      });
    });
  }

  Future<bool?> showSettingDialog() {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("提示"),
          content: Text("设置此蓝牙为默认直连吗？"),
          actions: <Widget>[
            TextButton(
              child: Text("取消"),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: Text("确定"),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: devices.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(devices[index]),
                  onTap: () async {
                    final name = devices[index];
                    bool? result = await showSettingDialog();
                    if (result != null && result) {
                      if (name.startsWith("Mesh")) {
                        final prefs = await _prefs;
                        bool saved =
                            await prefs.setString("mesh", name.substring(5, 9));
                        if (saved) {
                          showSnackBar("设置成功");
                        } else {
                          showSnackBar("设置失败");
                        }
                      }
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.radar),
        tooltip: "扫描",
        onPressed: () async {
          await checkAndAskPermissions();
          try {
            if (_scanning) {
              await _bluetooth.stopScan();
              showSnackBar("scanning stoped");
              setState(() {
                devices = [];
              });
            } else {
              await _bluetooth.startScan(pairedDevices: false);
              showSnackBar("scanning started");
              setState(() {
                _scanning = true;
              });
            }
          } on PlatformException catch (e) {
            debugPrint(e.toString());
          }
        },
      ),
    );
  }
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
