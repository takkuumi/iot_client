import 'package:flutter/material.dart';

Widget createSig(String label, String sig) {
  return Container(
      height: 40,
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Row(children: [
        Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        Text(
          sig,
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.greenAccent),
        ),
      ]));
}
