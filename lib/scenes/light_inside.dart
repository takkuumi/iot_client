import 'dart:async';
import 'dart:typed_data';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iot_client/scenes/widgets/shared_service_info.dart';
import 'package:iot_client/utils/at_parse.dart';
import 'package:iot_client/views/components/banner.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../futs/hal.dart';

class LightInside extends StatefulWidget {
  const LightInside({Key? key}) : super(key: key);

  @override
  State<LightInside> createState() => _LightInsideState();
}

class _LightInsideState extends State<LightInside>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldMessengerState> key =
      GlobalKey<ScaffoldMessengerState>(debugLabel: 'light_outside');

  late TabController tabController;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<String?> sn = Future.value(null);
  Future<String?> ip = Future.value(null);

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Timer? timer;
  late String windSpeed = '亮度值:--\r\n报警值:--\r\n故障码:--';

  late String windSpeed1 = '--';
  late String windSpeed2 = '--';
  late String windSpeed3 = '--';

  List<int> recoder = [0, 0, 0];

  void respHandler(List<int> data) {
    for (int i = 0; i < data.length; i++) {
      if (data[i] != 0) {
        recoder[i] = data[i];
      }
    }
    setState(() {
      windSpeed1 = "${recoder[0]} lux";
      windSpeed2 = "${recoder[1]} lux";
      windSpeed3 = "${recoder[2]}";
    });
  }

  void startTimer() {
    timer = Timer.periodic(timerDuration, (timer) async {
      List<int> resp = await getHoldings(2504, 3);
      debugPrint("wind_speed dispose");
      if (resp.isNotEmpty) {
        respHandler(resp);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    tabController.animateTo(0);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      startTimer();
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  final BoxShadow boxShadow = BoxShadow(
    color: Colors.grey.withOpacity(0.5),
    spreadRadius: 5,
    blurRadius: 7,
    offset: const Offset(0, 3),
  );

  final Color disableColor = Color.fromRGBO(221, 221, 221, 1);

  final decoration = BoxDecoration(
    color: Colors.white,
    border: Border.all(
      width: 2,
      color: Colors.greenAccent,
    ),
    borderRadius: BorderRadius.circular(75),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.5),
        spreadRadius: 5,
        blurRadius: 7,
        offset: const Offset(0, 3),
      )
    ],
  );

  Widget createStack(String title, String value, Color color) {
    return Container(
      width: 150,
      height: 150,
      decoration:
          decoration.copyWith(border: Border.all(width: 2, color: color)),
      margin: EdgeInsets.only(bottom: 30),
      alignment: Alignment.center,
      child: Container(
          height: 40,
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Column(children: [
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            Text(
              value,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.greenAccent),
            ),
          ])),
    );
  }

  Widget createLane1() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            createStack("故障码:", windSpeed3, Colors.redAccent),
            // createStack("VI报警值:", windSpeed4),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            createStack("亮度值:", windSpeed1, Colors.greenAccent),
            createStack("告警值:", windSpeed2, Colors.yellow),
          ],
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
          title: const Text('洞内光强'),
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
                      child: Wrap(
                        alignment: WrapAlignment.spaceEvenly,
                        spacing: 40,
                        children: [
                          createLane1(),
                        ],
                      ),
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
