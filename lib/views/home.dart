import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:iot_client/scenes/covi.dart';
import 'package:iot_client/scenes/cross_hole.dart';
import 'package:iot_client/scenes/fan.dart';
import 'package:iot_client/scenes/lane_indicator.dart';
import 'package:iot_client/scenes/light_inside.dart';
import 'package:iot_client/scenes/traffic_light.dart';
import 'package:iot_client/scenes/water_pump.dart';
import 'package:iot_client/scenes/wind_speed.dart';
import 'package:iot_client/utils/navigation.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:iot_client/views/components/banner.dart';
import 'package:iot_client/views/components/icons.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget __createGridViewItems(BuildContext context, int position) {
    List<Widget> items = [
      createIcon(
        "车道指示器",
        onTap: () {
          Navigation.navigateTo(
            context: context,
            screen: LaneIndicator(),
          );
        },
        assetIcon: "images/icons/lane indicator_icon@2x.png",
      ),
      createIcon(
        "风速风向",
        onTap: () {
          Navigation.navigateTo(
            context: context,
            screen: WindSpeed(),
          );
        },
        assetIcon: "images/icons/wind speed and direction@2x.png",
      ),
      createIcon(
        "COVI检测",
        onTap: () {
          Navigation.navigateTo(
            context: context,
            screen: CoVi(),
          );
        },
        assetIcon: "images/icons/environmental testing_icon@2x.png",
      ),
      createIcon(
        "洞内照度",
        onTap: () {
          Navigation.navigateTo(
            context: context,
            screen: LightInside(),
          );
        },
        assetIcon: "images/icons/lght intensity detection@2x.png",
      ),
      createIcon(
        "交通信号灯",
        onTap: () {
          Navigation.navigateTo(
            context: context,
            screen: TrafficLight(),
          );
        },
        assetIcon: "images/icons/traffic light_icon@2x.png",
      ),
      createIcon(
        "通风风机",
        onTap: () {
          Navigation.navigateTo(
            context: context,
            screen: Fan(),
          );
        },
        assetIcon: "images/icons/yentilation fan_icon@2x.png",
      ),
      createIcon(
        "横洞指示",
        onTap: () {
          Navigation.navigateTo(
            context: context,
            screen: CrossHole(),
          );
        },
        assetIcon: "images/icons/cross hole indication@2x.png",
      ),
      createIcon(
        "水泵液压",
        onTap: () {
          Navigation.navigateTo(
            context: context,
            screen: WaterPump(),
          );
        },
        assetIcon: "images/icons/water pump hydraulics@2x.png",
      ),
    ];
    return items[position];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              child: CarouselSlider(
                options: CarouselOptions(
                  aspectRatio: 16 / 10,
                  enlargeCenterPage: true,
                  scrollDirection: Axis.horizontal,
                  autoPlay: true,
                  height: 260,
                ),
                items: createImageSliders(),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              alignment: Alignment.center,
              child: GridView.builder(
                  primary: false,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(20),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  itemCount: 8,
                  itemBuilder: (BuildContext context, int position) {
                    return __createGridViewItems(context, position);
                  }),
            )
          ],
        ),
      ),
    );
  }
}
