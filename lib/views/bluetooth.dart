import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_scan_bluetooth/flutter_scan_bluetooth.dart';
import 'package:iot_client/ffi.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      if (!devices.contains(name)) {
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
                    if (name.startsWith("Mesh")) {
                      final prefs = await _prefs;
                      prefs.setString("mesh", name.substring(5, 9));
                    }

                    // Uint8List r1 = await api.setNdid(id: "0002");
                    // debugPrint(String.fromCharCodes(r1));
                    // Uint8List r2 = await api.ndreset();
                    // debugPrint(String.fromCharCodes(r2));
                    // Uint8List r3 = await api.reboot();
                    // debugPrint(String.fromCharCodes(r3));
                    Uint8List at = await api.getNdid();
                    debugPrint(String.fromCharCodes(at));
                    Uint8List serial = await api.atNdrptTest();
                    final tt = String.fromCharCodes(serial);
                    debugPrint(tt);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.radar),
        onPressed: () async {
          try {
            if (_scanning) {
              await _bluetooth.stopScan();
              debugPrint("scanning stoped");
              setState(() {
                devices = [];
              });
            } else {
              await _bluetooth.startScan(pairedDevices: false);
              debugPrint("scanning started");
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
