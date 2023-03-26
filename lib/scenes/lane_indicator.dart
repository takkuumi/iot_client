import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_scan_bluetooth/flutter_scan_bluetooth.dart';
import 'package:iot_client/device.dart';
import 'package:iot_client/ffi.dart';
import 'package:iot_client/utils/at_parse.dart';
import 'package:iot_client/utils/tool.dart';

import '../constants.dart';

class LaneIndicator extends StatefulWidget {
  const LaneIndicator({Key? key}) : super(key: key);

  @override
  State<LaneIndicator> createState() => _LaneIndicatorState();
}

enum Lock { lock, unlock }

class _LaneIndicatorState extends State<LaneIndicator> {
  List<Device> devices = [];

  final GlobalKey<ScaffoldMessengerState> key =
      GlobalKey<ScaffoldMessengerState>(debugLabel: 'lane_indicator');

  late FlutterScanBluetooth bluetooth;

  bool laneIndicator1 = false;
  bool laneIndicator2 = false;

  @override
  void initState() {
    bluetooth = FlutterScanBluetooth();

    // Future.delayed(const Duration(seconds: 5), bluetooth.stopScan);

    bluetooth.startScan(pairedDevices: false);

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
    super.initState();
  }

  @override
  void dispose() {
    bluetooth.stopScan();
    bluetooth.close();
    super.dispose();
  }

  String atRead(String addr) {
    //01 03 00 01 00 01
    return "0101${addr}0001";
  }

  String atOpen(String addr) {
    return "0105${addr}FF00";
  }

  String atClose(String addr) {
    return "0105${addr}0000";
  }

  Future<void> readDevice(
      String sdata, void Function(int) onReadResponse) async {
    List<Device> selected =
        devices.where((element) => element.isChecked).toList();

    if (selected.isEmpty) {
      return;
    }

    for (final device in selected) {
      String id = getMeshId(device.name);
      Uint8List data =
          await Future.sync(() => api.atNdrpt(id: id, data: sdata));
      String resp = String.fromCharCodes(data);
      print(resp);
      int? res = getAtReadResult(resp);
      if (res != null) {
        onReadResponse(res);
      }
    }
  }

  Future<void> writeDevice(String x0200, void Function() onOk) async {
    List<Device> selected =
        devices.where((element) => element.isChecked).toList();

    if (selected.isEmpty) {
      showSnackBar("未选中任何设备", key);
      return;
    }

    for (final device in selected) {
      String id = getMeshId(device.name);
      Uint8List x0200Data =
          await Future.sync(() => api.atNdrpt(id: id, data: x0200));

      String x0200Resp = String.fromCharCodes(x0200Data);
      // showSnackBar(resp, key);
      debugPrint(x0200Resp);
      bool isOk = getAtOk(x0200Resp);
      if (isOk) {
        onOk();
      }
    }
  }

  final BoxShadow boxShadow = BoxShadow(
    color: Colors.grey.withOpacity(0.5),
    spreadRadius: 5,
    blurRadius: 7,
    offset: const Offset(0, 3),
  );

  final Widget verticalLine = Container(
    height: 20,
    child: VerticalDivider(
      thickness: 2,
      color: Color.fromRGBO(192, 192, 192, 1),
    ),
  );

  final Color disableColor = Color.fromRGBO(221, 221, 221, 1);

