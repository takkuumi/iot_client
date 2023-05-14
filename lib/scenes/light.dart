import 'dart:typed_data';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:iot_client/futs/hal.dart';
import 'package:iot_client/model/logic.dart';
import 'package:iot_client/scenes/widgets/shared_service_info.dart';
import 'package:iot_client/scenes/widgets/util.dart';
import 'package:iot_client/views/components/banner.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Light extends StatefulWidget {
  const Light({Key? key}) : super(key: key);

  @override
  State<Light> createState() => _LightState();
}

class _LightState extends State<Light> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldMessengerState> key =
      GlobalKey<ScaffoldMessengerState>(debugLabel: 'light');

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

    if (states == null) {
      return;
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

        List<Logic> v = logics.where((e) => e.scene < 10).toList();

        for (int i = 0; i < v.length; i++) {
          final logic = v[i];
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

  Widget createLane1() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 150,
          height: 150,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              width: 2,
              color: Colors.greenAccent,
            ),
            borderRadius: BorderRadius.circular(75),
            boxShadow: [boxShadow],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "images/icons/light_outside.png",
                width: 100,
                height: 100,
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                child: Text("开灯"),
                onPressed: () {},
              ),
              Container(
                width: 15,
              ),
              ElevatedButton(
                child: Text("关灯"),
                onPressed: () {},
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              createSig('远程信号：', '无'),
              createSig('运行信号：', '无'),
              createSig('故障信号：', '无'),
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
          title: const Text('照明'),
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
              child: Container(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: double.infinity,
                      child: Image.asset(
                        "images/banner/img_3@2x.png",
                        height: 200,
                        fit: BoxFit.fitWidth,
                        gaplessPlayback: true,
                      ),
                    ),
                    Container(
                      width: 510,
                      padding: EdgeInsets.symmetric(vertical: 60),
                      child: createLane1(),
                    ),
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
      ),
    );
  }
}
