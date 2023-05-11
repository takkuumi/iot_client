import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:iot_client/ffi.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Future<int?> getHolding(int index, int reg) async {
//   String data = await api.halGenerateGetHoldings(unitId: 1, reg: reg, count: 1);
//   debugPrint('getHolding: $data');
//   SerialResponse sr = await api.bleLesend(index: index, data: data);
//   Uint8List? rdata = sr.data;
//   if (rdata == null) {
//     return null;
//   }
//   String text = String.fromCharCodes(rdata);
//   debugPrint(text);
//   bool state = await api.bleValidateResponse(data: rdata);
//   if (state) {
//     return await api.bleResponseParseU16(data: rdata, unitId: 1);
//   }
// }

Future<List<int>> getHoldings(int reg, int count) async {
  List<int> res = List<int>.empty(growable: true);

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? addr = prefs.getString("mesh");

  if (addr != null) {
    await api.bleLecconnAddr(addr: addr);
  }
  int? index = prefs.getInt("index");
  if (index == null) {
    return res;
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

Future<int?> getCoils(int reg, int count) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? addr = prefs.getString("mesh");

  if (addr != null) {
    await api.bleLecconnAddr(addr: addr);
  }
  int? index = prefs.getInt("index");
  if (index == null) {
    return null;
  }

  String data =
      await api.halGenerateGetCoils(unitId: 1, reg: reg, count: count);
  debugPrint('getHolding: $data');
  SerialResponse sr = await api.bleLesend(index: index, data: data);
  Uint8List? rdata = sr.data;
  if (rdata == null) {
    return null;
  }
  String text = String.fromCharCodes(rdata);
  debugPrint("getCoils $text");

  Uint16List? v = await api.bleResponseParseU16(data: rdata);
  if (v == null) {
    return null;
  }

  return v.toList().first;
}

Future<bool?> getCoil(int reg) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? addr = prefs.getString("mesh");

  if (addr != null) {
    await api.bleLecconnAddr(addr: addr);
  }
  int? index = prefs.getInt("index");
  if (index == null) {
    return null;
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
  String? addr = prefs.getString("mesh");

  if (addr != null) {
    await api.bleLecconnAddr(addr: addr);
  }
  int? index = prefs.getInt("index");
  if (index == null) {
    return false;
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

Future<bool> setHoldings(String data) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? addr = prefs.getString("mesh");

  if (addr != null) {
    await api.bleLecconnAddr(addr: addr);
  }
  int? index = prefs.getInt("index");
  if (index == null) {
    return false;
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
