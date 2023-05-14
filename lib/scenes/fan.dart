import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iot_client/futs/hal.dart';
import 'package:iot_client/model/logic.dart';
import 'package:iot_client/model/port.dart';
import 'package:iot_client/provider/app_provider.dart';
import 'package:iot_client/scenes/widgets/fan_comp.dart';
import 'package:iot_client/scenes/widgets/shared_service_info.dart';

class Fan extends StatefulHookConsumerWidget {
  const Fan({Key? key}) : super(key: key);

  @override
  FanState createState() => FanState();
}

class FanState extends ConsumerState<Fan> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldMessengerState> key =
      GlobalKey<ScaffoldMessengerState>(debugLabel: 'fan');

  Port? port1;
  Port? port2;
  Port? port3;

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
      EasyLoading.showError(err.toString());
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

  Future<void> initLaneState() async {
    List<bool>? states = await getCoils(0, 24);

    if (states != null) {
      ref.read(appReadCoilsProvider.notifier).change(states);
    }

    List<bool>? states2 = await getCoils(512, 24);

    if (states2 != null) {
      ref.read(appReadWriteCoilsProvider.notifier).change(states2);
    }
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, initialIndex: 0, vsync: this);
    tabController.addListener(tabListener);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        List<Logic> logics = await readLogicControlSetting();

        List<Logic> v = logics.where((e) => e.scene == 11).toList();

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
        EasyLoading.showError(err.toString());
      }
    });
  }

  Widget buildPort(String title, Port? port) {
    if (port == null) {
      return Container();
    }
    return FanUI(title: title, port: port);
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: key,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('通风风机'),
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
              child: Column(children: [
                Container(
                  width: double.infinity,
                  child: Image.asset(
                    "images/icons/fan_banner.png",
                    height: 200,
                    fit: BoxFit.fitWidth,
                    gaplessPlayback: true,
                  ),
                ),
                Container(
                  width: 470,
                  padding: EdgeInsets.only(top: 10),
                  child: Wrap(
                    alignment: WrapAlignment.spaceEvenly,
                    spacing: 10,
                    children: [
                      buildPort("风机一", port1),
                      buildPort("风机二", port2),
                      buildPort("风机三", port3),
                    ],
                  ),
                )
              ]),
            ),
            SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
              child: SharedServiceInfo(),
            )
          ],
        ),
      ),
    );
  }
}
