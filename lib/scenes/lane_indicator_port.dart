import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:iot_client/ffi.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../futs/hal.dart';

class LaneIndicatorPort extends StatefulWidget {
  const LaneIndicatorPort({Key? key}) : super(key: key);

  @override
  State<LaneIndicatorPort> createState() => _LaneIndicatorPortState();
}

enum LaneIndicatorPortState { green, red }

class _LaneIndicatorPortState extends State<LaneIndicatorPort>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  final GlobalKey<ScaffoldMessengerState> key =
      GlobalKey<ScaffoldMessengerState>(debugLabel: 'lane_indicator_port');

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  int scene = 1;
  List<bool> com_x1 = List.filled(16, false);
  List<bool> com_x2 = List.filled(16, false);
  List<bool> com_x3 = List.filled(16, false);
  List<bool> com_x4 = List.filled(16, false);
  List<bool> com_x5 = List.filled(16, false);
  List<bool> com_x6 = List.filled(16, false);
  List<bool> com_y1 = List.filled(9, false);
  List<bool> com_y2 = List.filled(9, false);
  List<bool> com_y3 = List.filled(9, false);
  List<bool> com_y4 = List.filled(9, false);
  List<bool> com_y5 = List.filled(9, false);
  List<bool> com_y6 = List.filled(9, false);

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void saveConfig() {
    _prefs.then((SharedPreferences prefs) {
      return prefs.getString('mesh');
    }).then((String? meshId) async {
      if (meshId != null) {
        debugPrint(meshId);
        await EasyLoading.show(
          status: '正在下发配置...',
          maskType: EasyLoadingMaskType.black,
        );
        List<int> com_x11 = [];
        com_x1.asMap().forEach((key, value) {
          if (value) {
            com_x11.add(key);
          }
        });
        List<int> com_x22 = [];
        com_x2.asMap().forEach((key, value) {
          if (value) {
            com_x22.add(key);
          }
        });
        List<int> com_y11 = [];
        com_y1.asMap().forEach((key, value) {
          if (value) {
            com_y11.add(key);
          }
        });
        List<int> com_y22 = [];
        com_y2.asMap().forEach((key, value) {
          if (value) {
            com_y22.add(key);
          }
        });
        debugPrint(Uint8List.fromList(com_x11).join(","));

        Com comin1 =
            await api.halGetComIndexs(indexs: Uint8List.fromList(com_x11));

        Com comout1 =
            await api.halGetComIndexs(indexs: Uint8List.fromList(com_y11));
        bool res1 = await api.halNewControl(
            id: meshId,
            retry: 5,
            index: 1,
            scene: scene,
            comIn: comin1,
            comOut: comout1);

        Com comin2 =
            await api.halGetComIndexs(indexs: Uint8List.fromList(com_x22));

        Com comout2 =
            await api.halGetComIndexs(indexs: Uint8List.fromList(com_y22));
        bool res2 = await api.halNewControl(
            id: meshId,
            retry: 20,
            index: 2,
            scene: scene,
            comIn: comin2,
            comOut: comout2);

        if (!res1 || !res2) {
          showSnackBar("保存失败，请重试", key);
        }

        await EasyLoading.dismiss();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: key,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('车道指示器逻辑控制配置'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 50, horizontal: 15),
          child: Container(
            child: Form(
              child: Column(
                children: [
                  DropdownButton<int>(
                    hint: Text("请选择车道指示器组合类型"),
                    value: scene,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          scene = value;
                        });
                      }
                    },
                    items: [
                      DropdownMenuItem(
                        child: Text("单点控车指"),
                        value: 1,
                      ),
                      DropdownMenuItem(
                        child: Text("组合式车指(单面互锁；4显，反馈为独立点)"),
                        value: 2,
                      ),
                      DropdownMenuItem(
                        child: Text("组合式车指(单面互锁；6显，反馈为独立点)"),
                        value: 3,
                      ),
                      DropdownMenuItem(
                        child: Text("组合式车指(单面互锁；4显，反馈为组合点)"),
                        value: 4,
                      ),
                      DropdownMenuItem(
                        child: Text("组合式车指(单面互锁；6显，反馈为组合点)"),
                        value: 5,
                      ),
                      DropdownMenuItem(
                        child: Text("组合式车指(双面互锁；4显，反馈为独立点)"),
                        value: 6,
                      ),
                      DropdownMenuItem(
                        child: Text("组合式车指(双面互锁；6显，反馈为独立点)"),
                        value: 7,
                      ),
                      DropdownMenuItem(
                        child: Text("组合式车指(双面互锁；4显，反馈为组合点)"),
                        value: 8,
                      ),
                      DropdownMenuItem(
                        child: Text("组合式车指(双面互锁；6显，反馈为组合点)"),
                        value: 9,
                      ),
                    ],
                  ),
                  SizedBox.fromSize(size: Size.fromHeight(20)),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("车道一正面X位操作区"),
                        SizedBox.fromSize(size: Size.fromHeight(10)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              child: Column(
                                children: [
                                  Checkbox(
                                    value: com_x1[0],
                                    onChanged: (value) {
                                      if (value != null) {
                                        setState(() {
                                          com_x1[0] = value;
                                        });
                                      }
                                    },
                                  ),
                                  Text("X0"),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Checkbox(
                                    value: com_x1[1],
                                    onChanged: (value) {
                                      if (value != null) {
                                        setState(() {
                                          com_x1[1] = value;
                                        });
                                      }
                                    },
                                  ),
                                  Text("X1"),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Checkbox(
                                    value: com_x1[2],
                                    onChanged: (value) {
                                      if (value != null) {
                                        setState(() {
                                          com_x1[2] = value;
                                        });
                                      }
                                    },
                                  ),
                                  Text("X2"),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Checkbox(
                                    value: com_x1[3],
                                    onChanged: (value) {
                                      if (value != null) {
                                        setState(() {
                                          com_x1[3] = value;
                                        });
                                      }
                                    },
                                  ),
                                  Text("X3"),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Checkbox(
                                    value: com_x1[4],
                                    onChanged: (value) {
                                      if (value != null) {
                                        setState(() {
                                          com_x1[4] = value;
                                        });
                                      }
                                    },
                                  ),
                                  Text("X4"),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Checkbox(
                                    value: com_x1[5],
                                    onChanged: (value) {
                                      if (value != null) {
                                        setState(() {
                                          com_x1[5] = value;
                                        });
                                      }
                                    },
                                  ),
                                  Text("X5"),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Checkbox(
                                    value: com_x1[6],
                                    onChanged: (value) {
                                      if (value != null) {
                                        setState(() {
                                          com_x1[6] = value;
                                        });
                                      }
                                    },
                                  ),
                                  Text("X6"),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Checkbox(
                                    value: com_x1[7],
                                    onChanged: (value) {
                                      if (value != null) {
                                        setState(() {
                                          com_x1[7] = value;
                                        });
                                      }
                                    },
                                  ),
                                  Text("X7"),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox.fromSize(size: Size.fromHeight(10)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              child: Column(
                                children: [
                                  Checkbox(
                                    value: com_x1[8],
                                    onChanged: (value) {
                                      if (value != null) {
                                        setState(() {
                                          com_x1[8] = value;
                                        });
                                      }
                                    },
                                  ),
                                  Text("X8"),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Checkbox(
                                    value: com_x1[9],
                                    onChanged: (value) {
                                      if (value != null) {
                                        setState(() {
                                          com_x1[9] = value;
                                        });
                                      }
                                    },
                                  ),
                                  Text("X9"),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Checkbox(
                                    value: com_x1[10],
                                    onChanged: (value) {
                                      if (value != null) {
                                        setState(() {
                                          com_x1[10] = value;
                                        });
                                      }
                                    },
                                  ),
                                  Text("X10"),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Checkbox(
                                    value: com_x1[11],
                                    onChanged: (value) {
                                      if (value != null) {
                                        setState(() {
                                          com_x1[11] = value;
                                        });
                                      }
                                    },
                                  ),
                                  Text("X11"),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Checkbox(
                                    value: com_x1[12],
                                    onChanged: (value) {
                                      if (value != null) {
                                        setState(() {
                                          com_x1[12] = value;
                                        });
                                      }
                                    },
                                  ),
                                  Text("X12"),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Checkbox(
                                    value: com_x1[13],
                                    onChanged: (value) {
                                      if (value != null) {
                                        setState(() {
                                          com_x1[13] = value;
                                        });
                                      }
                                    },
                                  ),
                                  Text("X13"),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Checkbox(
                                    value: com_x1[14],
                                    onChanged: (value) {
                                      if (value != null) {
                                        setState(() {
                                          com_x1[14] = value;
                                        });
                                      }
                                    },
                                  ),
                                  Text("X14"),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Checkbox(
                                    value: com_x1[15],
                                    onChanged: (value) {
                                      if (value != null) {
                                        setState(() {
                                          com_x1[15] = value;
                                        });
                                      }
                                    },
                                  ),
                                  Text("X15"),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox.fromSize(size: Size.fromHeight(20)),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("车道一正面Y位操作区"),
                        SizedBox.fromSize(size: Size.fromHeight(10)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              child: Column(
                                children: [
                                  Checkbox(
                                    value: com_y1[0],
                                    onChanged: (value) {
                                      if (value != null) {
                                        setState(() {
                                          com_y1[0] = value;
                                        });
                                      }
                                    },
                                  ),
                                  Text("Y0"),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Checkbox(
                                    value: com_y1[1],
                                    onChanged: (value) {
                                      if (value != null) {
                                        setState(() {
                                          com_y1[1] = value;
                                        });
                                      }
                                    },
                                  ),
                                  Text("Y1"),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Checkbox(
                                    value: com_y1[2],
                                    onChanged: (value) {
                                      if (value != null) {
                                        setState(() {
                                          com_y1[2] = value;
                                        });
                                      }
                                    },
                                  ),
                                  Text("Y2"),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Checkbox(
                                    value: com_y1[3],
                                    onChanged: (value) {
                                      if (value != null) {
                                        setState(() {
                                          com_y1[3] = value;
                                        });
                                      }
                                    },
                                  ),
                                  Text("Y3"),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Checkbox(
                                    value: com_y1[4],
                                    onChanged: (value) {
                                      if (value != null) {
                                        setState(() {
                                          com_y1[4] = value;
                                        });
                                      }
                                    },
                                  ),
                                  Text("Y4"),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Checkbox(
                                    value: com_y1[5],
                                    onChanged: (value) {
                                      if (value != null) {
                                        setState(() {
                                          com_y1[5] = value;
                                        });
                                      }
                                    },
                                  ),
                                  Text("Y5"),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Checkbox(
                                    value: com_y1[6],
                                    onChanged: (value) {
                                      if (value != null) {
                                        setState(() {
                                          com_y1[6] = value;
                                        });
                                      }
                                    },
                                  ),
                                  Text("Y6"),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Checkbox(
                                    value: com_y1[7],
                                    onChanged: (value) {
                                      if (value != null) {
                                        setState(() {
                                          com_y1[7] = value;
                                        });
                                      }
                                    },
                                  ),
                                  Text("Y7"),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Checkbox(
                                    value: com_y1[8],
                                    onChanged: (value) {
                                      if (value != null) {
                                        setState(() {
                                          com_y1[8] = value;
                                        });
                                      }
                                    },
                                  ),
                                  Text("Y8"),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox.fromSize(size: Size.fromHeight(20)),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("车道一反面X位操作区"),
                        SizedBox.fromSize(size: Size.fromHeight(10)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              child: Column(
                                children: [
                                  Checkbox(
                                    value: com_x2[0],
                                    onChanged: (value) {
                                      if (value != null) {
                                        setState(() {
                                          com_x2[0] = value;
                                        });
                                      }
                                    },
                                  ),
                                  Text("X0"),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Checkbox(
                                    value: com_x2[1],
                                    onChanged: (value) {
                                      if (value != null) {
                                        setState(() {
                                          com_x2[1] = value;
                                        });
                                      }
                                    },
                                  ),
                                  Text("X1"),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Checkbox(
                                    value: com_x2[2],
                                    onChanged: (value) {
                                      if (value != null) {
                                        setState(() {
                                          com_x2[2] = value;
                                        });
                                      }
                                    },
                                  ),
                                  Text("X2"),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Checkbox(
                                    value: com_x2[3],
                                    onChanged: (value) {
                                      if (value != null) {
                                        setState(() {
                                          com_x2[3] = value;
                                        });
                                      }
                                    },
                                  ),
                                  Text("X3"),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Checkbox(
                                    value: com_x2[4],
                                    onChanged: (value) {
                                      if (value != null) {
                                        setState(() {
                                          com_x2[4] = value;
                                        });
                                      }
                                    },
                                  ),
                                  Text("X4"),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Checkbox(
                                    value: com_x2[5],
                                    onChanged: (value) {
                                      if (value != null) {
                                        setState(() {
                                          com_x2[5] = value;
                                        });
                                      }
                                    },
                                  ),
                                  Text("X5"),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Checkbox(
                                    value: com_x2[6],
                                    onChanged: (value) {
                                      if (value != null) {
                                        setState(() {
                                          com_x2[6] = value;
                                        });
                                      }
                                    },
                                  ),
                                  Text("X6"),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Checkbox(
                                    value: com_x2[7],
                                    onChanged: (value) {
                                      if (value != null) {
                                        setState(() {
                                          com_x2[7] = value;
                                        });
                                      }
                                    },
                                  ),
                                  Text("X7"),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox.fromSize(size: Size.fromHeight(10)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              child: Column(
                                children: [
                                  Checkbox(
                                    value: com_x2[8],
                                    onChanged: (value) {
                                      if (value != null) {
                                        setState(() {
                                          com_x2[8] = value;
                                        });
                                      }
                                    },
                                  ),
                                  Text("X8"),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Checkbox(
                                    value: com_x2[9],
                                    onChanged: (value) {
                                      if (value != null) {
                                        setState(() {
                                          com_x2[9] = value;
                                        });
                                      }
                                    },
                                  ),
                                  Text("X9"),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Checkbox(
                                    value: com_x2[10],
                                    onChanged: (value) {
                                      if (value != null) {
                                        setState(() {
                                          com_x2[10] = value;
                                        });
                                      }
                                    },
                                  ),
                                  Text("X10"),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Checkbox(
                                    value: com_x2[11],
                                    onChanged: (value) {
                                      if (value != null) {
                                        setState(() {
                                          com_x2[11] = value;
                                        });
                                      }
                                    },
                                  ),
                                  Text("X11"),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Checkbox(
                                    value: com_x2[12],
                                    onChanged: (value) {
                                      if (value != null) {
                                        setState(() {
                                          com_x2[12] = value;
                                        });
                                      }
                                    },
                                  ),
                                  Text("X12"),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Checkbox(
                                    value: com_x2[13],
                                    onChanged: (value) {
                                      if (value != null) {
                                        setState(() {
                                          com_x2[13] = value;
                                        });
                                      }
                                    },
                                  ),
                                  Text("X13"),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Checkbox(
                                    value: com_x2[14],
                                    onChanged: (value) {
                                      if (value != null) {
                                        setState(() {
                                          com_x2[14] = value;
                                        });
                                      }
                                    },
                                  ),
                                  Text("X14"),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Checkbox(
                                    value: com_x2[15],
                                    onChanged: (value) {
                                      if (value != null) {
                                        setState(() {
                                          com_x2[15] = value;
                                        });
                                      }
                                    },
                                  ),
                                  Text("X15"),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox.fromSize(size: Size.fromHeight(20)),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("车道一反面Y位操作区"),
                        SizedBox.fromSize(size: Size.fromHeight(10)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              child: Column(
                                children: [
                                  Checkbox(
                                    value: com_y2[0],
                                    onChanged: (value) {
                                      if (value != null) {
                                        setState(() {
                                          com_y2[0] = value;
                                        });
                                      }
                                    },
                                  ),
                                  Text("Y0"),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Checkbox(
                                    value: com_y2[1],
                                    onChanged: (value) {
                                      if (value != null) {
                                        setState(() {
                                          com_y2[1] = value;
                                        });
                                      }
                                    },
                                  ),
                                  Text("Y1"),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Checkbox(
                                    value: com_y2[2],
                                    onChanged: (value) {
                                      if (value != null) {
                                        setState(() {
                                          com_y2[2] = value;
                                        });
                                      }
                                    },
                                  ),
                                  Text("Y2"),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Checkbox(
                                    value: com_y2[3],
                                    onChanged: (value) {
                                      if (value != null) {
                                        setState(() {
                                          com_y2[3] = value;
                                        });
                                      }
                                    },
                                  ),
                                  Text("Y3"),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Checkbox(
                                    value: com_y2[4],
                                    onChanged: (value) {
                                      if (value != null) {
                                        setState(() {
                                          com_y2[4] = value;
                                        });
                                      }
                                    },
                                  ),
                                  Text("Y4"),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Checkbox(
                                    value: com_y2[5],
                                    onChanged: (value) {
                                      if (value != null) {
                                        setState(() {
                                          com_y2[5] = value;
                                        });
                                      }
                                    },
                                  ),
                                  Text("Y5"),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Checkbox(
                                    value: com_y2[6],
                                    onChanged: (value) {
                                      if (value != null) {
                                        setState(() {
                                          com_y2[6] = value;
                                        });
                                      }
                                    },
                                  ),
                                  Text("Y6"),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Checkbox(
                                    value: com_y2[7],
                                    onChanged: (value) {
                                      if (value != null) {
                                        setState(() {
                                          com_y2[7] = value;
                                        });
                                      }
                                    },
                                  ),
                                  Text("Y7"),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Checkbox(
                                    value: com_y2[8],
                                    onChanged: (value) {
                                      if (value != null) {
                                        setState(() {
                                          com_y2[8] = value;
                                        });
                                      }
                                    },
                                  ),
                                  Text("Y8"),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox.fromSize(size: Size.fromHeight(30)),
                  ElevatedButton(
                    onPressed: () {
                      saveConfig();
                    },
                    child: Text("保存配置"),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
