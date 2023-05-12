import 'package:flutter/material.dart';
import 'package:iot_client/futs/hal.dart';

class Port {
  int sence;
  int p0;
  int p1;
  int p2;
  int p3;
  int p4;
  int p5;
  int p6;
  int p7;
  int p8;
  int p9;

  Port({
    required this.sence,
    required this.p0,
    required this.p1,
    required this.p2,
    required this.p3,
    required this.p4,
    required this.p5,
    required this.p6,
    required this.p7,
    required this.p8,
    required this.p9,
  });

  int get getSence => sence;

  int get getP0 => p0 + 512;
  int get getP1 => p1 + 512;
  int get getP2 => p2 + 512;
  int get getP3 => p3 + 512;
  int get getP4 => p4 + 512;
  int get getP5 => p5 + 512;
  int get getP6 => p6 + 512;
  int get getP7 => p7 + 512;
  int get getP8 => p8 + 512;
  int get getP9 => p9 + 512;

  // 长度为 8 的 list
  static Port fromList(List<int> list) {
    return Port(
      sence: list[1],
      p0: list[2],
      p1: list[3],
      p2: list[4],
      p3: list[5],
      p4: list[6],
      p5: list[7],
      p6: list[8],
      p7: list[9],
      p8: list[10],
      p9: list[11],
    );
  }

  static Port emptyPort() {
    return Port(
      sence: -1,
      p0: -1,
      p1: -1,
      p2: -1,
      p3: -1,
      p4: -1,
      p5: -1,
      p6: -1,
      p7: -1,
      p8: -1,
      p9: -1,
    );
  }
}

enum LaneIndicatorState { green, red, right }

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

