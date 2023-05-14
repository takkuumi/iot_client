import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iot_client/futs/hal.dart';
import 'package:iot_client/model/logic.dart';
import 'package:iot_client/model/port.dart';
import 'package:iot_client/provider/app_provider.dart';
import 'package:iot_client/scenes/widgets/shared_service_info.dart';
import 'package:iot_client/scenes/widgets/util.dart';

enum DoorStat {
  open,
  close,
  stop,
}

class Door extends StatefulHookConsumerWidget {
  const Door({Key? key}) : super(key: key);

  @override
  DoorState createState() => DoorState();
}

class DoorState extends ConsumerState<Door> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldMessengerState> key =
      GlobalKey<ScaffoldMessengerState>(debugLabel: 'door');

  late TabController tabController;

  DoorStat stat = DoorStat.stop;

  Port? port;

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Future<void> tabListener() async {
    EasyLoading.dismiss();
    if (tabController.indexIsChanging) {
      if (tabController.index == 0) {
        await refresh();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, initialIndex: 0, vsync: this);
    tabController.addListener(tabListener);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.watch(appReadWriteCoilsProvider.notifier).addListener((state) {
        if (mounted) {
          List<bool> coils = ref.read(appReadCoilsProvider);
          if (coils.isNotEmpty && state.isNotEmpty) {
            updateState(coils, state);
          }
        }
      });
      try {
        List<Logic> logics = await readLogicControlSetting();

        List<Logic> v = logics.where((e) => e.scene == 13).toList();
        if (v.isNotEmpty) {
          final Logic logic = v[0];
          port = Port.fromList(logic.scene, logic.values);
        }

        await refresh();
      } catch (err) {
        EasyLoading.showError(err.toString());
      }
    });
  }

  Future<void> updateState(List<bool> rCoils, List<bool> rwCoils) async {
    int sence = port?.getSence ?? -1;
    debugPrint("updateState: $sence");
    if (13 != sence) {
      return;
    }

    bool st1 = rCoils[port?.p3 ?? 0];
    bool st2 = rCoils[port?.p4 ?? 0];
    bool st3 = rCoils[port?.p5 ?? 0];

    if (st1) {
      stat = DoorStat.open;
    }

    if (st2) {
      stat = DoorStat.close;
    }

    if (st3) {
      stat = DoorStat.stop;
    }

    setState(() {});
  }

  Future<void> refresh() async {
    try {
      List<bool>? rCoils = await getCoils(0, 24);
      if (rCoils != null) {
        ref.read(appReadCoilsProvider.notifier).change(rCoils);
      }
      List<bool>? rwCoils = await getCoils(512, 24);
      if (rwCoils != null) {
        ref.read(appReadWriteCoilsProvider.notifier).change(rwCoils);
      }
    } catch (err) {
      EasyLoading.showError(err.toString());
    }
  }

  final BoxShadow boxShadow = BoxShadow(
    color: Colors.grey.withOpacity(0.5),
    spreadRadius: 5,
    blurRadius: 7,
    offset: const Offset(0, 3),
  );

  final Color disableColor = Color.fromRGBO(221, 221, 221, 1);

  String buildImage(DoorStat s) {
    if (s == DoorStat.open) {
      return "images/icons/door_open.png";
    }
    if (s == DoorStat.close) {
      return "images/icons/door_close.png";
    }
    return "images/icons/door_half_open.png";
  }

  Widget createLane1() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 300,
          height: 300,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              width: 2,
              color: Colors.greenAccent,
            ),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [boxShadow],
          ),
          child: Image.asset(
            buildImage(stat),
            width: 270,
            height: 270,
          ),
        ),
        Container(
          width: 400,
          margin: EdgeInsets.symmetric(vertical: 15),
          child: Row(
            children: [
              createSig('开到位信号：', stat == DoorStat.open ? '开启' : ''),
              Spacer(),
              createSig('关到位信号：', stat == DoorStat.close ? '关闭' : ''),
              Spacer(),
              createSig('停止信号：', stat == DoorStat.stop ? '停止' : ''),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                child: Text("开门"),
                onPressed: () async {
                  await setCoil(port?.getP0 ?? 512, true);
                  await setCoil(port?.getP1 ?? 512, false);
                  await setCoil(port?.getP2 ?? 512, false);
                  await refresh();
                },
              ),
              Container(
                width: 15,
              ),
              ElevatedButton(
                child: Text("关门"),
                onPressed: () async {
                  await setCoil(port?.getP0 ?? 512, false);
                  await setCoil(port?.getP1 ?? 512, true);
                  await setCoil(port?.getP2 ?? 512, false);
                  await refresh();
                },
              ),
              Container(
                width: 15,
              ),
              ElevatedButton(
                child: Text("停止"),
                onPressed: () async {
                  await setCoil(port?.getP0 ?? 512, false);
                  await setCoil(port?.getP1 ?? 512, false);
                  await setCoil(port?.getP2 ?? 512, true);
                  await refresh();
                },
              ),
            ],
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
          title: const Text('卷闸门'),
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
                    "images/banner/img_1@2x.png",
                    height: 200,
                    fit: BoxFit.fitWidth,
                    gaplessPlayback: true,
                  ),
                ),
                Container(
                  width: 470,
                  padding: EdgeInsets.only(top: 10),
                  child: port == null
                      ? Container(
                          alignment: Alignment.center,
                          child: Text("未读取到卷帘门逻辑"),
                        )
                      : createLane1(),
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
