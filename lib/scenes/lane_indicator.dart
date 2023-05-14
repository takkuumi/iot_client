import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:iot_client/model/logic.dart';
import 'package:iot_client/model/port.dart';
import 'package:iot_client/scenes/widgets/lane_indicator_comp.dart';
import 'package:iot_client/scenes/widgets/shared_service_info.dart';
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

  final key1 =
      GlobalKey<LaneIndicatorUIState>(debugLabel: "LaneIndicatorUIState1");
  final key2 =
      GlobalKey<LaneIndicatorUIState>(debugLabel: "LaneIndicatorUIState2");
  final key3 =
      GlobalKey<LaneIndicatorUIState>(debugLabel: "LaneIndicatorUIState3");

  late TabController tabController;
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

  Future<void> tabListener() async {
    EasyLoading.dismiss();
    if (tabController.indexIsChanging) {
      if (tabController.index == 0) {
        await initMainState();
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
        List<Logic> logics = await readLogicControlSetting();

        List<Logic> v = logics.where((e) => e.scene < 10).toList();

        for (int i = 0; i < v.length; i++) {
          final logic = v[i];
          if (i == 0) {
            port1 = Port.fromList(logic.scene, logic.values);
          } else if (i == 1) {
            port2 = Port.fromList(logic.scene, logic.values);
          } else if (i == 2) {
            port3 = Port.fromList(logic.scene, logic.values);
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
          physics: NeverScrollableScrollPhysics(),
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
              child: SharedServiceInfo(),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Symbols.refresh),
          onPressed: () async {
            EasyLoading.show(status: '刷新数据中...');
            try {
              if (tabController.index == 0) {
                await initMainState();
              } else if (tabController.index == 1) {}
            } catch (err) {
              debugPrint(err.toString());
            }
            EasyLoading.dismiss();
          },
        ),
      ),
    );
  }
}
