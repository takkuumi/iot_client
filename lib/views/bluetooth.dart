import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iot_client/ffi.dart';
import 'package:flutter/material.dart';
import 'package:iot_client/model/chinfo.dart';
import 'package:iot_client/model/device.dart';
import 'package:iot_client/provider/app_provider.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

class Bluetooth extends StatefulHookConsumerWidget {
  const Bluetooth({Key? key}) : super(key: key);

  @override
  BluetoothState createState() => BluetoothState();
}

class BluetoothState extends ConsumerState<Bluetooth> {
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
    setState(() {
      stateMsg = '正在扫描';
    });
    try {
      SerialResponse resp = await api.bleScan(typee: 1);

      Uint8List? data = resp.data;

      if (data == null) {
        setState(() {
          stateMsg = '未发现设备！';
        });
        return;
      }

      String responseText = String.fromCharCodes(data);

      final SharedPreferences prefs = await _prefs;

      prefs.setString("bluetooths", responseText);

      List<Device> items = parseDevices(responseText);
      for (Device element in items) {
        devices.removeWhere((e) => e.mac == element.mac);

        devices.add(element);
      }
    } catch (_) {
      setState(() {
        stateMsg = '扫描失败，请手动点击扫描按扭重试！';
      });
    }
  }

  void scanComplete() {
    isScaning = false;
    setState(() {
      stateMsg = '';
    });
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final SharedPreferences prefs = await _prefs;

      ref.watch(appConnectedProvider.notifier).addListener((chinfos) {
        debugPrint("监听触发");
        refreshAlreadyState(prefs, chinfos);
      });

      String? responseText = prefs.getString("bluetooths");

      if (responseText != null) {
        List<Device> items = parseDevices(responseText);
        if (items.isNotEmpty) {
          devices.clear();
        }
        for (Device element in items) {
          devices.add(element);
        }

        List<Chinfo> chinfos = ref.read(appConnectedProvider);
        refreshAlreadyState(prefs, chinfos);
      }

      Future.delayed(const Duration(milliseconds: 300), () async {
        if (devices.isEmpty) {
          await scanBleDevice().whenComplete(scanComplete);

          refreshStat();
        }
      });
    });
  }

  void refreshAlreadyState(SharedPreferences prefs, List<Chinfo> chinfos) {
    // int? no2;
    for (Device device in devices) {
      bool hasConnected =
          chinfos.any((e) => e.mac == device.mac && e.state == 3);
      device.connected = hasConnected;
      if (hasConnected) {
        //  no2 = device.no;
        prefs.setInt("no", device.no);
        prefs.setString("mac", device.mac);
        prefs.setString("blename", device.name);
        prefs.setInt("addressType", device.addressType);
      }
    }
    setState(() {});
  }

  Future<void> refreshStat() async {
    SerialResponse response = await api.bleChinfo();
    Uint8List? data = response.data;
    if (data == null) return;
    String responseText = String.fromCharCodes(data);

    List<Chinfo> chinfos = parseChinfos(responseText);

    ref.read(appConnectedProvider.notifier).changeDevice(chinfos);
  }

  Future<void> connectDevice(Device device) async {
    bool? result = await showSettingDialog();
    if (result != null) {
      final prefs = await _prefs;
      if (result) {
        if (device.connected) {
          return EasyLoading.showError("当前设备已连接");
        }

        final conn =
            await api.bleLecconn(addr: device.mac, addType: device.addressType);

        if (!conn) {
          return showSnackBar("连接失败");
        }

        showSnackBar("连接成功");

        // 设置连接状态
        devices.where((d) => d.mac == device.mac).first.connected = true;
        setState(() {});
        //设置新连接的地址
        await prefs.setInt("addressType", device.addressType);
        await prefs.setString("mac", device.mac);
        await prefs.setString("blename", device.name);
        await prefs.setInt("no", device.no);
      } else {
        if (!device.connected) {
          return EasyLoading.showError("当前设备已断开连接");
        }
        await api.bleLedisc(index: device.no);
        await refreshStat();
        showSnackBar("已断开连接");
      }
    }
  }

  @override
  void dispose() {
    isScaning = false;
    EasyLoading.dismiss();
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
                              if (isScaning) {
                                EasyLoading.showInfo('当前正在扫描设备,请等待扫描完成...');
                                return;
                              }
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
