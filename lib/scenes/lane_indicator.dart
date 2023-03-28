import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:iot_client/device.dart';
import 'package:iot_client/ffi.dart';
import 'package:iot_client/scenes/widgets/lane_indicator_components.dart';
import 'package:iot_client/utils/at_parse.dart';
import 'package:iot_client/utils/tool.dart';
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
    Future.sync(() => api.initTtySwk0(millis: 100));

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
    if (state == 0) {
      setState(() {
        state1 = LaneIndicatorState.red;
        state2 = LaneIndicatorState.red;
      });
    }
    if (state == 1) {
      setState(() {
        state1 = LaneIndicatorState.green;
        state2 = LaneIndicatorState.red;
      });
    }
    if (state == 4) {
      setState(() {
        state1 = LaneIndicatorState.red;
        state2 = LaneIndicatorState.green;
      });
    }
    if (state == 5) {
      setState(() {
        state1 = LaneIndicatorState.green;
        state2 = LaneIndicatorState.green;
      });
    }
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
    String data = state == LaneIndicatorState.green ? '01' : '00';
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

    Uint8List data =
        await Future.sync(() => api.atNdrpt2(id: meshId, data: sdata));
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

    Uint8List x0200Data = await api.atNdrpt2(id: meshId, data: x0200);

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
        verticalLine,
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
            bool failed = false;
            await Future.delayed(
              const Duration(milliseconds: 200),
              () => readDevice(
                readAt("0200"),
                initLaneState,
                () {
                  failed = true;
                },
              ),
            );
            if (failed) {
              await Future.delayed(
                  const Duration(milliseconds: 200),
                  () => readDevice(readAt("0200"), initLaneState,
                      () => showSnackBar("操作失败,未收到响应", key)));
            }
            await EasyLoading.dismiss();
          },
          child: Container(
            width: 100,
            height: 100,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                width: 2,
                color: state1 == LaneIndicatorState.green
                    ? Colors.greenAccent
                    : Colors.redAccent,
              ),
              borderRadius: BorderRadius.circular(50),
              boxShadow: [boxShadow],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  state1 == LaneIndicatorState.green
                      ? Icons.arrow_upward
                      : Icons.clear,
                  size: 60,
                  color: state1 == LaneIndicatorState.green
                      ? Colors.greenAccent
                      : Colors.redAccent,
                )
              ],
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
            bool failed = false;
            await Future.delayed(
              const Duration(milliseconds: 200),
              () => readDevice(
                readAt("0200"),
                initLaneState,
                () {
                  failed = true;
                },
              ),
            );
            if (failed) {
              await Future.delayed(
                  const Duration(milliseconds: 200),
                  () => readDevice(readAt("0200"), initLaneState,
                      () => showSnackBar("操作失败,未收到响应", key)));
            }

            await EasyLoading.dismiss();
          },
          child: Container(
            width: 100,
            height: 100,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                width: 2,
                color: state2 == LaneIndicatorState.green
                    ? Colors.greenAccent
                    : Colors.redAccent,
              ),
              borderRadius: BorderRadius.circular(50),
              boxShadow: [boxShadow],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  state2 == LaneIndicatorState.green
                      ? Icons.arrow_upward
                      : Icons.clear,
                  size: 60,
                  color: state2 == LaneIndicatorState.green
                      ? Colors.greenAccent
                      : Colors.redAccent,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget createLane2() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildLaneIndictorTitle("车道二"),
        verticalLine,
        buildOffState(),
        verticalLine,
        buildOffState(),
        Container(
          margin: EdgeInsets.only(top: 20),
          child: ElevatedButton(
            // onPressed: () => writeDevice(atOpen("0200"), true),
            onPressed: null,
            child: Text("打开"),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 5),
          child: ElevatedButton(
            // onPressed: () => writeDevice(atClose("0200"), false),
            onPressed: null,
            child: Text("关闭"),
          ),
        ),
      ],
    );
  }

  Widget createLane3() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildLaneIndictorTitle("车道三"),
        verticalLine,
        buildOffState(),
        verticalLine,
        buildOffState(),
        Container(
          margin: EdgeInsets.only(top: 20),
          child: ElevatedButton(
            // onPressed: () => writeDevice(atOpen("0200"), true),
            onPressed: null,
            child: Text("打开"),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 5),
          child: ElevatedButton(
            // onPressed: () => writeDevice(atClose("0200"), false),
            onPressed: null,
            child: Text("关闭"),
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
