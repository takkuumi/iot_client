import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:iot_client/scenes/widgets/util.dart';
import 'package:iot_client/views/components/banner.dart';

class TrafficLight extends StatefulWidget {
  const TrafficLight({Key? key}) : super(key: key);

  @override
  State<TrafficLight> createState() => _TrafficLightState();
}

class _TrafficLightState extends State<TrafficLight>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldMessengerState> key =
      GlobalKey<ScaffoldMessengerState>(debugLabel: 'traffic_light');

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final BoxShadow boxShadow = BoxShadow(
    color: Colors.grey.withOpacity(0.5),
    spreadRadius: 5,
    blurRadius: 7,
    offset: const Offset(0, 3),
  );

  final Color disableColor = Color.fromRGBO(221, 221, 221, 1);

  final Widget verticalLine = Container(
    height: 20,
    child: VerticalDivider(
      thickness: 2,
      color: Color.fromRGBO(192, 192, 192, 1),
    ),
  );

  Widget createLane1() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.center,
          child: Image.asset(
            "images/icons/traffic-lights.png",
            width: 100,
            height: 200,
            fit: BoxFit.cover,
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              createSig('红灯信号：', '无'),
              createSig('黄灯信号：', '无'),
              createSig('绿灯信号：', '无'),
            ],
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: key,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('交通信号灯'),
        ),
        body: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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
                  width: 480,
                  padding: EdgeInsets.symmetric(vertical: 100),
                  child: createLane1(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
