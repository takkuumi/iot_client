import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge.dart';
import 'package:iot_client/device.dart';
import 'package:iot_client/ffi.dart';
import 'package:iot_client/futs/hal.dart';
import 'package:iot_client/utils/at_parse.dart';
import 'package:iot_client/views/components/banner.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

class CoVi extends StatefulWidget {
  const CoVi({Key? key}) : super(key: key);

  @override
  State<CoVi> createState() => _CoViState();
}

class _CoViState extends State<CoVi>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  List<Device> devices = [];

  final GlobalKey<ScaffoldMessengerState> key =
      GlobalKey<ScaffoldMessengerState>(debugLabel: 'covi');

  Timer? timer;

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late TabController tabController;
  Future<String?> sn = Future.value(null);
  Future<String?> ip = Future.value(null);

  @override
  bool get wantKeepAlive => true;
  void tabListener() {
    if (tabController.index == 0) {
      startTimer();
      readDevice(readAt("09CA")).then(respHandler);
    }
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

  late String windSpeed1 = '--';
  late String windSpeed2 = '--';
  late String windSpeed3 = '--';
  late String windSpeed4 = '--';

  List<int> recoder = [0, 0, 0, 0];

  void respHandler(String? resp) {
    List<int> data = parseWindSpreed(resp);

    for (int i = 0; i < data.length; i++) {
      if (data[i] != 0) {
        recoder[i] = data[i];
      }
    }

    setState(() {
      windSpeed1 = "${recoder[0]} ppm";
      windSpeed2 = "${recoder[1]} ppm";
      windSpeed3 = "${recoder[2]} ppm";
      windSpeed4 = "${recoder[3]} ppm";
    });
  }

  void startTimer() {
    timer = Timer.periodic(timerDuration, (timer) async {
      String? resp = await readDevice(readAt("09CA"));
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

  String readAt(String addr) {
    // 010F020000030105
    return "0103${addr}0004";
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
      SerialResponse response =
          await api.bleAtNdrpt(id: meshId, data: sdata, retry: 5);
      Uint8List? data = response.data;
      if (data != null) {
        return String.fromCharCodes(data);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void dispose() {
    timer?.cancel();

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
          child: Image.asset(
            "images/icons/environmental testing_icon@2x.png",
            width: 120,
            height: 120,
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
                      "Co浓度值:",
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
                      "VI值:",
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
            ],
          ),
        ),
        Container(
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
                      "Co报警值:",
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
              Container(
                  height: 40,
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(children: [
                    Text(
                      "VI报警值:",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      windSpeed4,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.redAccent,
                      ),
                    ),
                  ])),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: key,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('COVI检测'),
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
