import 'package:flutter/material.dart';

class Device {
  int no;
  int addressType;
  String mac;
  String name;
  Device(this.no, this.addressType, this.mac, this.name);

  bool contains(String name) {
    return this.name == name;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Device && other.name == name;
  }

  @override
  int get hashCode => name.hashCode ^ mac.hashCode;
}

List<Device> parseDevices(String text) {
  List<Device> devices = [];
  text
      .split(RegExp(r'\r\n'))
      .where((element) => element.startsWith("+SCAN"))
      .where((element) => element.contains('FSC') || element.contains('Mesh'))
      .map((e) => e.replaceAll(RegExp(r'\+SCAN='), ''))
      .forEach((e) {
    debugPrint(e);
    List<String> items = e.split(',').map((e) => e.trim()).toList();

    if (items.length == 6) {
      int no = int.parse(items[0]);
      int addressType = int.parse(items[1]);
      String mac = items[2];
      int length = int.parse(items[4]);
      String name = items[5];

      if (name.length == length) {
        devices.add(Device(no, addressType, mac, name));
      }
    }
  });

  return devices;
}
