import 'package:flutter/material.dart';

enum NavigationRouteStyle {
  cupertino,
  material,
}

class Navigation {
  static Future<T?> navigateTo<T>({
    required BuildContext context,
    required Widget screen,
  }) async {
    late Route<T> route = MaterialPageRoute<T>(builder: (_) => screen);

    return await Navigator.push<T>(context, route);
  }
}
