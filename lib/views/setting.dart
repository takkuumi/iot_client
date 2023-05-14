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
import 'package:material_symbols_icons/symbols.dart';
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
  final TextEditingController _textEditingController = TextEditingController();

  final GlobalKey<FormState> _appTitleFormKey = GlobalKey<FormState>();
  final TextEditingController _appTitleEditingController =
      TextEditingController();

  final GlobalKey<FormState> _ipFormKey = GlobalKey<FormState>();
  final TextEditingController _ipEditingController = TextEditingController();

  final GlobalKey<FormState> _subnetMaskFormKey = GlobalKey<FormState>();
  final TextEditingController _subnetMaskEditingController =
      TextEditingController();

  final GlobalKey<FormState> _gatewayFormKey = GlobalKey<FormState>();
  final TextEditingController _gatewayEditingController =
      TextEditingController();

  final GlobalKey<FormState> _macFormKey = GlobalKey<FormState>();
  final TextEditingController _macController = TextEditingController();

  late Future<String?> ndid = Future.value(null);
  Future<String?> mac = Future.value(null);
  Future<String?> ip = Future.value(null);
  Future<String?> subnetMask = Future.value(null);
  Future<String?> gateway = Future.value(null);

  bool isMacAddress(String input) {
    RegExp macPattern = RegExp(r'^([0-9A-Fa-f]{2}[\-]){5}([0-9A-Fa-f]{2})$');
    return macPattern.hasMatch(input);
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void updateUi(DeviceDisplay deviceDisplay) {
    mac = Future.value(deviceDisplay.mac);
    ip = Future.value(deviceDisplay.localIp);
    subnetMask = Future.value(deviceDisplay.subnetMask);
    gateway = Future.value(deviceDisplay.gateway);
    setState(() {});
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

    // List<int> data = deviceData.split(',').map((e) => int.parse(e)).toList();
    // updateUi(data);
  }

  Future<void> readHoldings1() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    int? index = prefs.getInt("no");
    if (index == null) {
      return showSnackBar("未设置连接");
    }
    try {
      DeviceDisplay? deviceDisplay =
          await api.halReadDeviceSettings(index: index);
      if (deviceDisplay == null) {
        return showSnackBar("读取设备出错");
      }
      updateUi(deviceDisplay);
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

  Future<void> settingSubnetMasklDialog(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (dialogContext) {
          return StatefulBuilder(builder: (context, mountedState) {
            return AlertDialog(
              content: Form(
                key: _subnetMaskFormKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.url,
                      maxLength: 15,
                      maxLines: 1,
                      controller: _subnetMaskEditingController,
                      validator: (value) {
                        return value!.isNotEmpty ? null : "子网掩码";
                      },
                      decoration: const InputDecoration(
                        hintText: "子网掩码(如:255.255.255.0)",
                      ),
                    ),
                  ],
                ),
              ),
              title: const Text('修改子网掩码'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('取消'),
                ),
                TextButton(
                  onPressed: () async {
                    if (_subnetMaskFormKey.currentState?.validate() ?? false) {
                      String url = _subnetMaskEditingController.text;
                      debugPrint("URL: $url");
                      List<int> values = url
                          .trim()
                          .split(".")
                          .map((e) => int.parse(e))
                          .toList();
                      String req = await api.halGenerateSetHoldingsBulk(
                          unitId: 1,
                          reg: 2176 + 75,
                          values: Uint16List.fromList(values));
                      bool res = await setHoldings(req);

                      if (res) {
                        showSnackBar("修改成功");
                        _subnetMaskEditingController.text = '';
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

  Future<void> settingGatewaylDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(builder: (context, mountedState) {
          return AlertDialog(
            content: Form(
              key: _gatewayFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    keyboardType: TextInputType.url,
                    maxLength: 15,
                    maxLines: 1,
                    controller: _gatewayEditingController,
                    validator: (value) {
                      return value!.isNotEmpty ? null : "网关地址";
                    },
                    decoration: const InputDecoration(
                      hintText: "网关地址(如:192.168.1.1)",
                    ),
                  ),
                ],
              ),
            ),
            title: const Text('修改网关地址'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('取消'),
              ),
              TextButton(
                onPressed: () async {
                  if (_gatewayFormKey.currentState?.validate() ?? false) {
                    String url = _gatewayEditingController.text;
                    debugPrint("URL: $url");
                    List<int> values =
                        url.trim().split(".").map((e) => int.parse(e)).toList();
                    String req = await api.halGenerateSetHoldingsBulk(
                        unitId: 1,
                        reg: 2176 + 79,
                        values: Uint16List.fromList(values));
                    bool res = await setHoldings(req);

                    if (res) {
                      showSnackBar("修改成功");
                      _gatewayEditingController.text = "";
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
      },
    );
  }

  Future<void> settingIplDialog(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (dialogContext) {
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
                        _ipEditingController.text = '';
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

  Future<void> settingMaclDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(builder: (context, mountedState) {
          return AlertDialog(
            content: Form(
              key: _macFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    keyboardType: TextInputType.text,
                    maxLength: 17,
                    maxLines: 1,
                    controller: _macController,
                    validator: (value) {
                      if (value == null || value.isEmpty) return "请输入MAC地址";
                      if (!isMacAddress(value)) return "非法MAC地址";
                      return null;
                    },
                    decoration: const InputDecoration(
                      hintText: "MAC地址(如:00-10-39-0F-71-45)",
                    ),
                  ),
                ],
              ),
            ),
            title: const Text('修改MAC地址'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('取消'),
              ),
              TextButton(
                onPressed: () async {
                  if (_macFormKey.currentState?.validate() ?? false) {
                    String url = _macController.text;
                    debugPrint("URL: $url");
                    String value = url.trim().replaceAll(RegExp(r"\-"), '');
                    Uint16List values = Uint16List.fromList(List.generate(
                        6,
                        (index) => int.parse(
                            value.substring(index * 2, index * 2 + 2),
                            radix: 16)));
                    String req = await api.halGenerateSetHoldingsBulk(
                        unitId: 1,
                        reg: 2176 + 87,
                        values: Uint16List.fromList(values));
                    bool res = await setHoldings(req);

                    if (res) {
                      showSnackBar("修改成功");
                      _macController.text = '';
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
      },
    );
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
      resizeToAvoidBottomInset: true,
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
                    return prefs.getString('mac');
                  }),
                  initialData: 'MAC=',
                  builder: (context, AsyncSnapshot<String?> snapshot) {
                    if (snapshot.hasData &&
                        snapshot.connectionState == ConnectionState.done) {
                      String id = snapshot.data ?? '';
                      return Text(id);
                    }

                    return Text('MAC=');
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
                onPressed: (c) {
                  settingMaclDialog(c);
                },
                value: FutureBuilder(
                  future: mac,
                  initialData: '00-00-00-00-00-00',
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
                onPressed: (c) {
                  settingSubnetMasklDialog(c);
                },
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
                onPressed: (c) {
                  settingGatewaylDialog(c);
                },
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
                leading: Icon(Symbols.rebase_edit),
                title: Text('逻辑配置服务'),
                onPressed: (context) {
                  Navigation.navigateTo(
                    context: context,
                    screen: LogicControlSetting(),
                  );
                },
              ),
              SettingsTile.navigation(
                leading: Icon(Symbols.settings_input_component),
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
                leading: Icon(Symbols.location_city),
                title: Text('应用标题'),
                onPressed: (c) {
                  settingAppTitle(c);
                },
                value: FutureBuilder(
                  future: _prefs
                      .then((value) => value.getString("appTitle")?.trim()),
                  initialData: '',
                  builder: (context, AsyncSnapshot<String?> snapshot) {
                    if (snapshot.hasData &&
                        snapshot.connectionState == ConnectionState.done) {
                      String comName = snapshot.data ?? '';
                      return Text(comName);
                    }

                    return Text('未设置');
                  },
                ),
              ),
              SettingsTile.navigation(
                leading: Icon(Symbols.account_circle),
                title: Text('关于我们'),
              ),
              SettingsTile.navigation(
                leading: Icon(Symbols.exit_to_app),
                title: Text('退出应用'),
                onPressed: (context) => closeAppUsingSystemPop(),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Symbols.refresh),
        tooltip: "同步",
        onPressed: () async {
          if (mounted) {
            EasyLoading.show(status: '读取中...');
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