  Widget createLane1() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          child: Text("车道一"),
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        ),
        Container(
          width: 100,
          height: 100,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              width: 2,
              color: laneIndicator1 ? Colors.greenAccent : Colors.redAccent,
            ),
            borderRadius: BorderRadius.circular(50),
            boxShadow: [boxShadow],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                laneIndicator1 ? Icons.arrow_upward : Icons.clear,
                size: 60,
                color: laneIndicator1 ? Colors.greenAccent : Colors.redAccent,
              )
            ],
          ),
        ),
        verticalLine,
        Container(
          width: 100,
          height: 100,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              width: 2,
              color: laneIndicator2 ? Colors.greenAccent : Colors.redAccent,
            ),
            borderRadius: BorderRadius.circular(50),
            boxShadow: [boxShadow],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                laneIndicator2 ? Icons.arrow_upward : Icons.clear,
                size: 60,
                color: laneIndicator2 ? Colors.greenAccent : Colors.redAccent,
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 20),
          child: ElevatedButton(
            onPressed: () async {
              await writeDevice(atOpen("0200"), () {});
              sleep(Duration(seconds: 1));
              await writeDevice(atClose("0201"), () {});

              setState(() {
                laneIndicator1 = true;
              });
              sleep(Duration(seconds: 1));

              await writeDevice(atOpen("0202"), () {});
              sleep(Duration(seconds: 1));
              await writeDevice(atClose("0203"), () {});

              setState(() {
                laneIndicator2 = false;
              });
            },
            child: Text("正行"),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 5),
          child: ElevatedButton(
            onPressed: () async {
              await writeDevice(atClose("0200"), () {});
              sleep(Duration(seconds: 1));
              await writeDevice(atOpen("0201"), () {});

              setState(() {
                laneIndicator1 = false;
              });
              sleep(Duration(seconds: 1));

              await writeDevice(atClose("0202"), () {});
              sleep(Duration(seconds: 1));
              await writeDevice(atOpen("0203"), () {});

              setState(() {
                laneIndicator2 = true;
              });
            },
            child: Text("逆行"),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 5),
          child: ElevatedButton(
            onPressed: () async {
              await writeDevice(atClose("0200"), () {});
              sleep(Duration(seconds: 1));
              await writeDevice(atClose("0201"), () {});

              setState(() {
                laneIndicator1 = false;
              });
              sleep(Duration(seconds: 1));

              await writeDevice(atClose("0202"), () {});
              sleep(Duration(seconds: 1));
              await writeDevice(atClose("0203"), () {});

              setState(() {
                laneIndicator2 = false;
              });
            },
            child: Text("全关"),
          ),
        ),
      ],
    );
  }

  Widget createLane2() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          child: Text("车道二"),
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        ),
        Container(
          width: 100,
          height: 100,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              width: 2,
              color: disableColor,
            ),
            borderRadius: BorderRadius.circular(50),
            boxShadow: [boxShadow],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.clear,
                size: 60,
                color: disableColor,
              )
            ],
          ),
        ),
        verticalLine,
        Container(
          width: 100,
          height: 100,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              width: 2,
              color: disableColor,
            ),
            borderRadius: BorderRadius.circular(50),
            boxShadow: [boxShadow],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.clear,
                size: 60,
                color: disableColor,
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 20),
          child: ElevatedButton(
            // onPressed: () => writeDevice(atOpen("0200"), true),
            onPressed: null,
            child: Text("打开"),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 5),
          child: ElevatedButton(
            // onPressed: () => writeDevice(atClose("0200"), false),
            onPressed: null,
            child: Text("关闭"),
          ),
        ),
      ],
    );
  }

  Widget createLane3() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          child: Text("车道二"),
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        ),
        Container(
          width: 100,
          height: 100,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              width: 2,
              color: disableColor,
            ),
            borderRadius: BorderRadius.circular(50),
            boxShadow: [boxShadow],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.clear,
                size: 60,
                color: disableColor,
              )
            ],
          ),
        ),
        verticalLine,
        Container(
          width: 100,
          height: 100,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              width: 2,
              color: disableColor,
            ),
            borderRadius: BorderRadius.circular(50),
            boxShadow: [boxShadow],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.clear,
                size: 60,
                color: disableColor,
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 20),
          child: ElevatedButton(
            // onPressed: () => writeDevice(atOpen("0200"), true),
            onPressed: null,
            child: Text("打开"),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 5),
          child: ElevatedButton(
            // onPressed: () => writeDevice(atClose("0200"), false),
            onPressed: null,
            child: Text("关闭"),
          ),
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
          title: const Text('车道指示器'),
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
                      createLane2(),
                      createLane2(),
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
              showSnackBar("开始扫描", key);
            } on PlatformException catch (e) {
              debugPrint(e.toString());
            }
          },
        ),
      ),
    );
  }
}
