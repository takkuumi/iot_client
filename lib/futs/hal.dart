import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:iot_client/ffi.dart';

Future<int?> getHolding(String meshId, int reg) async {
  String data = await api.halGenerateGetHoldings(unitId: 1, reg: reg, count: 1);
  debugPrint('getHolding: $data');
  SerialResponse sr =
      await api.bleAtNdrptData(id: meshId, data: data, retry: 5);
  Uint8List? rdata = sr.data;
  if (rdata != null) {
    String text = String.fromCharCodes(rdata);
    debugPrint(text);
    bool state = await api.bleValidateResponse(data: rdata);
    if (state) {
      return await api.bleResponseParseU16(data: rdata, unitId: 1);
    }
  }
  return null;
}

Future<List<int>> getHoldings(String meshId, int reg, int count) async {
  debugPrint(meshId);
  List<int> res = List<int>.empty(growable: true);
  for (int i = reg; i < reg + count; i++) {
    int? value = await getHolding(meshId, i);
    if (value != null) {
      res.add(value);
    }
  }
  return res;
}
