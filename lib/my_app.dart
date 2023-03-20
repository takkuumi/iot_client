import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iot_client/views/bluetooth.dart';
import 'package:iot_client/views/in_app_browser.dart';

import 'views/home.dart';

const int homeTab = 0;
const int bluetoothTab = 1;
const int controlTab = 2;
const int nativeTab = 3;
// used for app's theme
const Map<int, Color> primarySwatch = {
  50: Color.fromRGBO(0, 164, 153, .1),
  100: Color.fromRGBO(0, 164, 153, .2),
  200: Color.fromRGBO(0, 164, 153, .3),
  300: Color.fromRGBO(0, 164, 153, .4),
  400: Color.fromRGBO(0, 164, 153, .5),
  500: Color.fromRGBO(0, 164, 153, .6),
  600: Color.fromRGBO(0, 164, 153, .7),
  700: Color.fromRGBO(0, 164, 153, .8),
  800: Color.fromRGBO(0, 164, 153, .9),
  900: Color.fromRGBO(0, 164, 153, 1),
};

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>(debugLabel: 'main_scaffold');

  int _bottomNavigationBarIndex = homeTab;

  @override
  Widget build(BuildContext context) {
    Widget body = const SizedBox.shrink();

    if (_bottomNavigationBarIndex == homeTab) {
      //  home
      body = const Home();
    } else if (_bottomNavigationBarIndex == bluetoothTab) {
      body = const Bluetooth();
    } else if (_bottomNavigationBarIndex == controlTab) {
      body = const InAppView();
    }

    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: const MaterialColor(0xFF00A499, primarySwatch),
        primaryColor: const Color.fromRGBO(0, 164, 153, 1),
        primaryColorDark: const Color.fromRGBO(0, 114, 105, 1),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: ScaffoldMessenger(
        key: _scaffoldKey,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('深圳市迈锐交通科技有限公司'),
          ),
          body: body,
          bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: Colors.red,
            unselectedItemColor: Colors.grey,
            currentIndex: _bottomNavigationBarIndex,
            onTap: (newBottomNavigationBarIndex) {
              setState(() {
                _bottomNavigationBarIndex = newBottomNavigationBarIndex;
              });
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: '首页',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bluetooth_searching),
                label: '蓝牙',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.interests),
                label: '监控',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'MyApp',
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

// Future<void> checkAndAskPermissions() async {
//   if (defaultTargetPlatform == TargetPlatform.android) {
//     final androidInfo = await DeviceInfoPlugin().androidInfo;
//     if (androidInfo.version.sdkInt < 31) {
//       // location
//       await Permission.locationWhenInUse.request();
//       await Permission.locationAlways.request();

//       // bluetooth
//       await Permission.bluetooth.request();
//       await Permission.bluetoothScan.request();
//       await Permission.bluetoothConnect.request();
//     } else {
//       // bluetooth for Android 12 and up
//       await Permission.bluetoothScan.request();
//       await Permission.bluetoothConnect.request();
//     }
//   } else {
//     // bluetooth for iOS 13 and up
//     await Permission.bluetooth.request();
//   }
// }
