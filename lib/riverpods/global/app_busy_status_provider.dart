import 'package:hooks_riverpod/hooks_riverpod.dart';

class AppBusyStatusNotifier extends StateNotifier<bool> {
  AppBusyStatusNotifier() : super(false);

  void startWork() {
    state = true;
  }

  void endWork() {
    state = false;
  }
}

final appBusyStatusProvider = StateNotifierProvider<AppBusyStatusNotifier, bool>((ref) {
  return AppBusyStatusNotifier();
});
