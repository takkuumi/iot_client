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
