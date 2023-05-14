import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:iot_client/futs/hal.dart';
import 'package:iot_client/scenes/widgets/shared_service_info.dart';

import '../constants.dart';

class WindSpeed extends StatefulWidget {
  const WindSpeed({Key? key}) : super(key: key);

  @override
  State<WindSpeed> createState() => _WindSpeedState();
}

class _WindSpeedState extends State<WindSpeed> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldMessengerState> key =
      GlobalKey<ScaffoldMessengerState>(debugLabel: 'wind_speed');

  late TabController tabController;
  Future<String?> sn = Future.value(null);
  Future<String?> ip = Future.value(null);

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  late AnimationController animationController;

  Timer? timer;

  late String windSpeed1 = '--';
  late String windSpeed2 = '--';
  late String windSpeed3 = '--';
  late String windSpeed4 = '--';

  List<int> recoder = [0, 0, 0, 0];

  void respHandler(List<int> data) {
    for (int i = 0; i < data.length; i++) {
      if (data[i] != 0) {
        recoder[i] = data[i];
      }
    }

    setState(() {
      windSpeed1 = "${recoder[0] / 100} m/s";
      windSpeed2 = "${recoder[1]}";
      windSpeed3 = "${recoder[2] / 100} m/s";
      windSpeed4 = "${recoder[3]}";
    });
  }

  void startTimer() {
    timer = Timer.periodic(timerDuration, (timer) async {
      List<int> resp = await getHoldings(2510, 4);
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

    animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    animationController.repeat(min: 0.0, max: 1.0);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      startTimer();
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    animationController.dispose();

    super.dispose();
  }

  final BoxShadow boxShadow = BoxShadow(
    color: Colors.grey.withOpacity(0.5),
    spreadRadius: 5,
    blurRadius: 7,
    offset: const Offset(0, 3),
  );

  final Color disableColor = Color.fromRGBO(221, 221, 221, 1);

  BoxDecoration decoration = BoxDecoration(
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
                color: color,
              ),
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
            createStack("风速:", windSpeed1, Colors.greenAccent),
            createStack("风向:", windSpeed2, Colors.greenAccent),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            createStack("报警值:", windSpeed3, Colors.yellowAccent),
            createStack("故障码:", windSpeed4, Colors.redAccent),
          ],
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
          title: const Text('风速风向'),
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
                        "images/icons/fan_banner.png",
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
