import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tethered/models/tethered_user.dart';

class UserStateNotifier extends StateNotifier<TetheredUser> {
  UserStateNotifier() : super(null);

  void getUserData(String uid) async {
    state = await TetheredUser.fromUserId(uid);
    print(state);
  }

  void reset() {
    state = null;
    print('--------------------------------sas----------------------------');
  }
}

final userProvider =
    StateNotifierProvider<UserStateNotifier, TetheredUser>((ref) {
  return UserStateNotifier();
});
