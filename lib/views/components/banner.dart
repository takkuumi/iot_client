import 'package:flutter/material.dart';

final List<String> imgList = [
  'images/banner/img_1@2x.png',
  'images/banner/img_2@2x.png',
  'images/banner/img_3@2x.png',
];
List<Widget> createImageSliders() {
  return imgList
      .map((item) => Container(
            margin: EdgeInsets.all(10.0),
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                child: Image.asset(
                  item,
                  fit: BoxFit.cover,
                )),
          ))
      .toList();
}
