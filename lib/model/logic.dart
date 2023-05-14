import 'package:flutter/foundation.dart';

import '../ffi.dart';

class Logic {
  int index;
  int scene;
  List<int> values;

  Logic({
    required this.index,
    required this.scene,
    required this.values,
  });

  static List<Logic> parseLogics(Uint8List responseBody) {
    List<Logic> logics = [];
    int lastIndex = -1;
    for (int i = 0; i < responseBody.length; i += 12) {
      int index = responseBody[i];
      int sence = responseBody[i + 1];

      if (index != lastIndex + 1) {
        break;
      }

      lastIndex += 1;

      Uint8List values = responseBody.sublist(i + 2, i + 12);

      Logic logic = Logic(index: index, scene: sence, values: values);

      logics.add(logic);
    }
    logics.sort((a, b) => a.index.compareTo(b.index));
    return logics;
  }

  List<int> toList() {
    List<int> res = List<int>.empty(growable: true);
    res.add(index);
    res.add(scene);
    res.addAll(values);
    return res;
  }

  Future<bool> toLogicControl(int no) async {
    LogicControl logicControl = await api.halNewLogicControl(
      index: index,
      scene: scene,
      values: Uint8List.fromList(values),
    );

    String rtudata = await api.halGenerateSetLcHoldings(
        unitId: 1, logicControl: logicControl);

    SerialResponse resp = await api.bleLesend(index: no, data: rtudata);
    if (resp.data != null) {
      return true;
    }

    return false;
  }
}