typedef FutureCallback = Future<void> Function();

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

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
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

  LaneIndicatorState nextState(LaneIndicatorState state) {
    return state2 == LaneIndicatorState.green
        ? LaneIndicatorState.red
        : LaneIndicatorState.green;
  }

  LaneIndicatorState nextState3(LaneIndicatorState state) {
    if (state == LaneIndicatorState.green) {
      return LaneIndicatorState.red;
    }
    if (state == LaneIndicatorState.red) {
      return LaneIndicatorState.right;
    }
    return LaneIndicatorState.green;
  }

  Future<void> updateState({List<bool>? coils, List<bool>? coils2}) async {
    coils ??= await getCoils(0, 24);

    if (coils == null) {
      return;
    }

    coils2 ??= await getCoils(512, 24);

    if (coils2 == null) {
      return;
    }
    int sence = widget.port?.getSence ?? -1;
    debugPrint("updateState: $sence");
    if (![1, 2, 3, 4, 5, 6, 7, 8, 9].contains(sence)) {
      return;
    }

    if (1 == sence) {
      bool i1 = coils2[widget.port?.p0 ?? 0];
      bool i2 = coils2[widget.port?.p1 ?? 0];
      bool i3 = coils2[widget.port?.p2 ?? 0];
      bool i4 = coils2[widget.port?.p3 ?? 0];

      LaneIndicatorState s1 = LaneIndicatorState.green;
      if (i1 && !i2) {
        s1 = LaneIndicatorState.green;
      } else if (!i1 && i2) {
        s1 = LaneIndicatorState.red;
      }

      LaneIndicatorState s2 = LaneIndicatorState.green;
      if (i3 && !i4) {
        s2 = LaneIndicatorState.green;
      } else if (!i3 && i4) {
        s2 = LaneIndicatorState.red;
      }
      setState(() {
        state1 = s1;
        state2 = s2;
      });
    } else if ([2, 4, 6, 8].contains(sence)) {
      bool i1 = coils[widget.port?.p2 ?? 0];
      bool i2 = coils[widget.port?.p5 ?? 0];
      setState(() {
        state1 = i1 ? LaneIndicatorState.green : LaneIndicatorState.red;
        state2 = i2 ? LaneIndicatorState.green : LaneIndicatorState.red;
      });
    } else if ([3, 5, 7, 9].contains(sence)) {
      bool i1 = coils[widget.port?.p3 ?? 0];
      bool i2 = coils[widget.port?.p4 ?? 0];
      bool i3 = coils[widget.port?.p8 ?? 0];
      bool i4 = coils[widget.port?.p9 ?? 0];

      LaneIndicatorState s1 = LaneIndicatorState.green;
      if (i1 && !i2) {
        s1 = LaneIndicatorState.green;
      } else if (!i1 && i2) {
        s1 = LaneIndicatorState.red;
      } else if (i1 && i2) {
        s1 = LaneIndicatorState.right;
      }

      LaneIndicatorState s2 = LaneIndicatorState.green;
      if (i3 && !i4) {
        s2 = LaneIndicatorState.green;
      } else if (!i3 && i4) {
        s2 = LaneIndicatorState.red;
      } else if (i3 && i4) {
        s2 = LaneIndicatorState.right;
      }

      setState(() {
        state1 = s1;
        state2 = s2;
      });
    }
  }

  Image buildImage(LaneIndicatorState? state) {
    if (state == LaneIndicatorState.green) {
      return Image.asset("images/light_inside/img_1@2x.png");
    }
    if (state == LaneIndicatorState.red) {
      return Image.asset("images/light_inside/img_3@2x.png");
    }

    if (state == LaneIndicatorState.right) {
      return Image.asset("images/light_inside/img_4@2x.png");
    }

    return Image.asset("images/light_inside/img_2@2x.png");
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
            int? sence = widget.port?.getSence ?? -1;
            debugPrint("sence: $sence");
            if (![1, 2, 3, 4, 5, 6, 7, 8, 9].contains(sence)) {
              return;
            }
            if (sence == 1) {
              LaneIndicatorState ns = nextState(state1);
              if (ns == LaneIndicatorState.green) {
                await setCoil(widget.port?.getP2 ?? 512, true);
                await setCoil(widget.port?.getP3 ?? 512, false);
              } else {
                await setCoil(widget.port?.getP2 ?? 512, false);
                await setCoil(widget.port?.getP3 ?? 512, true);
              }
            } else if ([2, 4, 6, 8].contains(sence)) {
              LaneIndicatorState ns = nextState(state1);
              if (ns == LaneIndicatorState.green) {
                await setCoil(widget.port?.getP0 ?? 512, true);
                await setCoil(widget.port?.getP1 ?? 512, false);
              } else {
                await setCoil(widget.port?.getP0 ?? 512, false);
                await setCoil(widget.port?.getP1 ?? 512, true);
              }
            } else if ([3, 5, 7, 9].contains(sence)) {
              LaneIndicatorState ns = nextState3(state1);
              if (ns == LaneIndicatorState.green) {
                await setCoil(widget.port?.getP0 ?? 512, true);
                await setCoil(widget.port?.getP1 ?? 512, false);
                await setCoil(widget.port?.getP3 ?? 512, false);
              } else if (ns == LaneIndicatorState.red) {
                await setCoil(widget.port?.getP0 ?? 512, false);
                await setCoil(widget.port?.getP1 ?? 512, true);
                await setCoil(widget.port?.getP3 ?? 512, false);
              } else {
                await setCoil(widget.port?.getP0 ?? 512, false);
                await setCoil(widget.port?.getP1 ?? 512, false);
                await setCoil(widget.port?.getP3 ?? 512, true);
              }
            }

            await updateState();
          },
          child: Container(
            width: 100,
            height: 100,
            alignment: Alignment.center,
            child: buildImage(state1),
          ),
        ),
        verticalLine(),
        GestureDetector(
          onTap: () async {
            int? sence = widget.port?.getSence ?? -1;
            debugPrint("sence: $sence");
            if (![1, 2, 3, 4, 5, 6, 7, 8, 9].contains(sence)) {
              return;
            }
            if (sence == 1) {
              LaneIndicatorState ns = nextState(state1);
              if (ns == LaneIndicatorState.green) {
                await setCoil(widget.port?.getP2 ?? 512, true);
                await setCoil(widget.port?.getP3 ?? 512, false);
              } else {
                await setCoil(widget.port?.getP2 ?? 512, false);
                await setCoil(widget.port?.getP3 ?? 512, true);
              }
            } else if ([2, 4, 6, 8].contains(sence)) {
              LaneIndicatorState ns = nextState(state1);
              if (ns == LaneIndicatorState.green) {
                await setCoil(widget.port?.getP3 ?? 512, true);
                await setCoil(widget.port?.getP4 ?? 512, false);
              } else {
                await setCoil(widget.port?.getP3 ?? 512, false);
                await setCoil(widget.port?.getP4 ?? 512, true);
              }
            } else if ([3, 5, 7, 9].contains(sence)) {
              LaneIndicatorState ns = nextState3(state1);
              if (ns == LaneIndicatorState.green) {
                await setCoil(widget.port?.getP5 ?? 512, true);
                await setCoil(widget.port?.getP6 ?? 512, false);
                await setCoil(widget.port?.getP7 ?? 512, false);
              } else if (ns == LaneIndicatorState.red) {
                await setCoil(widget.port?.getP5 ?? 512, false);
                await setCoil(widget.port?.getP6 ?? 512, true);
                await setCoil(widget.port?.getP7 ?? 512, false);
              } else {
                await setCoil(widget.port?.getP5 ?? 512, false);
                await setCoil(widget.port?.getP6 ?? 512, false);
                await setCoil(widget.port?.getP7 ?? 512, true);
              }
            }

            await updateState();
          },
          child: Container(
            width: 100,
            height: 100,
            alignment: Alignment.center,
            child: Container(
              width: 100,
              height: 100,
              alignment: Alignment.center,
              child: buildImage(state2),
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
