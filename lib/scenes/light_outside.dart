import 'dart:async';
import 'dart:typed_data';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iot_client/ffi.dart';
import 'package:iot_client/futs/hal.dart';
import 'package:iot_client/utils/at_parse.dart';
import 'package:iot_client/views/components/banner.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

class LightOutside extends StatefulWidget {
  const LightOutside({Key? key}) : super(key: key);

  @override
  State<LightOutside> createState() => _LightOutsideState();
}

class _LightOutsideState extends State<LightOutside>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldMessengerState> key =
      GlobalKey<ScaffoldMessengerState>(debugLabel: 'light_outside');

  late TabController tabController;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<String?> sn = Future.value(null);
  Future<String?> ip = Future.value(null);
  void tabListener() {
    if (tabController.index == 0) {
      startTimer();
      readDevice(readAt("09C4")).then(respHandler);
    }
    if (tabController.index == 1) {
      _prefs.then((SharedPreferences prefs) {
        return prefs.getString('mesh');
      }).then((String? meshId) async {
        if (meshId != null) {
          List<int> snData = await getHoldings(meshId, 2196, 9);
          Uint8List v = Uint16List.fromList(snData).buffer.asUint8List();
          setState(() {
            sn = Future.value(String.fromCharCodes(v));
          });

          List<int> ipData = await getHoldings(meshId, 2247, 4);
          setState(() {
            ip = Future.value(ipData.join('.'));
          });
        }
      });
    }
  }

  Timer? timer;
  late String windSpeed = '亮度值:--\r\n报警值:--\r\n故障码:--';

  late String windSpeed1 = '--';
  late String windSpeed2 = '--';
  late String windSpeed3 = '--';

  List<int> recoder = [0, 0, 0];

  void respHandler(String? resp) {
    List<int> data = parseLight(resp);

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
      // 09C4 洞外
      String? resp = await readDevice(readAt("09C4"));
      respHandler(resp);
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  String readAt(String addr) {
    // 010F020000030105
    return "0103${addr}0003";
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
          await api.bleAtNdrpt(id: meshId, data: sdata, retry: 5);
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
      crossAxisAlignment: CrossAxisAlignment.center,
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
                "images/icons/sun.png",
                width: 120,
                height: 120,
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
                      "亮度值:",
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
                      "告警值:",
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
                      windSpeed3,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.yellowAccent),
                    ),
                  ])),
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
          title: const Text('洞外光强'),
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
      ),
    );
  }
}
