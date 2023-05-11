import 'package:flutter/material.dart';
import 'package:iot_client/futs/hal.dart';

class Port {
  int sence;
  int q1;
  int q2;
  int i1;
  int q3;
  int q4;
  int i2;

  Port({
    required this.sence,
    required this.q1,
    required this.q2,
    required this.i1,
    required this.q3,
    required this.q4,
    required this.i2,
  });

  int get getSence => sence;

  int get getQ1 => q1 + 512;
  int get getQ2 => q2 + 512;

  int get getQ3 => q3 + 512;
  int get getQ4 => q4 + 512;

  int get getI1 => i1;
  int get getI2 => i2;

  // 长度为 8 的 list
  static Port fromList(List<int> list) {
    return Port(
      sence: list[1],
      q1: list[2],
      q2: list[3],
      i1: list[4],
      q3: list[5],
      q4: list[6],
      i2: list[7],
    );
  }

  static Port emptyPort() {
    return Port(
      sence: -1,
      q1: -1,
      q2: -1,
      i1: -1,
      q3: -1,
      q4: -1,
      i2: -1,
    );
  }
}

enum LaneIndicatorState { green, red }

final Color disableColor = Color.fromRGBO(221, 221, 221, 1);
final Widget verticalLineOnly = Container(
  height: 60,
  child: VerticalDivider(
    thickness: 2,
    color: Color.fromRGBO(0, 84, 216, 1),
  ),
);

final decoration = BoxDecoration(
  color: Color.fromRGBO(133, 225, 126, 1),
  borderRadius: BorderRadius.circular(4),
);

class LaneIndicatorUI extends StatefulWidget {
  String title;
  Port? port;
  LaneIndicatorUI({Key? key, required this.title, this.port}) : super(key: key);

  @override
  State<LaneIndicatorUI> createState() => LaneIndicatorUIState();
}

class LaneIndicatorUIState extends State<LaneIndicatorUI> {
  LaneIndicatorState state1 = LaneIndicatorState.red;
  LaneIndicatorState state2 = LaneIndicatorState.red;

  void mountedState(void Function() fn) {
    if (mounted) {
      setState(fn);
    }
  }

