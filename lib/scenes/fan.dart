import 'dart:typed_data';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:iot_client/futs/hal.dart';
import 'package:iot_client/scenes/widgets/util.dart';
import 'package:iot_client/views/components/banner.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Fan extends StatefulWidget {
  const Fan({Key? key}) : super(key: key);

  @override
  State<Fan> createState() => _FanState();
}

class _FanState extends State<Fan> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldMessengerState> key =
      GlobalKey<ScaffoldMessengerState>(debugLabel: 'fan');
  late TabController tabController;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<String?> sn = Future.value(null);
  Future<String?> ip = Future.value(null);
  void tabListener() {
    if (tabController.index == 0) {}
    if (tabController.index == 1) {
      _prefs.then((SharedPreferences prefs) {
        return prefs.getString('mesh');
      }).then((String? meshId) async {
        if (meshId != null) {
          List<int> snData = await getHoldings(meshId, 2196, 9);
          Uint8List v = Uint16List.fromList(snData).buffer.asUint8List();
          setState(() {
            sn = Future.value(String.fromCharCodes(v));
          });

          List<int> ipData = await getHoldings(meshId, 2247, 4);
          setState(() {
            ip = Future.value(ipData.join('.'));
          });
        }
      });
    }
  }

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
                "images/icons/yentilation fan_icon@2x.png",
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
                child: Text("正转"),
                onPressed: () {},
              ),
              Container(
                width: 15,
              ),
              ElevatedButton(
                child: Text("反转"),
                onPressed: () {},
              ),
              Container(
                width: 15,
              ),
              ElevatedButton(
                child: Text("停止"),
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
              createSig('远程信号:', '无'),
              createSig('正转信号:', '无'),
              createSig('反转信号:', '无'),
              createSig('故障信号:', '无'),
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
          title: const Text('通风风机'),
          centerTitle: true,
          bottom: TabBar(
            controller: tabController,
            tabs: [
              Tab(
                text: "控制信息",
              ),
              Tab(
                text: "服务信息",
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => {},
              child: Text("逻辑控制"),
            )
          ],
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
