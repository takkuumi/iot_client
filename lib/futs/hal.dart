import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:iot_client/ffi.dart';
import 'package:iot_client/futs/ble.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<List<int>> getHoldings(int reg, int count) async {
  List<int> res = List<int>.empty(growable: true);

  final SharedPreferences prefs = await SharedPreferences.getInstance();

  int? index = prefs.getInt("no");
  if (index == null) {
    throw Exception("未设置连接");
  }

  String? mac = prefs.getString("mac");
  if (mac == null) {
    throw Exception("未设置连接");
  }
  bool connectState = await checkConnection(mac);
  if (!connectState) {
    throw Exception("设备未连接或已断开连接，请重新连接设备");
  }

  String data =
      await api.halGenerateGetHoldings(unitId: 1, reg: reg, count: count);
  debugPrint('getHolding: $data');
  SerialResponse sr = await api.bleLesend(index: index, data: data);
  Uint8List? rdata = sr.data;
  if (rdata == null) {
    return res;
  }
  String text = String.fromCharCodes(rdata);
  debugPrint(text);

  Uint16List? v = await api.bleResponseParseU16(data: rdata);
  if (v == null) {
    return res;
  }

  return v.toList();
}

Future<List<bool>?> getCoils(int reg, int count) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  int? index = prefs.getInt("no");
  if (index == null) {
    throw Exception("未设置连接");
  }

  String? mac = prefs.getString("mac");
  if (mac == null) {
    throw Exception("未设置连接");
  }
  bool connectState = await checkConnection(mac);
  if (!connectState) {
    throw Exception("设备未连接或已断开连接，请重新连接设备");
  }

  String data =
      await api.halGenerateGetCoils(unitId: 1, reg: reg, count: count);
  SerialResponse sr = await api.bleLesend(index: index, data: data);
  Uint8List? rdata = sr.data;
  if (rdata == null) {
    return null;
  }
  String text = String.fromCharCodes(rdata);
  debugPrint("getCoils text: $text");
  Uint8List? v = await api.bleResponseParseBool(data: rdata);
  if (v == null) {
    return null;
  }

  // 010103001000318E
  //+DATA=0,016,010103001000318E
  debugPrint("getCoils ----> ${v.join(',')}");
  return v.map((e) => e != 0).toList();
}

Future<bool?> getCoil(int reg) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  int? index = prefs.getInt("no");
  if (index == null) {
    throw Exception("未设置连接");
  }

  String? mac = prefs.getString("mac");
  if (mac == null) {
    throw Exception("未设置连接");
  }
  bool connectState = await checkConnection(mac);
  if (!connectState) {
    throw Exception("设备未连接或已断开连接，请重新连接设备");
  }

  String data = await api.halGenerateGetCoils(unitId: 1, reg: reg, count: 1);
  debugPrint('getHolding: $data');
  SerialResponse sr = await api.bleLesend(index: index, data: data);
  Uint8List? rdata = sr.data;
  if (rdata == null) {
    return null;
  }
  String text = String.fromCharCodes(rdata);
  debugPrint(text);

  Uint8List? v = await api.bleResponseParseBool(data: rdata);
  if (v == null) {
    return null;
  }

  return v.toList().map((e) => e == 1).first;
}

Future<bool> setCoils(int reg, List<bool> values) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  int? index = prefs.getInt("no");
  if (index == null) {
    throw Exception("未设置连接");
  }

  String? mac = prefs.getString("mac");
  if (mac == null) {
    throw Exception("未设置连接");
  }
  bool connectState = await checkConnection(mac);
  if (!connectState) {
    throw Exception("设备未连接或已断开连接，请重新连接设备");
  }

  String data = await api.halGenerateSetCoils(
      unitId: 1,
      reg: reg,
      values: Uint8List.fromList(values.map((e) => e ? 1 : 0).toList()));

  SerialResponse sr = await api.bleLesend(index: index, data: data);
  Uint8List? rdata = sr.data;
  if (rdata == null) {
    return false;
  }
  String text = String.fromCharCodes(rdata);
  debugPrint(text);

  return text.contains("011008");
}

Future<bool> setCoil(int reg, bool value) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  int? index = prefs.getInt("no");
  if (index == null) {
    throw Exception("未设置连接");
  }

  String data =
      await api.halGenerateSetCoil(unitId: 1, reg: reg, value: value ? 1 : 0);

  debugPrint("setCoil: $data");
  SerialResponse sr = await api.bleLesend(index: index, data: data);
  Uint8List? rdata = sr.data;
  if (rdata == null) {
    return false;
  }
  String text = String.fromCharCodes(rdata);
  debugPrint(text);

  return text.contains("011008");
}

Future<bool> setHoldings(String data) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  int? index = prefs.getInt("no");
  if (index == null) {
    throw Exception("未设置连接");
  }

  String? mac = prefs.getString("mac");
  if (mac == null) {
    throw Exception("未设置连接");
  }
  bool connectState = await checkConnection(mac);
  if (!connectState) {
    throw Exception("设备未连接或已断开连接，请重新连接设备");
  }

  SerialResponse sr = await api.bleLesend(index: index, data: data);
  Uint8List? rdata = sr.data;
  if (rdata == null) {
    return false;
  }
  String text = String.fromCharCodes(rdata);
  debugPrint(text);

  return text.contains("011008");
}

Future<List<int>> readDevice() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  int? index = prefs.getInt("no");
  if (index == null) {
    throw Exception("未设置连接");
  }

  String? mac = prefs.getString("mac");
  if (mac == null) {
    throw Exception("未设置连接");
  }
  bool connectState = await checkConnection(mac);
  if (!connectState) {
    throw Exception("设备未连接或已断开连接，请重新连接设备");
  }
  List<int> data1 = await getHoldings(2196, 40);
  List<int> data2 = await getHoldings(2236, 40);

  List<int> data = data1 + data2;

  prefs.setString(mac, data.join(","));

  return data;
}

Future<List<int>> readSettings() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  int? index = prefs.getInt("no");
  if (index == null) {
    throw Exception("未设置连接");
  }

  String? mac = prefs.getString("mac");
  if (mac == null) {
    throw Exception("未设置连接");
  }
  bool connectState = await checkConnection(mac);
  if (!connectState) {
    throw Exception("设备未连接或已断开连接，请重新连接设备");
  }
  List<int> data1 = await getHoldings(2300, 40);
  List<int> data2 = await getHoldings(2340, 40);

  List<int> data = data1 + data2;

  prefs.setString(mac, data.join(","));

  return data;
}

Future<void> readLogicControlSetting() async {
  List<int> settings = await readSettings();

  debugPrint("length: ${settings.length} settings: ${settings.join(',')}");

  Uint8List v = await api.convertU16SToU8S(data: Uint16List.fromList(settings));
  debugPrint("length: ${v.length} settings: ${v.join(',')}");

  List<int> indexs = [];
  for (int i = 0; i < v.length; i += 12) {
    int index = v[i];
    int sence = v[i + 1];

    if (indexs.any((element) => element == index)) {
      continue;
    }

    indexs.add(index);

    Uint8List sub = v.sublist(i, i + 12);
    debugPrint("sub: ${sub.join(',')}");
    if ([1, 2, 4, 6, 8, 3, 5, 6, 7, 9].contains(sence)) {
      // if (index == 0) {
      //   port1 = Port.fromList(sub);
      // } else if (index == 1) {
      //   port2 = Port.fromList(sub);
      // } else if (index == 2) {
      //   port3 = Port.fromList(sub);
      // }
    }
  }
}
