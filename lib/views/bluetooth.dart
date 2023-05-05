import 'dart:async';
import 'dart:typed_data';
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
    if (isScaning) {
      return;
    }

    if (mounted) {
      mountedState(() {
        isScaning = true;
        stateMsg = '正在扫描';
      });
    }

    try {
      String responseText = '';

      SerialResponse scanRes = await api.bleScan(typee: 1);

      if (scanRes.data != null) {
        responseText += String.fromCharCodes(scanRes.data!);
        debugPrint(responseText);
      } else {
        mountedState(() {
          stateMsg = '扫描失败，等待下一次重试！';
        });
      }

      SerialResponse chinfoRes = await api.bleChinfo();

      if (chinfoRes.data != null) {
        responseText += String.fromCharCodes(chinfoRes.data!);
        debugPrint(responseText);
      } else {
        mountedState(() {
          stateMsg = '查询设备信息失败，请手动点击扫描按扭重试！';
        });
      }

      List<Device> items = parseDevices(responseText);
      for (Device element in items) {
        devices.removeWhere((e) => e.mac == element.mac);

        devices.add(element);
      }
    } catch (_) {
      mountedState(() {
        stateMsg = '扫描失败，请手动点击扫描按扭重试！';
      });
    } finally {
      mountedState(() {
        isScaning = false;
        stateMsg = '';
      });
    }
  }

  Future<bool> connect(String addr) async {
    debugPrint("connect: $addr");
    SerialResponse res = await api.bleLecconnAddr(addr: addr);
    if (res.data == null) {
      return false;
    }

    SerialResponse res2 = await api.bleChinfo();
    if (res2.data == null) {
      return false;
    }
    debugPrint(String.fromCharCodes(res2.data!));
    return true;
  }

  Timer? timer;

  void setTimer() {
    timer = Timer.periodic(timerDuration, (timer) async {
      scanBleDevice();
    });
  }

  Future<void> connectDevice(Device device) async {
    debugPrint("connectDevice ${device.toString()}");
    bool? result = await showSettingDialog();
    if (result != null && result) {
      final connAddr = '${device.mac}${device.addressType}';
      timer?.cancel();
      final conn = await connect(connAddr);
      setTimer();
      debugPrint('connection: $conn');
      final prefs = await _prefs;

      // 查找已存在的地址断开连接
      final int? index = prefs.getInt("index");
      if (index != null) {
        await api.bleLedisc(index: index);
      }

      //设置新连接
      bool saved = await prefs.setString("mesh", connAddr);
      await prefs.setInt("index", device.no);

      if (saved) {
        showSnackBar("设置成功");
      } else {
        showSnackBar("设置失败");
      }
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      scanBleDevice();
      setTimer();
    });
  }

  @override
  void dispose() {
    timer?.cancel();
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
                        return ListTile(
                          title: Text('名 称: ${device.name}'),
                          subtitle: Text('MAC地址: ${device.mac}'),
                          onTap: () async {
                            await connectDevice(device);
                          },
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
          timer?.cancel();
          setTimer();
        },
      ),
    );
  }
}
