import 'package:flutter/material.dart';

bool getAtOk(String atResponse) {
  return atResponse.contains('OK') && atResponse.contains('+DATA');
}

int? getAtReadResult(String atResponse) {
  if (getAtOk(atResponse)) {
    int index = atResponse.indexOf("010101");
    if (index > 0) {
      String state = atResponse.substring(index + 6, index + 8);
      debugPrint(state);
      return int.parse(state, radix: 16);
    }
  }
}

List<int> parseWindSpreed(String? response) {
  List<int> result = [0, 0, 0, 0];
  if (response == null) return result;
  bool ok = getAtOk(response);
  bool checkLen = response.contains(",27,");
  if (!ok || !checkLen) return result;

  int headerIndex = response.indexOf("010308");
  if (headerIndex < 0) {
    return result;
  }

  debugPrint(response);
  String data = response.substring(headerIndex + 6, headerIndex + 22);

  if (data.length != 16) return result;

  for (int i = 0; i < 4; i++) {
    String sub = data.substring(i * 4, i * 4 + 4);
    debugPrint("---------->>>>>>>>>>>>>>$sub");
    int value = int.parse(sub, radix: 16);
    result.insert(i, value);
  }
  return result;
}

List<int> parseLight(String? response) {
  debugPrint(response ?? '');
  List<int> result = [0, 0, 0];
  if (response == null) return result;
  bool ok = getAtOk(response);
  bool checkLen = response.contains(",23,");
  if (!ok || !checkLen) return result;

  int headerIndex = response.indexOf("010306");
  if (headerIndex < 0) {
    return result;
  }

  String data = response.substring(headerIndex + 6, headerIndex + 18);

  if (data.length != 12) return result;

  for (int i = 0; i < 3; i++) {
    String sub = data.substring(i * 4, i * 4 + 4);
    int value = int.parse(sub, radix: 16);
    result.insert(i, value);
  }
  return result;
}
