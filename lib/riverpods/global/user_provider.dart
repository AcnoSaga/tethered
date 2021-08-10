import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../models/tethered_user.dart';

class UserStateNotifier extends StateNotifier<TetheredUser> {
  UserStateNotifier() : super(null);

  void getUserData(String uid) async {
    state = await TetheredUser.fromUserId(uid);
    print(state);
  }

  void reset() {
    state = null;
  }
}

final userProvider =
    StateNotifierProvider<UserStateNotifier, TetheredUser>((ref) {
  return UserStateNotifier();
});
