import 'package:flutter/material.dart';

final decoration = BoxDecoration(
  borderRadius: BorderRadius.circular(10),
  boxShadow: [
    BoxShadow(
      color: Color.fromRGBO(221, 221, 221, 1),
      offset: const Offset(
        5.0,
        5.0,
      ),
      blurRadius: 10.0,
      spreadRadius: 2.0,
    ), //BoxShadow
    BoxShadow(
      color: Colors.white,
      offset: const Offset(0.0, 0.0),
      blurRadius: 0.0,
      spreadRadius: 0.0,
    ), //BoxShadow
  ],
);

Widget createIcon(
  String name, {
  required void Function() onTap,
  required String assetIcon,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.all(10),
      decoration: decoration,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              assetIcon,
              width: 50,
              height: 50,
            ),
            Text(name)
          ],
        ),
      ),
    ),
  );
}
