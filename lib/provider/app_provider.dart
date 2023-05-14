import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iot_client/model/chinfo.dart';

import '../ffi.dart';

class AppTitle extends StateNotifier<String> {
  AppTitle() : super("Flutter demo");

  void changeTitle(String title) {
    state = title;
  }
}

final appTitleProvider = StateNotifierProvider<AppTitle, String>((ref) {
  return AppTitle();
});

class AppPageTitle extends StateNotifier<String> {
  AppPageTitle() : super("demo");

  void changeTitle(String title) {
    state = title;
  }
}

final appPageTitleProvider = StateNotifierProvider<AppPageTitle, String>((ref) {
  return AppPageTitle();
});

class BleChinfos extends StateNotifier<List<Chinfo>> {
  BleChinfos() : super([]);

  void changeDevice(List<Chinfo> chinfos) {
    if (chinfos.isNotEmpty) {
      state = chinfos;
    }
  }
}

final appConnectedProvider =
    StateNotifierProvider<BleChinfos, List<Chinfo>>((ref) {
  return BleChinfos();
});

class ReadCoils extends StateNotifier<List<bool>> {
  ReadCoils() : super([]);

  void change(List<bool> coils) {
    if (coils.isNotEmpty) {
      state = coils;
    }
  }
}

final appReadCoilsProvider =
    StateNotifierProvider<ReadCoils, List<bool>>((ref) {
  return ReadCoils();
});

class ReadWriteCoils extends StateNotifier<List<bool>> {
  ReadWriteCoils() : super([]);

  void change(List<bool> coils) {
    if (coils.isNotEmpty) {
      state = coils;
    }
  }
}

final appReadWriteCoilsProvider =
    StateNotifierProvider<ReadWriteCoils, List<bool>>((ref) {
  return ReadWriteCoils();
});

class DeviceConfigure extends StateNotifier<DeviceDisplay?> {
  DeviceConfigure() : super(null);

  void change(DeviceDisplay deviceDisplay) {
    state = deviceDisplay;
  }
}

final deviceDisplayProvider =
    StateNotifierProvider<DeviceConfigure, DeviceDisplay?>((ref) {
  return DeviceConfigure();
});
