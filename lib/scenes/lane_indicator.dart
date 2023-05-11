import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iot_client/ffi.dart';
import 'package:iot_client/scenes/widgets/lane_indicator_components.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../futs/hal.dart';

class Port {
  int q1;
  int q2;
  int i1;
  int q3;
  int q4;
  int i2;

  Port({
    required this.q1,
    required this.q2,
    required this.i1,
    required this.q3,
    required this.q4,
    required this.i2,
  });

  int get getQ1 => q1 + 512;
  int get getQ2 => q2 + 512;

  int get getQ3 => q3 + 512;
  int get getQ4 => q4 + 512;

  // 长度为 8 的 list
  static Port fromList(List<int> list) {
    return Port(
      q1: list[2],
      q2: list[3],
      i1: list[4],
      q3: list[5],
      q4: list[6],
      i2: list[7],
    );
  }
}

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

  Port? port1;
  Port? port2;
  Port? port3;

  @override
  bool get wantKeepAlive => false;

  void tabListener() {
    if (tabController.index == 0) {
      _prefs.then((SharedPreferences prefs) {
        return prefs.getString('mesh');
      }).then((String? addr) async {
        timer?.cancel();
        timer = null;
        List<int> res = await getHoldings(2300, 24).then((value) {
          debugPrint(value.join(','));
          return value;
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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        List<int> settings = await readSettings();

        debugPrint(
            "length: ${settings.length} settings: ${settings.join(',')}");

        Uint8List v =
            await api.parseU16SToU8S(data: Uint16List.fromList(settings));
        debugPrint("length: ${v.length} settings: ${v.join(',')}");

        for (int i = 0; i < v.length; i += 8) {
          int index = v[i];
          int sence = v[i + 1];

          Uint8List sub = v.sublist(i, i + 8);
          debugPrint("sub: ${sub.join(',')}");
          if ([1, 2, 4, 6, 8, 3, 5, 6, 7, 9].contains(sence)) {
            if (index == 0) {
              port1 = Port.fromList(sub);
              break;
            } else if (index == 1) {
              port2 = Port.fromList(sub);
            } else if (index == 2) {
              port3 = Port.fromList(sub);
            }
          }
        }
      } catch (err) {
        showSnackBar(err.toString());
      }
      if (mounted) {
        tabController.addListener(tabListener);
        tabController.animateTo(0);
      }
    });
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
    List<bool>? states = await getCoils(0, 24);

    if (states == null) {
      return;
    }

    debugPrint("states: ${states.join(',')}");
    List<bool> coils = states!;

    if (port1 != null) {
      debugPrint("port1: ${port1?.i1} ${port1?.i2}");
      bool i1 = coils[port1?.i1 ?? 0];
      bool i2 = coils[port1?.i2 ?? 0];

      mountedState(() {
        state1 = i1 ? LaneIndicatorState.green : LaneIndicatorState.red;
        state2 = i2 ? LaneIndicatorState.green : LaneIndicatorState.red;
      });
    }

    if (port2 != null) {
      bool i1 = coils[port2?.i1 ?? 0];
      bool i2 = coils[port2?.i1 ?? 0];
    }

    if (port3 != null) {
      bool i1 = coils[port3?.i1 ?? 0];
      bool i2 = coils[port3?.i1 ?? 0];
    }

    // todo
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
            if (timer != null) {
              timer!.cancel();
              timer = null;
            }
            LaneIndicatorState nextState = state1 == LaneIndicatorState.green
                ? LaneIndicatorState.red
                : LaneIndicatorState.green;

            if (nextState == LaneIndicatorState.green) {
              await setCoil(port1?.getQ1 ?? 512, true);
              await setCoil(port1?.getQ2 ?? 512, false);
            } else {
              await setCoil(port1?.getQ1 ?? 512, false);
              await setCoil(port1?.getQ2 ?? 512, true);
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
              await setCoil(port1?.getQ3 ?? 512, true);
              await setCoil(port1?.getQ4 ?? 512, false);
            } else {
              await setCoil(port1?.getQ3 ?? 512, false);
              await setCoil(port1?.getQ4 ?? 512, true);
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
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w500,
            ),
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
