import 'dart:async';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iot_client/ffi.io.dart';
import 'package:flutter/material.dart';
import 'package:iot_client/model/device.dart';
import 'package:iot_client/provider/app_provider.dart';
import 'package:iot_client/provider/ble_provider.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../constants.dart';

class Bluetooth extends StatefulHookConsumerWidget {
  const Bluetooth({Key? key}) : super(key: key);

  @override
  BluetoothState createState() => BluetoothState();
}

class BluetoothState extends ConsumerState<Bluetooth> {
  String stateMsg = '';

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(mutexLockProvider.notifier).lock();
      ref.refresh(deviceFutureProvider.future).whenComplete(() {
        ref.read(mutexLockProvider.notifier).unlock();
      });
    });
  }

  Future<void> connectDevice(Device device) async {
    bool? result = await showSettingDialog();
    if (result != null) {
      debugPrint("connectDevice: $result");
      ref.read(mutexLockProvider.notifier).lock();

      if (result) {
        if (device.connected) {
          ref.read(mutexLockProvider.notifier).unlock();
          return EasyLoading.showError("当前设备已连接");
        }

        final conn =
            await api.bleLecconn(addr: device.mac, addType: device.addressType);

        if (!conn) {
          ref.read(mutexLockProvider.notifier).unlock();
          return showSnackBar("连接失败");
        }

        showSnackBar("连接成功");
      } else {
        if (!device.connected) {
          ref.read(mutexLockProvider.notifier).unlock();
          return EasyLoading.showError("当前设备已断开连接");
        }
        try {
          await api.bleLedisc(index: device.no);
        } catch (e) {
          debugPrint("bleLedisc error: $e");
        }

        showSnackBar("已断开连接");
      }
      ref.read(mutexLockProvider.notifier).unlock();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    ref.watch(mutexLockProvider.notifier).unlock();
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
    final devices = ref.watch(bleDevicesProvider).devices;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
              child: ListView.builder(
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
          ref.read(mutexLockProvider.notifier).lock();
          ref.refresh(deviceFutureProvider.future).whenComplete(() {
            ref.read(mutexLockProvider.notifier).unlock();
          });
        },
      ),
    );
  }
}
