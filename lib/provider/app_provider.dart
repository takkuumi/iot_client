import 'package:hooks_riverpod/hooks_riverpod.dart';

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
