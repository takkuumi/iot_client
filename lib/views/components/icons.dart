import 'package:flutter/material.dart';

Widget createIcon(
  String name, {
  required void Function() onTap,
  required String assetIcon,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Color.fromRGBO(221, 221, 221, 1),
        ),
        borderRadius: BorderRadius.circular(10),
      ),
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
