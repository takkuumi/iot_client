import 'dart:typed_data';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:iot_client/futs/hal.dart';
import 'package:iot_client/scenes/widgets/shared_service_info.dart';
import 'package:iot_client/scenes/widgets/util.dart';
import 'package:iot_client/views/components/banner.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CrossHole extends StatefulWidget {
  const CrossHole({Key? key}) : super(key: key);

  @override
  State<CrossHole> createState() => _CrossHoleState();
}

class _CrossHoleState extends State<CrossHole>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  final GlobalKey<ScaffoldMessengerState> key =
      GlobalKey<ScaffoldMessengerState>(debugLabel: 'cross_hole');

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
    if (tabController.index == 0) {}
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
              Icon(Icons.double_arrow_sharp,
                  size: 80, color: Colors.greenAccent)
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                child: Text("打开"),
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
              createSig('远程信号：', '无'),
              createSig('运行信号：', '无'),
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
          title: const Text('横洞指示'),
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
                      child: createLane1(),
                    ),
                  ],
                ),
              ),
            ),
            SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
              child: SharedServiceInfo(),
            )
          ],
        ),
      ),
    );
  }
}