  Widget textTap(String t1, String t2) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 30,
            height: 16,
            decoration: decoration,
            alignment: Alignment.center,
            child: Text(
              t1,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 10),
            ),
          ),
          Container(
            height: 2,
          ),
          Container(
            width: 30,
            height: 16,
            decoration: decoration,
            alignment: Alignment.center,
            child: Text(
              t2,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 10),
            ),
          )
        ],
      ),
    );
  }

  Widget verticalLine() => Container(
        width: 100,
        height: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            textTap("IN1", "IN2"),
            VerticalDivider(
              thickness: 2,
              color: Color.fromRGBO(0, 84, 216, 1),
            ),
            textTap("OUT1", "OUT2"),
          ],
        ),
      );

  Widget verticalLine2() => Container(
        width: 100,
        height: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            textTap("IN3", "IN4"),
            VerticalDivider(
              thickness: 2,
              color: Color.fromRGBO(0, 84, 216, 1),
            ),
            textTap("OUT3", "OUT4"),
          ],
        ),
      );

  final BoxShadow boxShadow = BoxShadow(
    color: Colors.grey.withOpacity(0.5),
    spreadRadius: 5,
    blurRadius: 7,
    offset: const Offset(0, 3),
  );

  Widget buildLaneIndictorTitle(String text) {
    return Container(
      height: 50,
      width: 122,
      alignment: Alignment.center,
      child: Text(text, style: TextStyle(color: Color.fromRGBO(0, 84, 216, 1))),
      decoration: BoxDecoration(
        border: Border.all(
          width: 2,
          color: Color.fromRGBO(0, 84, 216, 1),
        ),
        borderRadius: BorderRadius.all(Radius.circular(25)),
      ),
    );
  }

  Widget buildOffState() {
    return Container(
      width: 100,
      height: 100,
      alignment: Alignment.center,
      child: Container(
        width: 100,
        height: 100,
        alignment: Alignment.center,
        child: Image.asset("images/light_inside/img_2@2x.png"),
      ),
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

  void updateState(List<bool> coils) {
    int? sence = widget.port?.getSence ?? -1;
    debugPrint("updateState: $sence");
    if (![1, 2, 3, 4, 5, 6, 7, 8, 9].contains(sence)) {
      return;
    }
    bool i1 = coils[widget.port?.getI1 ?? 0];
    bool i2 = coils[widget.port?.getI2 ?? 0];

    mountedState(() {
      state1 = i1 ? LaneIndicatorState.green : LaneIndicatorState.red;
      state2 = i2 ? LaneIndicatorState.green : LaneIndicatorState.red;
    });
  }

  void updatePort(Port port1) {
    debugPrint(
        "updatePort: ${port1.getSence} ${port1.getI1} ${port1.getI2} ${port1.getQ1} ${port1.getQ2} ${port1.getQ3} ${port1.getQ4}");
    widget.port = port1;
    mountedState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildLaneIndictorTitle(widget.title),
        verticalLineOnly,
        GestureDetector(
          onTap: () async {
            LaneIndicatorState nextState = state1 == LaneIndicatorState.green
                ? LaneIndicatorState.red
                : LaneIndicatorState.green;
            int? sence = widget.port?.getSence ?? -1;
            debugPrint("sence: $sence");
            if (![1, 2, 3, 4, 5, 6, 7, 8, 9].contains(sence)) {
              return;
            }
            if ([2, 3, 4, 5].contains(sence)) {
              if (nextState == LaneIndicatorState.green) {
                await setCoil(widget.port?.getQ1 ?? 512, true);
                await setCoil(widget.port?.getQ2 ?? 512, false);
              } else {
                await setCoil(widget.port?.getQ1 ?? 512, false);
                await setCoil(widget.port?.getQ2 ?? 512, true);
              }
            } else if ([6, 7, 8, 9].contains(sence)) {
              if (nextState == LaneIndicatorState.green) {
                await setCoil(widget.port?.getQ1 ?? 512, true);
                await setCoil(widget.port?.getQ2 ?? 512, false);
                await setCoil(widget.port?.getQ3 ?? 512, false);
                await setCoil(widget.port?.getQ4 ?? 512, true);
              } else {
                await setCoil(widget.port?.getQ1 ?? 512, false);
                await setCoil(widget.port?.getQ2 ?? 512, true);
                await setCoil(widget.port?.getQ3 ?? 512, true);
                await setCoil(widget.port?.getQ4 ?? 512, false);
              }
            }
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
        verticalLine(),
        GestureDetector(
          onTap: () async {
            LaneIndicatorState nextState = state2 == LaneIndicatorState.green
                ? LaneIndicatorState.red
                : LaneIndicatorState.green;

            int? sence = widget.port?.getSence;
            if (sence == null && ![1, 2, 3, 4, 5, 6, 7, 8, 9].contains(sence)) {
              return;
            }
            if ([2, 3, 4, 5].contains(sence)) {
              if (nextState == LaneIndicatorState.green) {
                await setCoil(widget.port?.getQ3 ?? 512, true);
                await setCoil(widget.port?.getQ4 ?? 512, false);
              } else {
                await setCoil(widget.port?.getQ3 ?? 512, false);
                await setCoil(widget.port?.getQ4 ?? 512, true);
              }
            } else if ([6, 7, 8, 9].contains(sence)) {
              if (nextState == LaneIndicatorState.green) {
                await setCoil(widget.port?.getQ1 ?? 512, false);
                await setCoil(widget.port?.getQ2 ?? 512, true);
                await setCoil(widget.port?.getQ3 ?? 512, true);
                await setCoil(widget.port?.getQ4 ?? 512, false);
              } else {
                await setCoil(widget.port?.getQ1 ?? 512, true);
                await setCoil(widget.port?.getQ2 ?? 512, false);
                await setCoil(widget.port?.getQ3 ?? 512, false);
                await setCoil(widget.port?.getQ4 ?? 512, true);
              }
            }
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
        verticalLine2(),
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
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
