import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:iot_client/ffi.io.dart';
import 'package:iot_client/model/logic.dart';
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

Future<bool?> setCoil(int reg, bool value) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  int? index = prefs.getInt("no");
  if (index == null) {
    throw Exception("未设置连接");
  }

  String data =
      await api.halGenerateSetCoil(unitId: 1, reg: reg, value: value ? 1 : 0);

  debugPrint("setCoil: $data");
  try {
    SerialResponse sr = await api.bleLesend(index: index, data: data);
    Uint8List? rdata = sr.data;
    if (rdata == null) {
      debugPrint("setCoil response null");
      return false;
    }

    String text = String.fromCharCodes(rdata);
    debugPrint(text);

    return text.contains("011008");
  } catch (err) {
    debugPrint(err.toString());
    return null;
  }
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

  SerialResponse sr = await api.bleLesend(index: index, data: data);
  Uint8List? rdata = sr.data;
  if (rdata == null) {
    return false;
  }
  String text = String.fromCharCodes(rdata);
  debugPrint(text);

  return text.contains("011008");
}

Future<List<int>> readSettings() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  String? mac = prefs.getString("mac");
  if (mac == null) {
    throw Exception("未设置连接");
  }

  String? data = prefs.getString(mac);
  if (data != null && data.isNotEmpty) {
    debugPrint("readSettings: $data");
    return data.split(",").map((e) => int.parse(e)).toList();
  }

  int? index = prefs.getInt("no");
  if (index == null) {
    throw Exception("未设置连接");
  }

  List<int> data1 = await getHoldings(2300, 50);
  List<int> data2 = await getHoldings(2350, 50);

  List<int> result = data1 + data2;

  prefs.setString(mac, result.join(","));

  return result;
}

Future<List<Logic>> readLogicControlSetting() async {
  List<int> settings = await readSettings();
  Uint8List responseBody = Uint8List.fromList(settings);
  debugPrint("settings: ${responseBody.join(',')}");
  List<Logic> logics = Logic.parseLogics(responseBody).toList();
  return logics;
}
