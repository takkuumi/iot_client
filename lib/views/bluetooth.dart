import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iot_client/utils/ble_scan.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

class Bluetooth extends StatefulWidget {
  const Bluetooth({Key? key}) : super(key: key);

  @override
  State<Bluetooth> createState() => _BluetoothState();
}

class _BluetoothState extends State<Bluetooth> with BleScan {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  List<String> devices = [];

  @override
  void initState() {
    super.initState();
    initBluetooth();
    scanListen((device) {
      String name = device.name;
      if (name.startsWith('Mesh') && !devices.contains(name)) {
        setState(() {
          devices.add(device.name);
        });
      }
    });

    scanStopped((device) {
      print(device);
      setState(() {
        scanning = false;
      });
    });
  }

  @override
  void dispose() {
    close();
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
            child: devices.isEmpty
                ? Center(
                    child: Text("没有发现设备,请点击扫描按钮进行扫描"),
                  )
                : ListView.builder(
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
                              bool saved = await prefs.setString(
                                  "mesh", name.substring(5, 9));
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
            if (scanning) {
              await bluetooth.stopScan();
              showSnackBar("扫描已停止");
              setState(() {
                devices = [];
              });
            } else {
              await bluetooth.startScan(pairedDevices: false);
              showSnackBar("开始扫描");
              setState(() {
                scanning = true;
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
