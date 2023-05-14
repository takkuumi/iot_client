import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:iot_client/futs/hal.dart';
import 'package:iot_client/model/logic.dart';
import 'package:iot_client/model/port.dart';
import 'package:iot_client/scenes/widgets/shared_service_info.dart';
import 'package:iot_client/scenes/widgets/util.dart';

enum TrafficLightStat { green, red, right, yellow, off }

class TrafficLight extends StatefulWidget {
  const TrafficLight({Key? key}) : super(key: key);

  @override
  State<TrafficLight> createState() => _TrafficLightState();
}

class _TrafficLightState extends State<TrafficLight>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldMessengerState> key =
      GlobalKey<ScaffoldMessengerState>(debugLabel: 'traffic_light');

  late TabController tabController;
  TrafficLightStat stat = TrafficLightStat.off;

  Port? port;

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
    if (port == null) {
      return;
    }
    List<bool>? states = await getCoils(0, 24);

    if (states == null || states.isEmpty) {
      return;
    }

    bool s1 = states[port?.p4 ?? 0];
    bool s2 = states[port?.p5 ?? 0];
    bool s3 = states[port?.p6 ?? 0];
    bool s4 = states[port?.p7 ?? 0];

    if (s1) {
      stat = TrafficLightStat.right;
    }

    if (s2) {
      stat = TrafficLightStat.green;
    }

    if (s3) {
      stat = TrafficLightStat.red;
    }

    if (s4) {
      stat = TrafficLightStat.yellow;
    }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, initialIndex: 0, vsync: this);
    tabController.addListener(tabListener);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        List<Logic> logics = await readLogicControlSetting();

        List<Logic> v = logics.where((e) => e.scene == 10).toList();
        if (v.isNotEmpty) {
          final Logic logic = v[0];
          port = Port.fromList(logic.scene, logic.values);
        }

        setState(() {});
        await initMainState();
      } catch (err) {
        EasyLoading.showError(err.toString());
      }
    });
  }

  final BoxShadow boxShadow = BoxShadow(
    color: Colors.grey.withOpacity(0.5),
    spreadRadius: 5,
    blurRadius: 7,
    offset: const Offset(0, 3),
  );

  final Color disableColor = Color.fromRGBO(221, 221, 221, 1);

  final Widget verticalLine = Container(
    height: 20,
    child: VerticalDivider(
      thickness: 2,
      color: Color.fromRGBO(192, 192, 192, 1),
    ),
  );

  String buildImage(TrafficLightStat? state) {
    if (state == TrafficLightStat.green) {
      return "images/icons/traffic_light_green.png";
    }
    if (state == TrafficLightStat.red) {
      return "images/icons/traffic_light_red.png";
    }

    if (state == TrafficLightStat.right) {
      return "images/icons/traffic_light1.png";
    }

    if (state == TrafficLightStat.yellow) {
      return "images/icons/traffic_light_yellow.png";
    }

    return "images/icons/traffic_light_off.png";
  }

  Widget createLane1() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          height: 190 * 2,
          alignment: Alignment.center,
          child: Image.asset(
            buildImage(stat),
            fit: BoxFit.cover,
            gaplessPlayback: true,
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              createSig('左箭信号：', '无'),
              createSig('红灯信号：', '无'),
              createSig('黄灯信号：', '无'),
              createSig('绿灯信号：', '无'),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                child: Text('左箭控制'),
                onPressed: () async {
                  await setCoil(port?.getP0 ?? 512, true);
                  await setCoil(port?.getP1 ?? 512, false);
                  await setCoil(port?.getP2 ?? 512, false);
                  await setCoil(port?.getP3 ?? 512, false);
                  await initLaneState();
                },
              ),
              ElevatedButton(
                  child: Text('绿灯控制'),
                  onPressed: () async {
                    await setCoil(port?.getP0 ?? 512, false);
                    await setCoil(port?.getP1 ?? 512, true);
                    await setCoil(port?.getP2 ?? 512, false);
                    await setCoil(port?.getP3 ?? 512, false);
                    await initLaneState();
                  }),
              ElevatedButton(
                  child: Text('红灯控制'),
                  onPressed: () async {
                    await setCoil(port?.getP0 ?? 512, false);
                    await setCoil(port?.getP1 ?? 512, false);
                    await setCoil(port?.getP2 ?? 512, true);
                    await setCoil(port?.getP3 ?? 512, false);
                    await initLaneState();
                  }),
              ElevatedButton(
                  child: Text('黄灯控制'),
                  onPressed: () async {
                    await setCoil(port?.getP0 ?? 512, false);
                    await setCoil(port?.getP1 ?? 512, false);
                    await setCoil(port?.getP2 ?? 512, false);
                    await setCoil(port?.getP3 ?? 512, true);
                    await initLaneState();
                  }),
            ],
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: key,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('交通信号灯'),
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
            Container(
              width: 490,
              margin: EdgeInsets.only(top: 50),
              child: createLane1(),
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
