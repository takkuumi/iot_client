import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iot_client/ffi.dart';
import 'package:iot_client/utils/ble_scan.dart';
import 'package:iot_client/utils/tool.dart';

import '../constants.dart';

class WindSpeed extends StatefulWidget {
  const WindSpeed({Key? key}) : super(key: key);

  @override
  State<WindSpeed> createState() => _WindSpeedState();
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

class _WindSpeedState extends State<WindSpeed>
    with BleScan, SingleTickerProviderStateMixin {
  List<Device> devices = [];

  final GlobalKey<ScaffoldMessengerState> key =
      GlobalKey<ScaffoldMessengerState>(debugLabel: 'wind_speed');

  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    initBluetooth();

    scanListen((device) {
      String name = device.name;
      String address = device.address;

      Device item = Device(name, address, false);
      if (name.startsWith('Mesh') && !devices.contains(item)) {
        setState(() {
          devices.add(item);
        });
      }
    });

    scanStopped((device) {
      setState(() {
        scanning = false;
      });
    });

    scan();

    animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    animationController.repeat(min: 0.0, max: 1.0);
  }

  Future<void> scan() async {
    await checkAndAskPermissions();
    try {
      if (scanning) {
        await bluetooth.stopScan();
        showSnackBar("scanning stoped", key);
        setState(() {
          devices = [];
        });
      } else {
        await bluetooth.startScan(
          pairedDevices: false,
        );
        showSnackBar("scanning started", key);
        setState(() {
          scanning = true;
        });
      }
    } on PlatformException catch (e) {
      showSnackBar(e.toString(), key);
    }
  }

  String atOpen(String addr) {
    return "0105${addr}0001";
  }

  String atClose(String addr) {
    return "0105${addr}0000";
  }

  Future<void> readAtWindSpeed(String sdata) async {
    List<Device> selected =
        devices.where((element) => element.isChecked).toList();

    if (selected.isEmpty) {
      showSnackBar("未选中任何设备", key);
      return;
    }

    for (final device in selected) {
      String id = getMeshId(device.name);
      Uint8List data = await api.atNdrpt(id: id, data: sdata);
      String resp = String.fromCharCodes(data);
      showSnackBar(resp, key);

      if (resp.contains("OK")) {
        // 设置读取数值
      }
    }
  }

  @override
  void dispose() {
    close();
    super.dispose();
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
          child: Text("风速风向"),
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
              RotationTransition(
                turns: Tween(begin: 0.0, end: 1.0).animate(animationController),
                child: Image.asset(
                  "images/icons/wind speed and direction@2x.png",
                  width: 80,
                  height: 80,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 100,
          height: 100,
          alignment: Alignment.center,
          child: Text("100.0"),
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
          title: const Text('风速风向'),
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
                              onChanged: (bool? value) {
                                setState(() {
                                  device.isChecked = value!;
                                });
                              },
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
