import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:iot_client/futs/ble.dart';
import 'package:iot_client/views/about.dart';
import 'package:iot_client/views/bluetooth.dart';
import 'package:iot_client/views/recoder.dart';
import 'package:iot_client/views/setting.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';
import 'views/home.dart';

const int homeTab = 0;
const int bluetoothTab = 1;
const int settingTab = 2;
const int historyTab = 3;

const int aboutTab = 4;

class MyApp extends StatefulWidget {
  final ThemeData theme;
  const MyApp({Key? key, required this.theme}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _bottomNavigationBarIndex = homeTab;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
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
    } else if (_bottomNavigationBarIndex == historyTab) {
      body = const Recoder();
    } else if (_bottomNavigationBarIndex == settingTab) {
      body = const SettingApp();
    } else if (_bottomNavigationBarIndex == aboutTab) {
      body = const About();
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: widget.theme,
      useInheritedMediaQuery: true,
      builder: EasyLoading.init(),
      home: ScaffoldMessenger(
        key: rootScaffoldMessengerKey,
        child: Scaffold(
          appBar: _bottomNavigationBarIndex == aboutTab
              ? null
              : AppBar(
                  title: FutureBuilder(
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Text(snapshot.data.toString());
                        } else {
                          return const Text('');
                        }
                      },
                      future:
                          _prefs.then((value) => value.getString('appTitle'))),
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
              BottomNavigationBarItem(
                icon: Icon(Icons.history),
                label: '历史记录',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_circle),
                label: '关于我们',
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
