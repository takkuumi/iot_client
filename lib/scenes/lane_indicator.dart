import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:iot_client/ffi.dart';
import 'package:iot_client/scenes/widgets/lane_indicator_components.dart';
import 'package:iot_client/utils/at_parse.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

class LaneIndicator extends StatefulWidget {
  const LaneIndicator({Key? key}) : super(key: key);

  @override
  State<LaneIndicator> createState() => _LaneIndicatorState();
}

enum LaneIndicatorState { green, red }

class _LaneIndicatorState extends State<LaneIndicator> {
  final GlobalKey<ScaffoldMessengerState> key =
      GlobalKey<ScaffoldMessengerState>(debugLabel: 'lane_indicator');

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  LaneIndicatorState state1 = LaneIndicatorState.red;
  LaneIndicatorState state2 = LaneIndicatorState.red;

  @override
  void initState() {
    super.initState();

    readDevice(
      readAt("0200"),
      initLaneState,
      () {
        debugPrint("error");
      },
    );
  }

  void initLaneState(int? state) {
    debugPrint("----------------------->$state");
    // 0 1 1 0 06
    if (state == 6) {
      setState(() {
        state1 = LaneIndicatorState.red;
        state2 = LaneIndicatorState.green;
      });
      return;
    }

    // 1 0 0 1 09
    if (state == 9) {
      setState(() {
        state1 = LaneIndicatorState.green;
        state2 = LaneIndicatorState.red;
      });
      return;
    }

    // 0 1 0 1  OA
    if (state == 10) {
      setState(() {
        state1 = LaneIndicatorState.red;
        state2 = LaneIndicatorState.red;
      });
      return;
    }

    // 1 0 1 0
    if (state == 5) {
      setState(() {
        state1 = LaneIndicatorState.green;
        state2 = LaneIndicatorState.green;
      });
      return;
    }

    setState(() {
      state1 = LaneIndicatorState.red;
      state2 = LaneIndicatorState.red;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<String?> getLink() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString('mesh');
  }

  String readAt(String addr) {
    // 010F020000030105
    return "0101${addr}0004";
  }

  String sendAt(String addr, LaneIndicatorState state) {
    // 04 0100
    //    0001
    String data = state == LaneIndicatorState.green ? '01' : '02';
    // 010F020000030105
    return "010F${addr}000201$data";
  }

  Future<void> readDevice(
    String sdata,
    void Function(int) onReadResponse,
    void Function() onError,
  ) async {
    String? meshId = await getLink();

    if (meshId == null || meshId.isEmpty) {
      return;
    }

    SerialResponse response =
        await api.bleAtNdrpt(id: meshId, data: sdata, retry: 5);
    Uint8List? data = response.data;
    if (data == null) {
      onError();
      return;
    }

    String resp = String.fromCharCodes(data);

    int? res = getAtReadResult(resp);
    if (res != null) {
      onReadResponse(res);
    } else {
      onError();
    }
  }

  void syncState() {
    readDevice(
      readAt("0200"),
      initLaneState,
      () => showSnackBar("操作失败,未收到响应", key),
    );
  }

  Future<void> writeDevice(
    String x0200,
    void Function() onError,
  ) async {
    String? meshId = await getLink();

    if (meshId == null || meshId.isEmpty) {
      showSnackBar("未设置连接设备", key);
      return;
    }

    SerialResponse response =
        await api.bleAtNdrpt(id: meshId, data: x0200, retry: 5);
    Uint8List? x0200Data = response.data;
    if (x0200Data == null) {
      onError();
      return;
    }
    String resp = String.fromCharCodes(x0200Data);
    debugPrint(resp);
    bool isOk = getAtOk(resp);
    if (!isOk) {
      onError();
    }
  }

  final BoxShadow boxShadow = BoxShadow(
    color: Colors.grey.withOpacity(0.5),
    spreadRadius: 5,
    blurRadius: 7,
    offset: const Offset(0, 3),
  );

  Widget createLane1() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildLaneIndictorTitle("车道一"),
        verticalLineOnly,
        GestureDetector(
          onTap: () async {
            await EasyLoading.show(
              status: '正在下发操作...',
              maskType: EasyLoadingMaskType.black,
            );
            LaneIndicatorState nextState = state1 == LaneIndicatorState.green
                ? LaneIndicatorState.red
                : LaneIndicatorState.green;

            String data = sendAt("0200", nextState);
            debugPrint(data);
            await writeDevice(data, () => showSnackBar("操作失败,未收到响应", key));
            await readDevice(
              readAt("0200"),
              initLaneState,
              () {
                showSnackBar("操作失败,未收到响应", key);
              },
            );
            await EasyLoading.dismiss();
          },
          child: Container(
            width: 100,
            height: 100,
            alignment: Alignment.center,
            child: Image.asset(
              state1 == LaneIndicatorState.green
                  ? "images/light_inside/img_1@2x.png"
                  : "images/light_inside/img_3@2x.png",
            ),
          ),
        ),
        verticalLine,
        GestureDetector(
          onTap: () async {
            await EasyLoading.show(
              status: '正在下发操作...',
              maskType: EasyLoadingMaskType.black,
            );
            LaneIndicatorState nextState = state2 == LaneIndicatorState.green
                ? LaneIndicatorState.red
                : LaneIndicatorState.green;

            String data = sendAt("0202", nextState);

            await writeDevice(data, () => {showSnackBar("操作失败,未收到响应", key)});

            await readDevice(
              readAt("0200"),
              initLaneState,
              () {
                showSnackBar("操作失败,未收到响应", key);
              },
            );

            await EasyLoading.dismiss();
          },
          child: Container(
            width: 100,
            height: 100,
            alignment: Alignment.center,
            child: Container(
              width: 100,
              height: 100,
              alignment: Alignment.center,
              child: Image.asset(
                state2 == LaneIndicatorState.green
                    ? "images/light_inside/img_1@2x.png"
                    : "images/light_inside/img_3@2x.png",
              ),
            ),
          ),
        ),
        verticalLine2,
        Container(
          width: 90,
          height: 32,
          decoration: BoxDecoration(
            color: Color.fromRGBO(0, 84, 216, 1),
            borderRadius: BorderRadius.circular(16),
          ),
          alignment: Alignment.center,
          child: Text(
            getState(),
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white, fontSize: 17, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }

  String getState() {
    if (state1 == LaneIndicatorState.green &&
        state2 == LaneIndicatorState.red) {
      return "正行";
    }
    if (state1 == LaneIndicatorState.red &&
        state2 == LaneIndicatorState.green) {
      return "逆行";
    }

    return "禁行";
  }

  Widget createLane2() {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      buildLaneIndictorTitle("车道二"),
      verticalLineOnly,
      buildOffState(),
      verticalLine,
      buildOffState(),
      verticalLine2,
      Container(
        width: 90,
        height: 32,
        decoration: BoxDecoration(
          color: Color.fromRGBO(197, 197, 197, 1),
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.center,
        child: Text(
          "无",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
        ),
      ),
    ]);
  }

  Widget createLane3() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildLaneIndictorTitle("车道三"),
        verticalLineOnly,
        buildOffState(),
        verticalLine,
        buildOffState(),
        verticalLine2,
        Container(
          width: 90,
          height: 32,
          decoration: BoxDecoration(
            color: Color.fromRGBO(197, 197, 197, 1),
            borderRadius: BorderRadius.circular(16),
          ),
          alignment: Alignment.center,
          child: Text(
            "无",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
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
          title: const Text('车道指示器'),
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
                  width: 600,
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Wrap(
                    alignment: WrapAlignment.spaceEvenly,
                    spacing: 10,
                    children: [
                      createLane1(),
                      createLane2(),
                      createLane2(),
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
