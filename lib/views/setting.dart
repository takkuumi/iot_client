import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:iot_client/ffi.dart';
import 'package:flutter/material.dart';
import 'package:iot_client/futs/hal.dart';
import 'package:iot_client/utils/navigation.dart';
import 'package:iot_client/views/logic_control_setting.dart';
import 'package:iot_client/views/rs485_setting.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

class SettingApp extends StatefulWidget {
  const SettingApp({
    Key? key,
  }) : super(key: key);

  @override
  State<SettingApp> createState() => _SettingAppState();
}

class _SettingAppState extends State<SettingApp> {
  bool useCustomTheme = false;

  final platformsMap = <DevicePlatform, String>{
    DevicePlatform.device: 'Default',
    DevicePlatform.android: 'Android',
    DevicePlatform.iOS: 'iOS',
    DevicePlatform.web: 'Web',
    DevicePlatform.fuchsia: 'Fuchsia',
    DevicePlatform.linux: 'Linux',
    DevicePlatform.macOS: 'MacOS',
    DevicePlatform.windows: 'Windows',
  };
  DevicePlatform selectedPlatform = DevicePlatform.fuchsia;

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _ipFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _appTitleFormKey = GlobalKey<FormState>();

  final TextEditingController _textEditingController = TextEditingController();

  final TextEditingController _ipEditingController = TextEditingController();
  final TextEditingController _appTitleEditingController =
      TextEditingController();

  late Future<String?> ndid = Future.value(null);
  Future<String?> mac = Future.value(null);
  Future<String?> ip = Future.value(null);
  Future<String?> subnetMask = Future.value(null);
  Future<String?> gateway = Future.value(null);

  void mountedState(void Function() fn) {
    if (mounted) {
      setState(fn);
    }
  }

  void updateUi(List<int> data) {
    debugPrint("data: ${data.join(',')}");

    if (data.length < 80) {
      return;
    }

    String hexmac =
        List.of([data[67], data[68], data[69], data[70], data[71], data[72]])
            .map((e) => e.toRadixString(16).toUpperCase().padLeft(2, '0'))
            .join('-');
    String ipstr = List.of([data[51], data[52], data[53], data[54]]).join('.');
    String subnetstr =
        List.of([data[55], data[56], data[57], data[58]]).join('.');
    String gatawaystr =
        List.of([data[59], data[60], data[61], data[62]]).join('.');
    mac = Future.value(hexmac);
    ip = Future.value(ipstr);
    subnetMask = Future.value(subnetstr);
    gateway = Future.value(gatawaystr);
    mountedState(() {});
  }

  Future<void> readCache() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String? mac = prefs.getString("mac");
    if (mac == null) {
      return showSnackBar("未设置连接");
    }

    String? deviceData = prefs.getString(mac);
    if (deviceData == null) {
      return showSnackBar("未设置连接");
    }

