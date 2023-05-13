import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iot_client/model/chinfo.dart';
import 'package:iot_client/model/device.dart';

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
