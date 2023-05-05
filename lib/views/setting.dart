import 'dart:io';

import 'package:flutter/services.dart';
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
  DevicePlatform selectedPlatform = DevicePlatform.web;

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _textEditingController = TextEditingController();

  late Future<String?> ndid = Future.value(null);
  Future<String?> mac = Future.value(null);
  Future<String?> ip = Future.value(null);
  Future<String?> subnetMask = Future.value(null);
  Future<String?> gateway = Future.value(null);

  @override
  void initState() {
    super.initState();
    api.bleGetNdid().then((value) {
      Uint8List? data = value.data;
      if (data != null) {
        String id = String.fromCharCodes(data);
        id = id.replaceAll(RegExp(r'[^\d]'), '');
        setState(() {
          ndid = Future.value(id);
        });
      }
    }).then((meshId) async {});

    _prefs.then((SharedPreferences prefs) {
      return prefs.getString('mesh');
    }).then((String? meshId) async {
      if (meshId != null) {
        List<int> data = await getHoldings(meshId, 2263, 5);
        String hexmac = data
            .map((e) => e.toRadixString(16).toUpperCase().padLeft(2, '0'))
            .join('-');
        setState(() {
          mac = Future.value(hexmac);
        });

        List<int> ipData = await getHoldings(meshId, 2247, 4);
        String hexIp = ipData.join('.');
        setState(() {
          ip = Future.value(hexIp);
        });

        List<int> subnetMaskData = await getHoldings(meshId, 2251, 4);
        setState(() {
          subnetMask = Future.value(subnetMaskData.join('.'));
        });

        List<int> gatewayData = await getHoldings(meshId, 2255, 4);
        setState(() {
          gateway = Future.value(gatewayData.join('.'));
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

  Future<void> showInformationDialog(BuildContext context) async {
    BuildContext _c = context;
    return await showDialog(
        context: context,
        builder: (context) {
          bool isChecked = false;
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              content: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        maxLength: 4,
                        maxLines: 1,
                        controller: _textEditingController,
                        validator: (value) {
                          return value!.isNotEmpty ? null : "请输入ID";
                        },
                        decoration:
                            InputDecoration(hintText: "四位蓝牙数字ID,如 1000"),
                      ),
                    ],
                  )),
              title: Text('修改本机蓝牙地址'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('取消'),
                ),
                TextButton(
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      String id = _textEditingController.text;

                      SerialResponse r2 = await api.bleNdreset();
                      Uint8List? data2 = r2.data;
                      if (data2 != null) {
                        showSnackBar(String.fromCharCodes(data2));
                      }

                      SerialResponse r1 = await api.bleSetNdid(id: id);
                      Uint8List? data1 = r1.data;
                      if (data1 != null) {
                        showSnackBar(String.fromCharCodes(data1));
                      }
                      SerialResponse r4 = await api.bleSetMode(mode: 2);
                      Uint8List? data4 = r4.data;
                      if (data4 != null) {
                        showSnackBar(String.fromCharCodes(data4));
                      }
                      SerialResponse r3 = await api.bleReboot();
                      Uint8List? data3 = r3.data;
                      if (data3 != null) {
                        showSnackBar(String.fromCharCodes(data3));
                      }

                      // closeAppUsingSystemPop();
                    }
                  },
                  child: Text('修改'),
                )
              ],
            );
          });
        });
  }

  Future<void> settingNetworkUrlDialog(BuildContext context) async {
    BuildContext _c = context;
    return await showDialog(
        context: context,
        builder: (context) {
          bool isChecked = false;
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              content: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.url,
                        maxLength: 100,
                        maxLines: 5,
                        controller: _textEditingController,
                        validator: (value) {
                          return value!.isNotEmpty ? null : "请输入服务地址";
                        },
                        decoration: InputDecoration(hintText: ""),
                      ),
                    ],
                  )),
              title: Text('设置服务地址'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('取消'),
                ),
                TextButton(
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      String url = _textEditingController.text;
                      SharedPreferences prefs = await _prefs;

                      prefs.setString('network_url', url);

                      Navigator.canPop(_c);
                    }
                  },
                  child: Text('设置'),
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
            title: Text('基本'),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: Icon(Icons.restore),
                title: Text('重启本机蓝牙'),
                onPressed: (context) async {
                  SerialResponse r2 = await api.bleNdreset();
                  Uint8List? data2 = r2.data;
                  if (data2 != null) {
                    showSnackBar(String.fromCharCodes(data2));
                    return;
                  }
                  showSnackBar("重启失败");
                },
              ),
              SettingsTile.navigation(
                leading: Icon(Icons.bluetooth_connected),
                title: Text('本机蓝牙地址'),
                value: FutureBuilder(
                  future: ndid,
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
                onPressed: (context) {
                  showInformationDialog(context);
                },
              ),
              SettingsTile.navigation(
                leading: Icon(Icons.network_cell),
                title: Text('直连地址'),
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
            title: Text('服务'),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: Icon(Icons.bluetooth_connected),
                title: Text('服务地址'),
                value: FutureBuilder(
                  future: _prefs.then((SharedPreferences prefs) {
                    return prefs.getString('network_url');
                  }),
                  initialData: '',
                  builder: (context, AsyncSnapshot<String?> snapshot) {
                    if (snapshot.hasData &&
                        snapshot.connectionState == ConnectionState.done) {
                      String url = snapshot.data ?? '';
                      return Text(url);
                    }

                    return Text('');
                  },
                ),
                onPressed: (context) {
                  settingNetworkUrlDialog(context);
                },
              ),
            ],
          ),
          SettingsSection(
            title: Text('帐户'),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: Icon(Icons.logout),
                title: Text('退出应用'),
                onPressed: (context) => closeAppUsingSystemPop(),
              ),
            ],
          ),
        ],
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
      appBar: AppBar(title: Text('Platforms')),
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
