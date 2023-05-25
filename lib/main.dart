import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iot_client/ffi.io.dart';
import 'my_app.dart';
import 'package:json_theme/json_theme.dart';
import 'dart:convert'; // For jsonDecode

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final themeStr = await rootBundle.loadString('assets/appainter_theme.json');
  final themeJson = jsonDecode(themeStr);
  final theme = ThemeDecoder.decodeThemeData(themeJson)!;

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  // 强制竖屏
  // SystemChrome.setEnabledSystemUIMode(
  //   SystemUiMode.manual,
  //   overlays: <SystemUiOverlay>[SystemUiOverlay.top],
  // );
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await api.bleReboot().whenComplete(() {
    debugPrint("重启蓝牙完成");
  });
  runApp(ProviderScope(child: App(theme: theme)));
}
