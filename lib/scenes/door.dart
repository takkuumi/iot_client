import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:iot_client/scenes/widgets/util.dart';
import 'package:iot_client/views/components/banner.dart';

class Door extends StatefulWidget {
  const Door({Key? key}) : super(key: key);

  @override
  State<Door> createState() => _DoorState();
}

class _DoorState extends State<Door> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldMessengerState> key =
      GlobalKey<ScaffoldMessengerState>(debugLabel: 'door');

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

  Widget createLane1() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 150,
          height: 150,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              width: 2,
              color: Colors.greenAccent,
            ),
            borderRadius: BorderRadius.circular(75),
            boxShadow: [boxShadow],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "images/icons/door.png",
                width: 80,
                height: 80,
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                child: Text("开门"),
                onPressed: () {},
              ),
              Container(
                width: 15,
              ),
              ElevatedButton(
                child: Text("关门"),
                onPressed: () {},
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              createSig('开到位信号：', '无'),
              createSig('关到位信号：', '无'),
              createSig('故障信号：', '无'),
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
          title: const Text('卷闸门'),
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
                  width: 510,
                  padding: EdgeInsets.symmetric(vertical: 60),
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
