import 'package:flutter/material.dart';

final Color disableColor = Color.fromRGBO(221, 221, 221, 1);
final Widget verticalLine = Container(
  height: 20,
  child: VerticalDivider(
    thickness: 2,
    color: Color.fromRGBO(192, 192, 192, 1),
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
    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
  );
}

Widget buildOffState() {
  return Container(
    width: 100,
    height: 100,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(
        width: 2,
        color: disableColor,
      ),
      borderRadius: BorderRadius.circular(50),
      boxShadow: [boxShadow],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.clear,
          size: 60,
          color: disableColor,
        )
      ],
    ),
  );
}
