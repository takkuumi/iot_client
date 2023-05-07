import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:iot_client/ffi.dart';
import 'package:iot_client/scenes/widgets/lane_indicator_components.dart';
import 'package:iot_client/utils/at_parse.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../futs/hal.dart';

class LaneIndicator extends StatefulWidget {
  const LaneIndicator({Key? key}) : super(key: key);

  @override
  State<LaneIndicator> createState() => _LaneIndicatorState();
}

enum LaneIndicatorState { green, red }

class _LaneIndicatorState extends State<LaneIndicator>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldMessengerState> key =
      GlobalKey<ScaffoldMessengerState>(debugLabel: 'lane_indicator');
  late TabController tabController;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  LaneIndicatorState state1 = LaneIndicatorState.red;
  LaneIndicatorState state2 = LaneIndicatorState.red;

  Future<String?> sn = Future.value(null);
  Future<String?> ip = Future.value(null);

  void mountedState(void Function() fn) {
    if (mounted) {
      setState(fn);
    }
  }

  int? rule;

  // 车一
  int? in1_1;
  int? in1_2;
  int? in1_3;
  int? in1_4;
  int? ot1_1;
  int? ot1_2;
  int? ot1_3;
  int? ot1_4;

  // 车二
  int? in2_1;
  int? in2_2;
  int? in2_3;
  int? in2_4;
  int? ot2_1;
  int? ot2_2;
  int? ot2_3;
  int? ot2_4;

  // 车三
  int? in3_1;
  int? in3_2;
  int? in3_3;
  int? in3_4;
  int? ot3_1;
  int? ot3_2;
  int? ot3_3;
  int? ot3_4;

  @override
  bool get wantKeepAlive => false;

  void tabListener() {
    if (tabController.index == 0) {
      _prefs.then((SharedPreferences prefs) {
        return prefs.getString('mesh');
      }).then((String? addr) async {
        timer?.cancel();
        timer = null;
        await getHoldings(2300, 28).then((value) {
          debugPrint(value.join(','));

          rule = value[1];

          in1_1 = value[2];

          in1_2 = value[3];
          in1_3 = value[4];
          in1_4 = value[5];

          ot1_1 = value[14];
          ot1_2 = value[15];
          ot1_3 = value[16];
          ot1_4 = value[17];

          in2_1 = value[6];
          in2_2 = value[7];
          in2_3 = value[8];
          in2_4 = value[9];

          ot2_1 = value[18];
          ot2_2 = value[19];
          ot2_3 = value[20];
          ot2_4 = value[21];

          in3_1 = value[10];
          in3_2 = value[11];
          in3_3 = value[12];
          in3_4 = value[13];

          ot3_1 = value[22];
          ot3_2 = value[23];
          ot3_3 = value[24];
          ot3_4 = value[25];
        });

        await initLaneState();

        setTimer();
      });

      // readDevice(
      //   readAt("0200"),
      //   initLaneState,
      //   () {
      //     debugPrint("error");
      //   },
      // );
    }
    if (tabController.index == 1) {
      _prefs.then((SharedPreferences prefs) {
        return prefs.getString('mesh');
      }).then((String? addr) async {
        timer?.cancel();
        timer = null;
        if (addr != null) {
          await getHoldings(2196, 9).then((value) {
            Uint8List v = Uint16List.fromList(value).buffer.asUint8List();
            mountedState(() {
              sn = Future.value(String.fromCharCodes(v));
            });
          });

          await getHoldings(2247, 4).then((value) {
            mountedState(() {
              ip = Future.value(value.join('.'));
            });
          });
        }
      });
    }
  }

  Timer? timer;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    tabController.animateTo(0);

    tabController.addListener(tabListener);
  }

  void setTimer() {
    if (timer != null) {
      timer!.cancel();
      timer = null;
    }
    timer = Timer.periodic(timerDuration, (timer) async {
      await initLaneState();
    });
  }

  Future<void> initLaneState() async {
    bool? a = await getCoil(in1_1!);
    if (a != null && a) {
      mountedState(() {
        state1 = LaneIndicatorState.green;
      });
    }
    bool? b = await getCoil(in1_2!);
    if (b != null && b) {
      mountedState(() {
        state1 = LaneIndicatorState.red;
      });
    }

    bool? c = await getCoil(in1_3!);
    if (c != null && c) {
      mountedState(() {
        state2 = LaneIndicatorState.green;
      });
    }
    bool? d = await getCoil(in1_4!);
    if (d != null && d) {
      mountedState(() {
        state2 = LaneIndicatorState.red;
      });
    }
  }

  @override
  void dispose() {
    tabController.removeListener(tabListener);
    timer?.cancel();
    super.dispose();
  }

  final BoxShadow boxShadow = BoxShadow(
    color: Colors.grey.withOpacity(0.5),
    spreadRadius: 5,
    blurRadius: 7,
    offset: const Offset(0, 3),
  );

  Widget createLane1() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildLaneIndictorTitle("车道一"),
        verticalLineOnly,
        GestureDetector(
          onTap: () async {
            LaneIndicatorState nextState = state1 == LaneIndicatorState.green
                ? LaneIndicatorState.red
                : LaneIndicatorState.green;

            if (nextState == LaneIndicatorState.green) {
              await setCoils(ot1_1! + 512, [true, false]);
              // if ([4, 5, 8, 9].contains(rule!)) {
              await setCoils(ot1_3! + 512, [false, true]);
              // }
            } else {
              await setCoils(ot1_1! + 512, [false, true]);
              // if ([4, 5, 8, 9].contains(rule!)) {
              await setCoils(ot1_3! + 512, [true, false]);
              // }
            }

            await initLaneState();
          },
          child: Container(
            width: 100,
            height: 100,
            alignment: Alignment.center,
            child: Image.asset(
              state1 == LaneIndicatorState.green
                  ? "images/light_inside/img_1@2x.png"
                  : "images/light_inside/img_3@2x.png",
            ),
          ),
        ),
        verticalLine,
        GestureDetector(
          onTap: () async {
            LaneIndicatorState nextState = state2 == LaneIndicatorState.green
                ? LaneIndicatorState.red
                : LaneIndicatorState.green;

            if (nextState == LaneIndicatorState.green) {
              await setCoils(ot1_3! + 512, [true, false]);
              // if ([4, 5, 8, 9].contains(rule!)) {
              await setCoils(ot1_1! + 512, [false, true]);
              // }
            } else {
              await setCoils(ot1_3! + 512, [false, true]);
              // if ([4, 5, 8, 9].contains(rule!)) {
              await setCoils(ot1_1! + 512, [true, false]);
              //}
            }

            await initLaneState();
          },
          child: Container(
            width: 100,
            height: 100,
            alignment: Alignment.center,
            child: Container(
              width: 100,
              height: 100,
              alignment: Alignment.center,
              child: Image.asset(
                state2 == LaneIndicatorState.green
                    ? "images/light_inside/img_1@2x.png"
                    : "images/light_inside/img_3@2x.png",
              ),
            ),
          ),
        ),
        verticalLine2,
        Container(
          width: 90,
          height: 32,
          decoration: BoxDecoration(
            color: Color.fromRGBO(0, 84, 216, 1),
            borderRadius: BorderRadius.circular(16),
          ),
          alignment: Alignment.center,
          child: Text(
            getState(),
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white, fontSize: 17, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }

  String getState() {
    if (state1 == LaneIndicatorState.green &&
        state2 == LaneIndicatorState.red) {
      return "正行";
    }
    if (state1 == LaneIndicatorState.red &&
        state2 == LaneIndicatorState.green) {
      return "逆行";
    }

    return "禁行";
  }

  Widget createLane2() {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      buildLaneIndictorTitle("车道二"),
      verticalLineOnly,
      buildOffState(),
      verticalLine,
      buildOffState(),
      verticalLine2,
      Container(
        width: 90,
        height: 32,
        decoration: BoxDecoration(
          color: Color.fromRGBO(197, 197, 197, 1),
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.center,
        child: Text(
          "无",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
        ),
      ),
    ]);
  }

  Widget createLane3() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildLaneIndictorTitle("车道三"),
        verticalLineOnly,
        buildOffState(),
        verticalLine,
        buildOffState(),
        verticalLine2,
        Container(
          width: 90,
          height: 32,
          decoration: BoxDecoration(
            color: Color.fromRGBO(197, 197, 197, 1),
            borderRadius: BorderRadius.circular(16),
          ),
          alignment: Alignment.center,
          child: Text(
            "无",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: key,
      child: Scaffold(
          appBar: AppBar(
            title: const Text('车道指示器'),
            centerTitle: true,
            bottom: TabBar(
              controller: tabController,
              tabs: [
                Tab(
                  text: "控制信息",
                ),
                Tab(
                  text: "服务信息",
                ),
              ],
            ),
          ),
          body: TabBarView(
            controller: tabController,
            physics: BouncingScrollPhysics(),
            dragStartBehavior: DragStartBehavior.down,
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: 50),
                child: Container(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 600,
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: Wrap(
                          alignment: WrapAlignment.spaceEvenly,
                          spacing: 10,
                          children: [
                            createLane1(),
                            createLane2(),
                            createLane2(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                child: Container(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          verticalDirection: VerticalDirection.down,
                          children: [
                            Text(
                              "设备SN编号:",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w500),
                            ),
                            SizedBox.fromSize(
                              size: Size(5, 0),
                            ),
                            FutureBuilder(
                              future: sn,
                              initialData: '',
                              builder:
                                  (context, AsyncSnapshot<String?> snapshot) {
                                if (snapshot.hasData &&
                                    snapshot.connectionState ==
                                        ConnectionState.done) {
                                  String id = snapshot.data ?? '';
                                  return Text(
                                    id,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w300),
                                  );
                                }

                                return Text(
                                  "",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w300),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          verticalDirection: VerticalDirection.down,
                          children: [
                            Text(
                              "设备状态:",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w500),
                            ),
                            SizedBox.fromSize(
                              size: Size(5, 0),
                            ),
                            Text(
                              "运行中",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w300),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          verticalDirection: VerticalDirection.down,
                          children: [
                            Text(
                              "设备版本:",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w500),
                            ),
                            SizedBox.fromSize(
                              size: Size(5, 0),
                            ),
                            Text(
                              "v1.0.0",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w300),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          verticalDirection: VerticalDirection.down,
                          children: [
                            Text(
                              "设备IP:",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w500),
                            ),
                            SizedBox.fromSize(
                              size: Size(5, 0),
                            ),
                            FutureBuilder(
                              future: ip,
                              initialData: '',
                              builder:
                                  (context, AsyncSnapshot<String?> snapshot) {
                                if (snapshot.hasData &&
                                    snapshot.connectionState ==
                                        ConnectionState.done) {
                                  String id = snapshot.data ?? '';
                                  return Text(
                                    id,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w300),
                                  );
                                }

                                return Text(
                                  "",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w300),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          verticalDirection: VerticalDirection.down,
                          children: [
                            Text(
                              "设备端口:",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w500),
                            ),
                            SizedBox.fromSize(
                              size: Size(5, 0),
                            ),
                            Text(
                              "5002",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w300),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }
}
