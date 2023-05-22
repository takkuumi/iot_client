import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../ffi.io.dart';

class MutexLock extends StateNotifier<bool> {
  MutexLock() : super(false);

  void lock() {
    state = true;
  }

  void unlock() {
    state = false;
  }
}

final mutexLockProvider =
    StateNotifierProvider<MutexLock, bool>((ref) => MutexLock());

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

class ReadCoils extends StateNotifier<List<bool>> {
  ReadCoils() : super([]);

  void change(List<bool> coils) {
    state = coils;
  }
}

final appReadCoilsProvider =
    StateNotifierProvider<ReadCoils, List<bool>>((ref) {
  return ReadCoils();
});

class ReadWriteCoils extends StateNotifier<List<bool>> {
  ReadWriteCoils() : super([]);

  void change(List<bool> coils) {
    state = coils;
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

  void clear() {
    state = null;
  }
}

final deviceDisplayProvider =
    StateNotifierProvider<DeviceConfigure, DeviceDisplay?>((ref) {
  return DeviceConfigure();
});
