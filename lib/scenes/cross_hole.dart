import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_scan_bluetooth/flutter_scan_bluetooth.dart';
import 'package:iot_client/ffi.dart';
import 'package:iot_client/utils/ble_scan.dart';
import 'package:iot_client/utils/tool.dart';

import '../constants.dart';

class CrossHole extends StatefulWidget {
  const CrossHole({Key? key}) : super(key: key);

  @override
  State<CrossHole> createState() => _CrossHoleState();
}

class Device {
  String name;
  String address;
  bool isChecked;
  Device(this.name, this.address, this.isChecked);

  bool contains(String name) {
    return this.name == name;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Device && other.name == name;
  }

  @override
  int get hashCode => name.hashCode;
}

class _CrossHoleState extends State<CrossHole>
    with BleScan, SingleTickerProviderStateMixin {
  List<Device> devices = [];

  final GlobalKey<ScaffoldMessengerState> key =
      GlobalKey<ScaffoldMessengerState>(debugLabel: 'cross_hole');

  late FlutterScanBluetooth bluetooth = FlutterScanBluetooth();

  @override
  void initState() {
    super.initState();
    bluetooth.requestPermissions();
    bluetooth.devices.listen((device) {
      String name = device.name;
      String address = device.address;

      Device item = Device(name, address, false);
      if (name.startsWith('Mesh') && !devices.contains(item)) {
        setState(() {
          devices.add(item);
        });
      }
    });

    Future.delayed(const Duration(seconds: 5), bluetooth.stopScan);

    bluetooth.startScan(pairedDevices: false);
    // Timer.periodic(timerDuration, (timer) async {
    //   await readDevice(atRead("0200"), false);
    // });
  }

  @override
  void dispose() {
    bluetooth.stopScan();
    bluetooth.close();
    super.dispose();
  }

  Future<void> scan() async {
    await checkAndAskPermissions();
    try {
      if (scanning) {
        await bluetooth.stopScan();
        showSnackBar("扫描停止", key);
        setState(() {
          devices = [];
        });
      } else {
        await bluetooth.startScan(
          pairedDevices: false,
        );
        showSnackBar("正在搜寻蓝牙设备", key);
        setState(() {
          scanning = true;
        });
      }
    } on PlatformException catch (e) {
      showSnackBar(e.toString(), key);
    }
  }

  final BoxShadow boxShadow = BoxShadow(
    color: Colors.grey.withOpacity(0.5),
    spreadRadius: 5,
    blurRadius: 7,
    offset: const Offset(0, 3),
  );

  final Color disableColor = Color.fromRGBO(221, 221, 221, 1);

  Widget createLane1() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          child: Text("横洞指示"),
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        ),
        Container(
          width: 150,
          height: 150,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              width: 2,
              color: Colors.greenAccent,
            ),
            borderRadius: BorderRadius.circular(75),
            boxShadow: [boxShadow],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.double_arrow_sharp,
                  size: 80, color: Colors.greenAccent)
            ],
          ),
        ),
        Container(
          width: 100,
          height: 100,
          alignment: Alignment.center,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: key,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('横洞指示'),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 50),
          child: Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 480,
                  padding: EdgeInsets.symmetric(horizontal: 50),
                  child: Wrap(
                    alignment: WrapAlignment.spaceEvenly,
                    spacing: 40,
                    children: [
                      createLane1(),
                    ],
                  ),
                ),
                Container(
                  width: 480,
                  height: 300.0,
                  padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50),
                  child: devices.isEmpty
                      ? Center(
                          child: Text("没有发现设备,请点击扫描按钮进行扫描"),
                        )
                      : ListView.builder(
                          itemCount: devices.length,
                          itemBuilder: (BuildContext context, int index) {
                            Device device = devices[index];
                            return CheckboxListTile(
                              title: Text(device.name),
                              subtitle: Text(device.address),
                              value: device.isChecked,
                              dense: true,
                              onChanged: null,
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
