import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tethered/injection/injection.dart';
import 'package:tethered/models/account.dart';
import 'package:tethered/services/firestore_service.dart';

class AccountPageStateNotifier extends StateNotifier<AccountPageState> {
  AccountPageStateNotifier(String uid) : super(AccountPageInitial()) {
    loadBooks(uid);
  }

  FirestoreService _firestoreService = locator<FirestoreService>();

  void loadBooks(String uid) async {
    state = AccountPageLoading();
    try {
      final account = await _firestoreService.getAccount(uid);
      if (account == null) {
        throw Exception();
      }
      state = AccountPageLoaded(account: account);
    } catch (e) {
      print(e);
      state = AccountPageError();
    }
  }
}

@immutable
abstract class AccountPageState {}

class AccountPageInitial extends AccountPageState {}

class AccountPageLoading extends AccountPageState {}

class AccountPageError extends AccountPageState {}

class AccountPageLoaded extends AccountPageState {
  final Account account;

  AccountPageLoaded({@required this.account});
}

final accountPageStateProvider = StateNotifierProvider.family
    .autoDispose<AccountPageStateNotifier, AccountPageState, String>(
        (ref, uid) {
  return AccountPageStateNotifier(uid);
});
