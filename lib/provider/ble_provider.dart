import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iot_client/ffi.io.dart';
import 'package:iot_client/model/chinfo.dart';
import 'package:iot_client/model/device.dart';

final currentConnectionProvider = StateProvider<Device?>((ref) {
  return null;
});

class Connection extends StateNotifier<Device?> {
  Connection(super.state);

  void connectTo(Device device) {
    state = device;
  }

  void disconnect() {
    state = null;
  }
}

final connectionedProvider =
    StateNotifierProvider<Connection, Device?>((ref) => Connection(null));

final chinfoFutureProvider = FutureProvider<List<Chinfo>?>((ref) async {
  SerialResponse response = await api.bleChinfo();
  Uint8List? data = response.data;
  if (data == null) return null;
  String responseText = String.fromCharCodes(data);
  List<Chinfo> chinfos = parseChinfos(responseText);
  ref.read(bleDevicesProvider).updateStat(chinfos);
  bool empty = chinfos.any((e) => e.state == 3);
  if (!empty) {
    ref.read(connectionedProvider.notifier).disconnect();
  }
  return chinfos;
});

class BleDevices extends ChangeNotifier {
  final devices = <Device>[];

  void addDevice(Device device) {
    devices.removeWhere((e) => e.mac == device.mac);
    devices.add(device);
    notifyListeners();
  }

  void updateStat(List<Chinfo> chinfos) {
    for (final device in devices) {
      device.connected =
          chinfos.any((e) => e.mac == device.mac && e.state == 3);
    }
    notifyListeners();
  }
}

final bleDevicesProvider = ChangeNotifierProvider<BleDevices>((ref) {
  return BleDevices();
});

final deviceFutureProvider = FutureProvider<List<Device>?>((ref) async {
  SerialResponse response = await api.bleScan(typee: 1);
  Uint8List? data = response.data;
  if (data == null) return null;
  String responseText = String.fromCharCodes(data);
  debugPrint(responseText);
  List<Device> devices = parseDevices(responseText);
  for (final device in devices) {
    ref.read(bleDevicesProvider).addDevice(device);
  }
  return devices;
});
