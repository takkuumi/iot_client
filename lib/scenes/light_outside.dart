import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iot_client/ffi.dart';
import 'package:iot_client/utils/at_parse.dart';
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

  Timer? timer;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late String windSpeed = '亮度值:--\r\n报警值:--\r\n故障码:--';

  List<int> recoder = [0, 0, 0];

  void respHandler(String? resp) {
    List<int> data = parseLight(resp);

    for (int i = 0; i < data.length; i++) {
      if (data[i] != 0) {
        recoder[i] = data[i];
      }
    }

    setState(() {
      windSpeed = "亮度值:${data[0]}\r\n报警值:${data[1]}\r\n故障码:${data[2]}";
    });
  }

  void startTimer() {
    timer = Timer.periodic(timerDuration, (timer) async {
      String? resp = await readDevice(readAt("09C4"));
      respHandler(resp);
    });
  }

  @override
  void initState() {
    Future.sync(() => api.initTtySwk0(millis: 100));

    super.initState();
    startTimer();
    readDevice(readAt("09C4")).then(respHandler);
  }

  @override
  void dispose() {
    timer?.cancel();
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
      Uint8List data = await api.atNdrpt2(id: meshId, data: sdata);
      return String.fromCharCodes(data);
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
          child: Text("洞外光照"),
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        ),
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
                "images/icons/lght intensity detection@2x.png",
                width: 80,
                height: 80,
              ),
            ],
          ),
        ),
        Container(
          width: 100,
          height: 100,
          alignment: Alignment.center,
          child: Text(windSpeed),
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
          title: const Text('洞外光照'),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 50),
          child: Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 480,
                  padding: EdgeInsets.symmetric(horizontal: 50),
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
