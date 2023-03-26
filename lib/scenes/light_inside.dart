import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_scan_bluetooth/flutter_scan_bluetooth.dart';
import 'package:iot_client/device.dart';
import 'package:iot_client/ffi.dart';
import 'package:iot_client/utils/at_parse.dart';
import 'package:iot_client/utils/tool.dart';

import '../constants.dart';

class LightInside extends StatefulWidget {
  const LightInside({Key? key}) : super(key: key);

  @override
  State<LightInside> createState() => _LightInsideState();
}

class _LightInsideState extends State<LightInside>
    with SingleTickerProviderStateMixin {
  List<Device> devices = [];

  final GlobalKey<ScaffoldMessengerState> key =
      GlobalKey<ScaffoldMessengerState>(debugLabel: 'light_inside');

  late FlutterScanBluetooth bluetooth;

  Timer? timer;
  late String windSpeed = '';

  void getAtWindSpeed(String resp) {
    // 0x1000
    // 亮度值 报警值 故障码
    setState(() {
      windSpeed = "亮度值:--\r\n报警值:--\r\n故障码:--";
    });
  }

  void startTimer() {
    timer = Timer.periodic(timerDuration, (timer) async {
      await readDevice("010303E80004", getAtWindSpeed);
    });
  }

  @override
  void initState() {
    bluetooth = FlutterScanBluetooth();

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

    readDevice("010303F60004", getAtWindSpeed);
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    bluetooth?.stopScan();
    bluetooth?.close();
    super.dispose();
  }

  Future<void> readAtLightInside(String sdata) async {
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

  String atRead(String addr) {
    //01 03 00 01 00 01
    return "0101${addr}0001";
  }

  Future<void> readDevice(
      String sdata, void Function(String resp) callback) async {
    List<Device> selected =
        devices.where((element) => element.isChecked).toList();

    if (selected.isEmpty) {
      return;
    }

    for (final device in selected) {
      String id = getMeshId(device.name);
      Uint8List data = await api.atNdrpt(id: id, data: sdata);
      print(data);
      String resp = String.fromCharCodes(data);
      if (getAtOk(resp)) {
        callback(resp);
      }
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
          child: Text("洞内照度"),
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
              Image.asset(
                "images/icons/lght intensity detection@2x.png",
                width: 80,
                height: 80,
              ),
            ],
          ),
        ),
        Container(
          width: 100,
          height: 100,
          alignment: Alignment.center,
          child: Text(windSpeed),
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
          title: const Text('洞内照度'),
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
