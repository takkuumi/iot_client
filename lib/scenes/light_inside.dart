import 'dart:async';
import 'dart:typed_data';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iot_client/ffi.dart';
import 'package:iot_client/utils/at_parse.dart';
import 'package:iot_client/views/components/banner.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../futs/hal.dart';

class LightInside extends StatefulWidget {
  const LightInside({Key? key}) : super(key: key);

  @override
  State<LightInside> createState() => _LightInsideState();
}

class _LightInsideState extends State<LightInside>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  final GlobalKey<ScaffoldMessengerState> key =
      GlobalKey<ScaffoldMessengerState>(debugLabel: 'light_outside');

  late TabController tabController;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<String?> sn = Future.value(null);
  Future<String?> ip = Future.value(null);

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  bool get wantKeepAlive => true;
  void tabListener() {
    if (tabController.index == 0) {
      startTimer();
      readDevice(readAt("09C7")).then(respHandler);
    }
    if (tabController.index == 1) {
      _prefs.then((SharedPreferences prefs) {
        return prefs.getString('mesh');
      }).then((String? addr) async {
        if (addr != null) {
          getHoldings(2196, 9).then((value) {
            Uint8List v = Uint16List.fromList(value).buffer.asUint8List();
            setState(() {
              sn = Future.value(String.fromCharCodes(v));
            });
          });

          getHoldings(2247, 4).then((value) {
            setState(() {
              ip = Future.value(value.join('.'));
            });
          });
        }
      });
    }
  }

  Timer? timer;
  late String windSpeed = '亮度值:--\r\n报警值:--\r\n故障码:--';

  late String windSpeed1 = '--';
  late String windSpeed2 = '--';
  late String windSpeed3 = '--';

  List<int> recoder = [0, 0, 0];

  void respHandler(String? resp) {
    List<int> data = parseLight(resp);

    for (int i = 0; i < data.length; i++) {
      if (data[i] != 0) {
        recoder[i] = data[i];
      }
    }
    setState(() {
      windSpeed1 = "${recoder[0]} lux";
      windSpeed2 = "${recoder[1]} lux";
      windSpeed3 = "${recoder[2]}";
    });
  }

  void startTimer() {
    timer = Timer.periodic(timerDuration, (timer) async {
      // 09C4 洞外
      String? resp = await readDevice(readAt("09C7"));
      respHandler(resp);
    });
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
    timer?.cancel();
    super.dispose();
  }

  String readAt(String addr) {
    // 010F020000030105
    return "0103${addr}0003";
  }

  Future<String?> getLink() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString('mesh');
  }

  Future<String?> readDevice(
    String sdata,
  ) async {
    String? meshId = await getLink();

    if (meshId == null || meshId.isEmpty) {
      return null;
    }

    try {
      // SerialResponse response =
      //     await api.bleAtNdrpt(id: meshId, data: sdata, retry: 5);
      // Uint8List? data = response.data;
      // if (data != null) {
      //   return String.fromCharCodes(data);
      // }
    } catch (e) {
      debugPrint(e.toString());
    }
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
      crossAxisAlignment: CrossAxisAlignment.center,
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
                "images/icons/lght intensity detection@2x.png",
                width: 120,
                height: 120,
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
              Container(
                  height: 40,
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(children: [
                    Text(
                      "亮度值:",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      windSpeed1,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.greenAccent),
                    ),
                  ])),
              Container(
                  height: 40,
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(children: [
                    Text(
                      "告警值:",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      windSpeed2,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.greenAccent),
                    ),
                  ])),
              Container(
                  height: 40,
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(children: [
                    Text(
                      "故障码:",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      windSpeed3,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.yellowAccent),
                    ),
                  ])),
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
          title: const Text('洞内光强'),
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
                      width: 510,
                      padding: EdgeInsets.symmetric(vertical: 60),
                      child: Wrap(
                        alignment: WrapAlignment.spaceEvenly,
                        spacing: 40,
                        children: [
                          createLane1(),
                        ],
                      ),
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
