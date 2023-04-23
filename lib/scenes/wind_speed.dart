import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iot_client/ffi.dart';
import 'package:iot_client/utils/at_parse.dart';
import 'package:iot_client/views/components/banner.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

class WindSpeed extends StatefulWidget {
  const WindSpeed({Key? key}) : super(key: key);

  @override
  State<WindSpeed> createState() => _WindSpeedState();
}

class _WindSpeedState extends State<WindSpeed>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldMessengerState> key =
      GlobalKey<ScaffoldMessengerState>(debugLabel: 'wind_speed');

  late AnimationController animationController;

  Timer? timer;

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  late String windSpeed1 = '--';
  late String windSpeed2 = '--';
  late String windSpeed3 = '--';
  late String windSpeed4 = '--';

  List<int> recoder = [0, 0, 0, 0];

  void respHandler(String? resp) {
    List<int> data = parseWindSpreed(resp);

    for (int i = 0; i < data.length; i++) {
      if (data[i] != 0) {
        recoder[i] = data[i];
      }
    }

    setState(() {
      windSpeed1 = "${recoder[0] / 10} m/s";
      windSpeed2 = "${recoder[1]}";
      windSpeed3 = "${recoder[2] / 10} m/s";
      windSpeed4 = "${recoder[3]}";
    });
  }

  void startTimer() {
    timer = Timer.periodic(timerDuration, (timer) async {
      String? resp = await readDevice(readAt("09CE"));
      respHandler(resp);
    });
  }

  @override
  void initState() {
    animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    animationController.repeat(min: 0.0, max: 1.0);

    super.initState();
    startTimer();
    readDevice(readAt("09CE")).then(respHandler);
  }

  @override
  void dispose() {
    debugPrint("wind_speed dispose");
    timer?.cancel();
    animationController.dispose();

    super.dispose();
  }

  String readAt(String addr) {
    // 010F020000030105
    return "0103${addr}0004";
  }

  Future<String?> getLink() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString('mesh');
  }

  Future<String?> readDevice(
    String sdata,
  ) async {
    String? meshId = await getLink();

    if (meshId == null || meshId.isEmpty) {
      return null;
    }

    try {
      SerialResponse response =
          await api.atNdrpt(id: meshId, data: sdata, retry: 5);
      Uint8List? data = response.data;
      if (data != null) {
        return String.fromCharCodes(data);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
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
              RotationTransition(
                turns: Tween(begin: 0.0, end: 1.0).animate(animationController),
                child: Image.asset(
                  "images/icons/wind speed and direction@2x.png",
                  width: 120,
                  height: 120,
                ),
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
              Container(
                  height: 40,
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(children: [
                    Text(
                      "风速:",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      windSpeed1,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.greenAccent),
                    ),
                  ])),
              Container(
                  height: 40,
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(children: [
                    Text(
                      "风向:",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      windSpeed2,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.greenAccent),
                    ),
                  ])),
            ],
          ),
        ),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  height: 40,
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(children: [
                    Text(
                      "报警值:",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      windSpeed3,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.yellowAccent),
                    ),
                  ])),
              Container(
                  height: 40,
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(children: [
                    Text(
                      "故障码:",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      windSpeed4,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.redAccent,
                      ),
                    ),
                  ])),
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
          title: const Text('风速风向'),
        ),
        body: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: CarouselSlider(
                    options: CarouselOptions(
                      aspectRatio: 16 / 10,
                      enlargeCenterPage: true,
                      scrollDirection: Axis.horizontal,
                      autoPlay: true,
                      height: 260,
                    ),
                    items: createImageSliders(),
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
      ),
    );
  }
}