    List<int> data = deviceData.split(',').map((e) => int.parse(e)).toList();
    updateUi(data);
  }

  Future<void> readHoldings1() async {
    try {
      List<int> data = await readDevice();
      updateUi(data);
    } catch (err) {
      debugPrint(err.toString());
      showSnackBar(err.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        readCache();
        await readHoldings1().whenComplete(() {
          debugPrint("读取完成");
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void closeAppUsingSystemPop() {
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  }

  void closeAppUsingExit() {
    exit(0);
  }

  Future<void> settingIplDialog(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (dialogContext) {
          bool isChecked = false;
          return StatefulBuilder(builder: (context, mountedState) {
            return AlertDialog(
              content: Form(
                key: _ipFormKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.url,
                      maxLength: 15,
                      maxLines: 1,
                      controller: _ipEditingController,
                      validator: (value) {
                        return value!.isNotEmpty ? null : "请输入IP地址";
                      },
                      decoration: const InputDecoration(
                        hintText: "IP地址(如:192.169.1.100)",
                      ),
                    ),
                  ],
                ),
              ),
              title: const Text('修改IP地址'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('取消'),
                ),
                TextButton(
                  onPressed: () async {
                    if (_ipFormKey.currentState?.validate() ?? false) {
                      String url = _ipEditingController.text;
                      debugPrint("URL: $url");
                      List<int> values = url
                          .trim()
                          .split(".")
                          .map((e) => int.parse(e))
                          .toList();
                      String req = await api.halGenerateSetHoldingsBulk(
                          unitId: 1,
                          reg: 2247,
                          values: Uint16List.fromList(values));
                      bool res = await setHoldings(req);

                      if (res) {
                        showSnackBar("修改成功");
                        await readHoldings1();
                      } else {
                        showSnackBar("修改失败，请重试");
                      }
                      Navigator.of(context).maybePop();
                    }
                  },
                  child: Text('修改'),
                )
              ],
            );
          });
        });
  }

  Future<void> settingAppTitle(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (dialogContext) {
          return StatefulBuilder(builder: (context, mountedState) {
            return AlertDialog(
              content: Form(
                key: _appTitleFormKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.text,
                      maxLength: 30,
                      maxLines: 2,
                      controller: _appTitleEditingController,
                      validator: (value) {
                        return value!.isNotEmpty ? null : "请输入公司名称";
                      },
                      decoration: const InputDecoration(
                        hintText: "如:深圳市XXX有限公司",
                      ),
                    ),
                  ],
                ),
              ),
              title: const Text('设置应用标题'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('取消'),
                ),
                TextButton(
                  onPressed: () async {
                    if (_appTitleFormKey.currentState?.validate() ?? false) {
                      final SharedPreferences prefs =
                          await SharedPreferences.getInstance();

                      bool res = await prefs.setString(
                          "appTitle", _appTitleEditingController.text);
                      if (res) {
                        showSnackBar("修改成功");
                        await readHoldings1();
                      } else {
                        showSnackBar("修改失败，请重试");
                      }
                      Navigator.of(context).maybePop();
                    }
                  },
                  child: Text('修改'),
                )
              ],
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SettingsList(
        platform: selectedPlatform,
        sections: [
          SettingsSection(
            title: Text('连接信息'),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: Icon(Icons.network_cell),
                title: Text('当前连接地址'),
                value: FutureBuilder(
                  future: _prefs.then((SharedPreferences prefs) {
                    return prefs.getString('mesh');
                  }),
                  initialData: 'NDID=',
                  builder: (context, AsyncSnapshot<String?> snapshot) {
                    if (snapshot.hasData &&
                        snapshot.connectionState == ConnectionState.done) {
                      String id = snapshot.data ?? '';
                      return Text(id);
                    }

                    return Text('NDID=');
                  },
                ),
              ),
            ],
          ),
          SettingsSection(
            title: Text("设备属性"),
            tiles: [
              SettingsTile.navigation(
                title: Text('MAC地址'),
                value: FutureBuilder(
                  future: mac,
                  initialData: '',
                  builder: (context, AsyncSnapshot<String?> snapshot) {
                    if (snapshot.hasData &&
                        snapshot.connectionState == ConnectionState.done) {
                      String id = snapshot.data ?? '';
                      return Text(id);
                    }

                    return Text('');
                  },
                ),
              ),
              SettingsTile.navigation(
                title: Text('IP地址'),
                onPressed: (c) {
                  settingIplDialog(c);
                },
                value: FutureBuilder(
                  future: ip,
                  initialData: '',
                  builder: (context, AsyncSnapshot<String?> snapshot) {
                    if (snapshot.hasData &&
                        snapshot.connectionState == ConnectionState.done) {
                      String id = snapshot.data ?? '';
                      return Text(id);
                    }

                    return Text('');
                  },
                ),
              ),
              SettingsTile.navigation(
                title: Text('子网掩码'),
                value: FutureBuilder(
                  future: subnetMask,
                  initialData: '',
                  builder: (context, AsyncSnapshot<String?> snapshot) {
                    if (snapshot.hasData &&
                        snapshot.connectionState == ConnectionState.done) {
                      String id = snapshot.data ?? '';
                      return Text(id);
                    }

                    return Text('');
                  },
                ),
              ),
              SettingsTile.navigation(
                title: Text('网关地址'),
                value: FutureBuilder(
                  future: gateway,
                  initialData: '',
                  builder: (context, AsyncSnapshot<String?> snapshot) {
                    if (snapshot.hasData &&
                        snapshot.connectionState == ConnectionState.done) {
                      String id = snapshot.data ?? '';
                      return Text(id);
                    }

                    return Text('');
                  },
                ),
              ),
              SettingsTile.navigation(
                title: Text('Modbus地址'),
                value: Text('1'),
              ),
            ],
          ),
          SettingsSection(
            title: Text('配置'),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: Icon(Icons.bluetooth_connected),
                title: Text('逻辑配置服务'),
                onPressed: (context) {
                  Navigation.navigateTo(
                    context: context,
                    screen: LogicControlSetting(),
                  );
                },
              ),
              SettingsTile.navigation(
                leading: Icon(Icons.bluetooth_connected),
                title: Text('RS485配置'),
                onPressed: (context) {
                  Navigation.navigateTo(
                    context: context,
                    screen: RS485Setting(),
                  );
                },
              ),
            ],
          ),
          SettingsSection(
            title: Text('帐户'),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                title: Text('公司名称'),
                onPressed: (c) {
                  settingAppTitle(c);
                },
                value: FutureBuilder(
                  future: _prefs.then((value) => value.getString("appTitle")),
                  initialData: '',
                  builder: (context, AsyncSnapshot<String?> snapshot) {
                    if (snapshot.hasData &&
                        snapshot.connectionState == ConnectionState.done) {
                      String comName = snapshot.data ?? '';
                      return Text(comName);
                    }

                    return Text('');
                  },
                ),
              ),
              SettingsTile.navigation(
                leading: Icon(Icons.logout),
                title: Text('关于我们'),
              ),
              SettingsTile.navigation(
                leading: Icon(Icons.logout),
                title: Text('退出应用'),
                onPressed: (context) => closeAppUsingSystemPop(),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.sync),
        tooltip: "同步",
        onPressed: () async {
          if (mounted) {
            await EasyLoading.show(status: '读取中...');
            await readHoldings1().whenComplete(() {
              debugPrint("读取完成");
              EasyLoading.dismiss();
            });
          }
        },
      ),
    );
  }
}

class PlatformPickerScreen extends StatelessWidget {
  const PlatformPickerScreen({
    Key? key,
    required this.platform,
    required this.platforms,
  }) : super(key: key);

  final DevicePlatform platform;
  final Map<DevicePlatform, String> platforms;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Platforms'),
      ),
      body: SettingsList(
        platform: platform,
        sections: [
          SettingsSection(
            title: Text('Select the platform you want'),
            tiles: platforms.keys.map((e) {
              final platform = platforms[e];

              return SettingsTile(
                title: Text(platform!),
                onPressed: (_) {
                  Navigator.of(context).pop(e);
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
