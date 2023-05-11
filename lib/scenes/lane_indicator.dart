import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iot_client/ffi.dart';
import 'package:iot_client/scenes/widgets/lane_indicator_comp.dart';
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

  final key1 =
      GlobalKey<LaneIndicatorUIState>(debugLabel: "LaneIndicatorUIState1");
  final key2 =
      GlobalKey<LaneIndicatorUIState>(debugLabel: "LaneIndicatorUIState2");
  final key3 =
      GlobalKey<LaneIndicatorUIState>(debugLabel: "LaneIndicatorUIState3");

  Future<String?> sn = Future.value(null);
  Future<String?> ip = Future.value(null);

  void mountedState(void Function() fn) {
    if (mounted) {
      setState(fn);
    }
  }

  @override
  bool get wantKeepAlive => true;

  void tabListener() {
    if (tabController.index == 0) {
      _prefs.then((SharedPreferences prefs) {
        return prefs.getString('mesh');
      }).then((String? addr) async {
        timer?.cancel();
        timer = null;

        await initLaneState();

        setTimer();
      });
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

  Port? port1;
  Port? port2;
  Port? port3;

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
            await api.convertU16SToU8S(data: Uint16List.fromList(settings));
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
              key2.currentState?.updatePort(Port.fromList(sub));
            } else if (index == 2) {
              key3.currentState?.updatePort(Port.fromList(sub));
            }
          }
        }
        mountedState(() {});
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

    key1.currentState?.updateState(states);
    key2.currentState?.updateState(states);
    key3.currentState?.updateState(states);
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
                  width: 600,
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Wrap(
                    alignment: WrapAlignment.spaceEvenly,
                    spacing: 10,
                    children: [
                      LaneIndicatorUI(key: key1, title: "车道一", port: port1),
                      LaneIndicatorUI(key: key2, title: "车道二", port: port2),
                      LaneIndicatorUI(key: key3, title: "车道三", port: port3),
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
