import 'dart:typed_data';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:iot_client/futs/hal.dart';
import 'package:iot_client/scenes/widgets/util.dart';
import 'package:iot_client/views/components/banner.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TrafficLight extends StatefulWidget {
  const TrafficLight({Key? key}) : super(key: key);

  @override
  State<TrafficLight> createState() => _TrafficLightState();
}

class _TrafficLightState extends State<TrafficLight>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  final GlobalKey<ScaffoldMessengerState> key =
      GlobalKey<ScaffoldMessengerState>(debugLabel: 'traffic_light');

  late TabController tabController;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<String?> sn = Future.value(null);
  Future<String?> ip = Future.value(null);

  void mountedState(void Function() fn) {
    if (mounted) {
      setState(fn);
    }
  }

  @override
  bool get wantKeepAlive => true;
  void tabListener() {
    if (tabController.index == 0) {}
    if (tabController.index == 1) {
      _prefs.then((SharedPreferences prefs) {
        return prefs.getString('mesh');
      }).then((String? addr) async {
        if (addr != null) {
          getHoldings(2196, 9).then((value) {
            Uint8List v = Uint16List.fromList(value).buffer.asUint8List();
            mountedState(() {
              sn = Future.value(String.fromCharCodes(v));
            });
          });

          getHoldings(2247, 4).then((value) {
            mountedState(() {
              ip = Future.value(value.join('.'));
            });
          });
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    tabController.animateTo(0);

    tabController.addListener(tabListener);
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
        ),
        body: TabBarView(
          controller: tabController,
          physics: BouncingScrollPhysics(),
          dragStartBehavior: DragStartBehavior.down,
          children: [
            SingleChildScrollView(
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
            SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
              child: Container(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        verticalDirection: VerticalDirection.down,
                        children: [
                          Text(
                            "设备SN编号:",
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w500),
                          ),
                          SizedBox.fromSize(
                            size: Size(5, 0),
                          ),
                          FutureBuilder(
                            future: sn,
                            initialData: '',
                            builder:
                                (context, AsyncSnapshot<String?> snapshot) {
                              if (snapshot.hasData &&
                                  snapshot.connectionState ==
                                      ConnectionState.done) {
                                String id = snapshot.data ?? '';
                                return Text(
                                  id,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w300),
                                );
                              }

                              return Text(
                                "",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w300),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        verticalDirection: VerticalDirection.down,
                        children: [
                          Text(
                            "设备状态:",
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w500),
                          ),
                          SizedBox.fromSize(
                            size: Size(5, 0),
                          ),
                          Text(
                            "运行中",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w300),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        verticalDirection: VerticalDirection.down,
                        children: [
                          Text(
                            "设备版本:",
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w500),
                          ),
                          SizedBox.fromSize(
                            size: Size(5, 0),
                          ),
                          Text(
                            "v1.0.0",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w300),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        verticalDirection: VerticalDirection.down,
                        children: [
                          Text(
                            "设备IP:",
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w500),
                          ),
                          SizedBox.fromSize(
                            size: Size(5, 0),
                          ),
                          FutureBuilder(
                            future: ip,
                            initialData: '',
                            builder:
                                (context, AsyncSnapshot<String?> snapshot) {
                              if (snapshot.hasData &&
                                  snapshot.connectionState ==
                                      ConnectionState.done) {
                                String id = snapshot.data ?? '';
                                return Text(
                                  id,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w300),
                                );
                              }

                              return Text(
                                "",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w300),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        verticalDirection: VerticalDirection.down,
                        children: [
                          Text(
                            "设备端口:",
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w500),
                          ),
                          SizedBox.fromSize(
                            size: Size(5, 0),
                          ),
                          Text(
                            "5002",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w300),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
