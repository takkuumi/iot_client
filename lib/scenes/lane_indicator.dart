import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:iot_client/ffi.dart';
import 'package:iot_client/scenes/widgets/lane_indicator_comp.dart';
import 'package:material_symbols_icons/symbols.dart';

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

  final key1 =
      GlobalKey<LaneIndicatorUIState>(debugLabel: "LaneIndicatorUIState1");
  final key2 =
      GlobalKey<LaneIndicatorUIState>(debugLabel: "LaneIndicatorUIState2");
  final key3 =
      GlobalKey<LaneIndicatorUIState>(debugLabel: "LaneIndicatorUIState3");

  Future<String?> sn = Future.value(null);
  Future<String?> ip = Future.value(null);

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Future<void> initMainState() async {
    try {
      await initLaneState();
    } catch (err) {
      showSnackBar(err.toString(), key);
    }
  }

  Future<void> initDeviceState() async {
    try {
      await getHoldings(2196, 9).then((value) {
        Uint8List v = Uint16List.fromList(value).buffer.asUint8List();
        setState(() {
          sn = Future.value(String.fromCharCodes(v));
        });
      });

      await getHoldings(2247, 4).then((value) {
        setState(() {
          ip = Future.value(value.join('.'));
        });
      });
    } catch (err) {
      showSnackBar(err.toString(), key);
    }
  }

  Future<void> tabListener() async {
    EasyLoading.dismiss();
    if (tabController.indexIsChanging) {
      if (tabController.index == 0) {
        await initMainState();
      } else if (tabController.index == 1) {
        await initDeviceState();
      }
    }
  }

  Port? port1;
  Port? port2;
  Port? port3;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, initialIndex: 0, vsync: this);
    tabController.addListener(tabListener);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        List<int> settings = await readSettings();

        debugPrint(
            "length: ${settings.length} settings: ${settings.join(',')}");

        Uint8List v =
            await api.convertU16SToU8S(data: Uint16List.fromList(settings));
        debugPrint("length: ${v.length} settings: ${v.join(',')}");

        List<int> indexs = [];
        for (int i = 0; i < v.length; i += 12) {
          int index = v[i];
          int sence = v[i + 1];

          if (indexs.any((element) => element == index)) {
            continue;
          }

          indexs.add(index);

          Uint8List sub = v.sublist(i, i + 12);
          debugPrint("sub: ${sub.join(',')}");
          if ([1, 2, 4, 6, 8, 3, 5, 6, 7, 9].contains(sence)) {
            if (index == 0) {
              port1 = Port.fromList(sub);
            } else if (index == 1) {
              port2 = Port.fromList(sub);
            } else if (index == 2) {
              port3 = Port.fromList(sub);
            }
          }
        }
        setState(() {});
        await initMainState();
      } catch (err) {
        showSnackBar(err.toString());
      }
    });
  }

  Future<void> initLaneState() async {
    List<bool>? states = await getCoils(0, 24);

    if (states == null) {
      return;
    }

    List<bool>? states2 = await getCoils(512, 24);

    if (states2 == null) {
      return;
    }

    key1.currentState?.updateState(coils: states, coils2: states2);
    key2.currentState?.updateState(coils: states, coils2: states2);
    key3.currentState?.updateState(coils: states, coils2: states2);
  }

  @override
  void dispose() {
    EasyLoading.dismiss();
    tabController.removeListener(tabListener);

    super.dispose();
  }

  final BoxShadow boxShadow = BoxShadow(
    color: Colors.grey.withOpacity(0.5),
    spreadRadius: 5,
    blurRadius: 7,
    offset: const Offset(0, 3),
  );

  Widget buildPort(Key key, String title, Port? port) {
    if (port == null) {
      return Container();
    }
    return LaneIndicatorUI(key: key, title: title, port: port);
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
                width: 600,
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Wrap(
                  alignment: WrapAlignment.spaceEvenly,
                  spacing: 10,
                  children: [
                    buildPort(key1, "车道一", port1),
                    buildPort(key2, "车道二", port2),
                    buildPort(key3, "车道三", port3),
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
                                    fontSize: 14, fontWeight: FontWeight.w300),
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
                                    fontSize: 14, fontWeight: FontWeight.w300),
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
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Symbols.refresh),
          onPressed: () async {
            EasyLoading.show(status: '刷新数据中...');
            if (tabController.index == 0) {
              await initMainState();
            } else if (tabController.index == 1) {
              await initDeviceState();
            }
            EasyLoading.dismiss();
          },
        ),
      ),
    );
  }
}
