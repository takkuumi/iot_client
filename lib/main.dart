import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'my_app.dart';
import 'package:json_theme/json_theme.dart';
import 'dart:convert'; // For jsonDecode

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final themeStr = await rootBundle.loadString('assets/appainter_theme.json');
  final themeJson = jsonDecode(themeStr);
  final theme = ThemeDecoder.decodeThemeData(themeJson)!;

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.light,
  ));
  // 强制竖屏
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge,
      overlays: <SystemUiOverlay>[]);
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  ).then((_) {
    runApp(MyApp(theme: theme));
  });
}
