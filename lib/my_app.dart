import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:iot_client/futs/ble.dart';
import 'package:iot_client/views/bluetooth.dart';
import 'package:iot_client/views/setting.dart';

import 'constants.dart';
import 'views/home.dart';

const int homeTab = 0;
const int bluetoothTab = 1;
const int settingTab = 2;

class MyApp extends StatefulWidget {
  final ThemeData theme;
  const MyApp({Key? key, required this.theme}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _bottomNavigationBarIndex = homeTab;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      disconectAll().whenComplete(() {
        debugPrint("断开所有蓝牙连接");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget body = const SizedBox.shrink();

    if (_bottomNavigationBarIndex == homeTab) {
      //  home
      body = const Home();
    } else if (_bottomNavigationBarIndex == bluetoothTab) {
      body = const Bluetooth();
    } else if (_bottomNavigationBarIndex == settingTab) {
      body = const SettingApp();
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: widget.theme,
      useInheritedMediaQuery: true,
      builder: EasyLoading.init(),
      home: ScaffoldMessenger(
        key: rootScaffoldMessengerKey,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('深圳市迈锐交通科技有限公司'),
          ),
          body: body,
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _bottomNavigationBarIndex,
            onTap: (newBottomNavigationBarIndex) {
              setState(() {
                _bottomNavigationBarIndex = newBottomNavigationBarIndex;
              });
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: '首页',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bluetooth_searching),
                label: '蓝牙',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: '设置',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void log(Object? msg) =>
    debugPrint('[$MyApp - ${DateTime.now().toIso8601String()}] $msg');
