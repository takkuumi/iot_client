import 'dart:async';
import 'package:iot_client/ffi.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_scan_bluetooth/flutter_scan_bluetooth.dart';
import 'package:iot_client/device.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../futs/hal.dart';

class Bluetooth extends StatefulWidget {
  const Bluetooth({Key? key}) : super(key: key);

  @override
  State<Bluetooth> createState() => _BluetoothState();
}

class _BluetoothState extends State<Bluetooth> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late FlutterScanBluetooth bluetooth = FlutterScanBluetooth();

  List<Device> devices = [];

  @override
  void initState() {
    super.initState();
    // bluetooth.requestPermissions();

    // bluetooth.startScan(pairedDevices: false);

    // bluetooth.devices.listen((device) async {
    //   String name = device.name;
    //   String address = device.address;

    //   Device item = Device(name, address, false);
    //   if (name.startsWith('Mesh') && !devices.contains(item)) {
    //     String meshId = name.substring(5, 9);
    //     List<int> ipData = await getHoldings(meshId, 2247, 4);
    //     String hexIp = ipData.join('.');
    //     item.address += '\r\nIP地址:$hexIp';
    //     setState(() {
    //       devices.add(item);
    //     });
    //   }
    // });

    api.bleScan(typee: 1).then((value) {
      Uint8List? data = value.data;
      if (data != null) {
        debugPrint(String.fromCharCodes(data));
      }
      return api.bleChinfo();
    }).then((value) {
      Uint8List? data = value.data;
      if (data != null) {
        debugPrint(String.fromCharCodes(data));
      }
      return api.bleLecconn2(addr: "DC0D30000FC2", addType: 0);
    }).then((value) {
      Uint8List? data = value.data;
      if (data != null) {
        debugPrint(String.fromCharCodes(data));
      }
      return api.bleLesend(
          index: 0, data: '''// bluetooth.devices.listen((device) async {
    //   String name = device.name;
    //   String address = device.address;
    // });''');
    }).then((value) {
      Uint8List? data = value.data;
      if (data != null) {
        debugPrint(String.fromCharCodes(data));
      }
      return api.bleLesend(
          index: 0, data: '''// bluetooth.devices.listen((device) async {
    //   String name = device.name;
    // });''');
    }).then((value) {
      Uint8List? data = value.data;
      if (data != null) {
        debugPrint(String.fromCharCodes(data));
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
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

  final Widget emptyWidget = const Center(
    child: Text("没有发现设备,请点击扫描按钮进行扫描"),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: devices.isEmpty
                  ? emptyWidget
                  : ListView.builder(
                      itemCount: devices.length,
                      itemBuilder: (BuildContext context, int index) {
                        final Device device = devices[index];
                        return ListTile(
                          title: Text(device.name),
                          subtitle: Text(device.address),
                          onTap: () async {
                            final name = device.name;
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
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.radar),
        tooltip: "扫描",
        onPressed: () async {
          await checkAndAskPermissions();
          try {
            setState(() {
              devices = [];
            });
            await bluetooth.stopScan();

            await bluetooth.startScan(pairedDevices: false);
            showSnackBar("开始扫描");
          } on PlatformException catch (e) {
            debugPrint(e.toString());
          }
        },
      ),
    );
  }
}
