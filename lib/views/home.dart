import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:iot_client/scenes/lane_indicator.dart';
import 'package:iot_client/utils/navigation.dart';

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
      GestureDetector(
        onTap: () {
          Navigation.navigateTo(
            context: context,
            screen: LaneIndicator(),
          );
        },
        child: Container(
          padding: EdgeInsets.all(8),
          color: Colors.black12,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.drive_eta,
                  size: 60,
                  color: Colors.yellowAccent,
                ),
                Text("车道指示器")
              ],
            ),
          ),
        ),
      ),
      Container(
        padding: EdgeInsets.all(8),
        color: Colors.black12,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.traffic,
                size: 60,
                color: Colors.redAccent,
              ),
              Text("交通信号灯")
            ],
          ),
        ),
      ),
      Container(
        padding: EdgeInsets.all(8),
        color: Colors.black12,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.storm,
                size: 60,
                color: Colors.indigoAccent,
              ),
              Text("通风风机")
            ],
          ),
        ),
      ),
      Container(
        padding: EdgeInsets.all(8),
        color: Colors.black12,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.light_mode,
                size: 60,
                color: Colors.amberAccent,
              ),
              Text("照明回路")
            ],
          ),
        ),
      ),
      Container(
        padding: EdgeInsets.all(8),
        color: Colors.black12,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.air,
                size: 60,
                color: Colors.tealAccent,
              ),
              Text("风速风向")
            ],
          ),
        ),
      ),
      Container(
        padding: EdgeInsets.all(8),
        color: Colors.black12,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.double_arrow,
                size: 60,
                color: Colors.redAccent,
              ),
              Text("横洞指示")
            ],
          ),
        ),
      ),
      Container(
        padding: EdgeInsets.all(8),
        color: Colors.black12,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.dew_point,
                size: 60,
                color: Colors.blueAccent,
              ),
              Text("水泵液压")
            ],
          ),
        ),
      ),
      Container(
        padding: EdgeInsets.all(8),
        color: Colors.black12,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.highlight,
                size: 60,
                color: Colors.deepOrangeAccent,
              ),
              Text("光强检测")
            ],
          ),
        ),
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
              height: 200.0,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: ExactAssetImage('images/banner.jpeg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
                child: Container(
                  decoration:
                      BoxDecoration(color: Colors.white.withOpacity(0.0)),
                ),
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
