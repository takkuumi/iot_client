import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iot_client/ffi.dart';
import 'package:iot_client/futs/ble.dart';
import 'package:iot_client/model/chinfo.dart';
import 'package:iot_client/model/device.dart';
import 'package:iot_client/provider/app_provider.dart';
import 'package:iot_client/views/about.dart';
import 'package:iot_client/views/bluetooth.dart';
import 'package:iot_client/views/recoder.dart';
import 'package:iot_client/views/setting.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';
import 'views/home.dart';

const int homeTab = 0;
const int bluetoothTab = 1;
const int settingTab = 2;
const int historyTab = 3;
const int aboutTab = 4;

class App extends HookConsumerWidget {
  final ThemeData theme;
  const App({Key? key, required this.theme}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme,
      builder: EasyLoading.init(),
      home: ScaffoldMessenger(
        key: rootScaffoldMessengerKey,
        child: const AppMainView(),
      ),
    );
  }
}

class AppMainView extends StatefulHookConsumerWidget {
  const AppMainView({Key? key}) : super(key: key);

  @override
  AppMainViewState createState() => AppMainViewState();
}

class AppMainViewState extends ConsumerState<AppMainView> {
  int _bottomNavigationBarIndex = homeTab;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Timer? _timer;
  bool _isTaskScheduling = false;

  void startTimer() {
    if (_timer?.isActive ?? false) {
      _timer?.cancel();
    }
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      // 如果当前正在调度，则跳过，等待下一次调度
      if (_isTaskScheduling) return;
      SerialResponse response = await api.bleChinfo().whenComplete(() {
        _isTaskScheduling = false;
      });
      Uint8List? data = response.data;
      if (data == null) return;
      String responseText = String.fromCharCodes(data);

      List<Chinfo> chinfos = parseChinfos(responseText);

      ref.read(appConnectedProvider.notifier).changeDevice(chinfos);
    });
  }

  void stopTimer() {
    _timer?.cancel();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await api.bleTpmode();
      startTimer();
    });
  }

  @override
  void dispose() {
    stopTimer();

    ///关闭
    super.dispose();
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

    return Scaffold(
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
                  future: _prefs.then((value) => value.getString('appTitle'))),
            ),
      body: body,
      bottomNavigationBar: NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        selectedIndex: _bottomNavigationBarIndex,
        onDestinationSelected: (newBottomNavigationBarIndex) {
          // if (EasyLoading.isShow) {
          //   return showSnackBar("请等待操作完成");
          // }
          setState(() {
            _bottomNavigationBarIndex = newBottomNavigationBarIndex;
          });
        },
        animationDuration: const Duration(seconds: 1),
        destinations: const <NavigationDestination>[
          NavigationDestination(
            icon: Icon(Symbols.home),
            label: '首页',
          ),
          NavigationDestination(
            icon: Icon(Symbols.bluetooth),
            label: '蓝牙',
          ),
          NavigationDestination(
            icon: Icon(Symbols.settings),
            label: '设置',
          ),
          NavigationDestination(
            icon: Icon(Symbols.history),
            label: '历史记录',
          ),
          NavigationDestination(
            icon: Icon(Symbols.account_circle),
            label: '关于我们',
          ),
        ],
        backgroundColor: Colors.white24,
      ),
    );
  }
}
