import 'dart:typed_data';

import 'package:flutter/foundation.dart';

class Logic {
  int index;
  int secen;
  List<int> values;

  Logic({
    required this.index,
    required this.secen,
    required this.values,
  });

  static List<Logic> parseLogics(Uint8List responseBody) {
    List<Logic> logics = [];
    List<int> indexs = [];
    for (int i = 0; i < responseBody.length; i += 12) {
      int index = responseBody[i];
      int sence = responseBody[i + 1];

      if (indexs.any((element) => element == index)) {
        continue;
      }

      indexs.add(index);

      Uint8List values = responseBody.sublist(i, i + 12);

      Logic logic = Logic(index: index, secen: sence, values: values);

      logics.add(logic);
    }

    return logics;
  }

  factory Logic.fromJson(Map<String, dynamic> json) {
    return Logic(
      index: json['index'],
      secen: json['secen'],
      values: json['values'].cast<int>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'index': index,
      'secen': secen,
      'values': values,
    };
  }
}
