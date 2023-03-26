import 'dart:io';

import 'package:flutter/services.dart';
import 'package:iot_client/ffi.dart';
import 'package:flutter/material.dart';
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
  DevicePlatform selectedPlatform = DevicePlatform.device;

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _textEditingController = TextEditingController();

  Future<String?> ndid = Future.value(null);

  @override
  void initState() {
    api.getNdid().then((value) {
      String id = String.fromCharCodes(value);
      setState(() {
        ndid = Future.value(id);
      });
    });
    super.initState();
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

                      Uint8List r2 = await api.ndreset();
                      showSnackBar(String.fromCharCodes(r2));
                      Uint8List r1 = await api.setNdid(id: id);
                      showSnackBar(String.fromCharCodes(r1));
                      Uint8List r4 = await api.setMode(mode: 2);
                      showSnackBar(String.fromCharCodes(r4));
                      Uint8List r3 = await api.reboot();
                      showSnackBar(String.fromCharCodes(r3));

                      closeAppUsingSystemPop();
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
                leading: Icon(Icons.bluetooth_connected),
                title: Text('本机蓝牙地址'),
                value: FutureBuilder(
                  future: ndid,
                  initialData: 'NDID=',
                  builder: (context, AsyncSnapshot<String?> snapshot) {
                    if (snapshot.hasData &&
                        snapshot.connectionState == ConnectionState.done) {
                      String id = snapshot.data ?? '';
                      id = id.replaceAll(RegExp(r'\r|\n|\+'), '');
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
