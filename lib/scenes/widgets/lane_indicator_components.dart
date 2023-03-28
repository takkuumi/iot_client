import 'package:flutter/material.dart';

final Color disableColor = Color.fromRGBO(221, 221, 221, 1);
final Widget verticalLineOnly = Container(
  height: 60,
  child: VerticalDivider(
    thickness: 2,
    color: Color.fromRGBO(0, 84, 216, 1),
  ),
);

final decoration = BoxDecoration(
  // border: Border.all(
  //   width: 1,
  //   color: Color.fromRGBO(0, 84, 216, 1),
  // ),
  color: Color.fromRGBO(133, 225, 126, 1),
  borderRadius: BorderRadius.circular(4),
);

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

final Widget verticalLine = Container(
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

final Widget verticalLine2 = Container(
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
