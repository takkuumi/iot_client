import 'dart:async';
import 'package:iot_client/ffi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scan_bluetooth/flutter_scan_bluetooth.dart';
import 'package:iot_client/device.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

class Bluetooth extends StatefulWidget {
  const Bluetooth({Key? key}) : super(key: key);

  @override
  State<Bluetooth> createState() => _BluetoothState();
}

class _BluetoothState extends State<Bluetooth> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late FlutterScanBluetooth bluetooth = FlutterScanBluetooth();

  List<Device> devices = [];

  bool isScaning = false;

  String stateMsg = '';

  void mountedState(void Function() fn) {
    if (mounted) {
      setState(fn);
    }
  }

  Future<void> scanBleDevice() async {
    isScaning = true;
    mountedState(() {
      stateMsg = '正在扫描';
    });
    try {
      debugPrint(">>>>>>>>>>>>>>>>>>>>>>>>start scan");
      String responseText = '';

      SerialResponse scanRes = await api.bleScan(typee: 1);

      if (scanRes.data != null) {
        responseText += String.fromCharCodes(scanRes.data!);
      } else {
        mountedState(() {
          stateMsg = '扫描失败，等待下一次重试！';
        });
      }

      // SerialResponse chinfoRes = await api.bleChinfo();

      // if (chinfoRes.data != null) {
      //   responseText += String.fromCharCodes(chinfoRes.data!);
      //   debugPrint(responseText);
      // } else {
      //   mountedState(() {
      //     stateMsg = '查询设备信息失败，请手动点击扫描按扭重试！';
      //   });
      // }

      List<Device> items = parseDevices(responseText);
      for (Device element in items) {
        devices.removeWhere((e) => e.mac == element.mac);

        devices.add(element);
      }
      debugPrint(">>>>>>>>>>>>>>>>>>>>>>>>end scan");
    } catch (_) {
      mountedState(() {
        stateMsg = '扫描失败，请手动点击扫描按扭重试！';
      });
    }
  }

  Future<bool> connect(int index, String mac, int type) async {
    debugPrint("connect to: $mac$type");
    SerialResponse res = await api.bleLecconn(addr: mac, addType: type);

    debugPrint("connect result: ${String.fromCharCodes(res.data!)}");
    SerialResponse res2 = await api.bleChinfo();
    if (res2.data == null) {
      return false;
    }
    String chinfos = String.fromCharCodes(res2.data!);
    debugPrint("chinfo: $chinfos");
    if (chinfos.contains(mac)) {
      bool res = chinfos
          .split(RegExp(r"\r\n"))
          .where((s) => s.startsWith("+CHINFO=") && s.contains(mac))
          .any((element) {
        RegExp m = RegExp("\\+CHINFO=$index,3,(1|0),$mac");
        return m.hasMatch(element);
      });

      return res;
    }
    return false;
  }

  Timer? timer;

  void scanComplete() {
    isScaning = false;
    mountedState(() {
      stateMsg = '';
    });
  }

  void cleanTimer() {
    if (timer != null) {
      timer?.cancel();
      timer = null;
    }
  }

  void setTimer() {
    cleanTimer();
    timer = Timer.periodic(const Duration(seconds: 60), (timer) {
      if (isScaning) {
        return;
      }
      scanBleDevice().whenComplete(scanComplete);
    });
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      scanBleDevice().then((value) {
        setTimer();
      }).whenComplete(scanComplete);
    });
  }

  Future<void> connectDevice(Device device) async {
    bool? result = await showSettingDialog();
    if (result != null && result) {
      await api.bleLedisc(index: device.no);
      // 查找已存在的地址断开连接
      final prefs = await _prefs;
      int? current = prefs.getInt("index");
      if (current != null) {
        await api.bleLedisc(index: current);
      }

      final conn = await connect(device.no, device.mac, device.addressType);

      if (!conn) {
        showSnackBar("连接失败,请重试");
        return;
      }

      showSnackBar("连接成功");
      debugPrint('connection: $conn');

      // 设置连接状态
      devices.where((d) => d.mac == device.mac).first.connected = true;
      mountedState(() {});

      //设置新连接的地址
      await prefs.setString("mesh", '${device.mac}${device.addressType}');
      await prefs.setInt("index", device.no);
    }
  }

  @override
  void dispose() {
    cleanTimer();
    super.dispose();
  }

  Future<bool?> showSettingDialog() {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("提示"),
          content: Text("确认连接？"),
          actions: <Widget>[
            TextButton(
              child: Text("取消"),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: Text("连接"),
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

  final decoration = BoxDecoration(
    borderRadius: BorderRadius.circular(10),
    boxShadow: const [
      BoxShadow(
        color: Color.fromRGBO(221, 221, 221, 1),
        offset: Offset(
          5.0,
          5.0,
        ),
        blurRadius: 10.0,
        spreadRadius: 2.0,
      ), //BoxShadow
      BoxShadow(
        color: Colors.white,
        offset: Offset(0.0, 0.0),
        blurRadius: 0.0,
        spreadRadius: 0.0,
      ), //BoxShadow
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
              child: devices.isEmpty
                  ? emptyWidget
                  : ListView.builder(
                      itemCount: devices.length,
                      itemBuilder: (BuildContext context, int index) {
                        final Device device = devices[index];

                        return Container(
                          padding: EdgeInsets.all(10),
                          decoration: decoration,
                          child: ListTile(
                            leading: Icon(Icons.bluetooth,
                                color: device.connected
                                    ? Colors.blueAccent
                                    : Colors.grey),
                            title: Text('${device.name}'),
                            subtitle: Text('MAC: ${device.mac}'),
                            trailing: Text('RSSI:${device.rssi}'),
                            dense: true,
                            onTap: () {
                              // 清理定时器
                              cleanTimer();
                              connectDevice(device).whenComplete(setTimer);
                            },
                          ),
                        );
                      },
                    ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.black12,
            ),
            height: 40,
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text('状态信息:'), Text(stateMsg)],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.radar),
        tooltip: "扫描",
        onPressed: () {
          if (isScaning) {
            return showSnackBar("正在扫描中,请稍后");
          }
          // 清理定时器
          cleanTimer();
          scanBleDevice().whenComplete(setTimer);
        },
      ),
    );
  }
}
