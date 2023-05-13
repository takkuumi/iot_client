import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:iot_client/ffi.dart';
import 'package:flutter/material.dart';
import 'package:iot_client/model/device.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../futs/ble.dart';

class Bluetooth extends StatefulWidget {
  const Bluetooth({Key? key}) : super(key: key);

  @override
  State<Bluetooth> createState() => _BluetoothState();
}

class _BluetoothState extends State<Bluetooth> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  List<Device> devices = [];

  bool isScaning = false;

  String stateMsg = '';

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Future<void> scanBleDevice() async {
    isScaning = true;
    // EasyLoading.show(status: '扫描中...');
    setState(() {
      stateMsg = '正在扫描';
    });
    try {
      debugPrint("操作 蓝牙 扫描蓝牙");

      SerialResponse resp = await api.bleScan(typee: 1);

      Uint8List? data = resp.data;

      if (data == null) {
        setState(() {
          stateMsg = '未发现设备！';
        });
        return;
      }

      String responseText = String.fromCharCodes(data);
      debugPrint("操作 蓝牙 扫描完成");

      final SharedPreferences prefs = await _prefs;
      prefs.setString("bluetooths", responseText);

      List<Device> items = parseDevices(responseText);
      for (Device element in items) {
        devices.removeWhere((e) => e.mac == element.mac);

        devices.add(element);
      }

      await tagConnectedDevice(callback: () {
        setState(() {
          stateMsg = '查询设备信息失败，请手动点击扫描按扭重试！';
        });
      });
    } catch (_) {
      setState(() {
        stateMsg = '扫描失败，请手动点击扫描按扭重试！';
      });
    }
    // EasyLoading.dismiss();
  }

  Future<bool> connect(int index, String mac, int type) async {
    debugPrint("连接蓝牙至 $mac$type");
    SerialResponse res = await api.bleLecconn(addr: mac, addType: type);
    if (res.data != null) {
      debugPrint("连接结果 ${String.fromCharCodes(res.data!)} end");
    }
    bool res1 = await checkConnection(mac);
    return res1;
  }

  Future<void> tagConnectedDevice({VoidCallback? callback}) async {
    SerialResponse resp = await api.bleChinfo();

    Uint8List? data = resp.data;
    if (data == null) {
      if (callback != null) {
        callback();
      }
      return;
    }
    final SharedPreferences prefs = await _prefs;
    String respText = String.fromCharCodes(data);
    for (Device device in devices) {
      bool res = checkConnectionSync(respText, device.mac);
      device.connected = res;
      if (res) {
        prefs.setInt("no", device.no);
        prefs.setString("mac", device.mac);
      }
    }
    setState(() {});
  }

  void scanComplete() {
    isScaning = false;
    setState(() {
      stateMsg = '';
    });
  }

  @override
  void initState() {
    // EasyLoading.dismiss();
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      debugPrint("初始化...");
      final SharedPreferences prefs = await _prefs;
      String? responseText = prefs.getString("bluetooths");

      int? no = prefs.getInt("no");

      if (responseText != null) {
        List<Device> items = parseDevices(responseText);
        for (Device element in items) {
          if (no != null && element.no == no) {
            element.no = no;
          }
          devices.removeWhere((e) => e.mac == element.mac);

          devices.add(element);
        }
      }
      setState(() {});
      await tagConnectedDevice();
      debugPrint("初始化完成");
      await scanBleDevice().whenComplete(scanComplete);
    });
  }

  Future<void> connectDevice(Device device) async {
    bool? result = await showSettingDialog();
    if (result != null) {
      if (result) {
        await api.bleLedisc(index: device.no);
        // 查找已存在的地址断开连接
        final prefs = await _prefs;
        int? current = prefs.getInt("no");
        if (current != null) {
          await api.bleLedisc(index: current);
        }

        final conn = await connect(device.no, device.mac, device.addressType);

        if (!conn) {
          showSnackBar("连接失败,请重试");
          debugPrint("连接失败");
          return;
        }

        showSnackBar("连接成功");
        debugPrint("连接成功");

        // 设置连接状态
        devices.where((d) => d.mac == device.mac).first.connected = true;
        setState(() {});

        //设置新连接的地址
        await prefs.setInt("addressType", device.addressType);
        await prefs.setString("mac", device.mac);
        await prefs.setInt("no", device.no);
      } else {
        await api.bleLedisc(index: device.no);
        // 查找已存在的地址断开连接
        final prefs = await _prefs;
        int? current = prefs.getInt("no");
        if (current != null) {
          await api.bleLedisc(index: current);
        }
        await tagConnectedDevice();
        showSnackBar("已断开连接");
      }
    }
  }

  @override
  void dispose() {
    // EasyLoading.dismiss();
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
              onPressed: () => Navigator.of(context).pop(null),
            ),
            TextButton(
              child: Text("断开"),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
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
                          margin: EdgeInsets.only(bottom: 15),
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: decoration,
                          child: ListTile(
                            leading: device.connected
                                ? Icon(Symbols.bluetooth_connected,
                                    color: Colors.blueAccent)
                                : Icon(Symbols.bluetooth, color: Colors.grey),
                            title: Text(
                              '${device.name}',
                              style: TextStyle(fontSize: 16),
                            ),
                            subtitle: Text('MAC: ${device.mac}'),
                            trailing: Text('RSSI:${device.rssi}'),
                            dense: true,
                            onTap: () {
                              // 清理定时器
                              connectDevice(device);
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
        child: Icon(Symbols.bluetooth_searching),
        tooltip: "扫描",
        onPressed: () {
          if (isScaning) {
            return showSnackBar("正在扫描中,请稍后");
          }
          scanBleDevice().whenComplete(scanComplete);
        },
      ),
    );
  }
}
