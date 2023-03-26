import 'package:flutter/material.dart';

bool getAtOk(String atResponse) {
  return atResponse.contains('OK') && atResponse.contains('+DATA');
}

int? getAtReadResult(String atResponse) {
  if (getAtOk(atResponse)) {
    print(atResponse.indexOf("010101"));
    if (atResponse.contains("010101019048")) {
      return 1;
    } else if (atResponse.contains("010101005188")) {
      return 0;
    }
  }
}
