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

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final SharedPreferences prefs = await _prefs;
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

  Uint16List? v = await api.bleResponseParseU16(data: rdata, unitId: 1);
  if (v == null) {
    return res;
  }

  return v.toList();
}
