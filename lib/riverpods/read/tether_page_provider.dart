import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../injection/injection.dart';
import '../../models/Tether.dart';
import '../../services/firestore_service.dart';

class TetherPageStateNotifier extends StateNotifier<TetherPageState> {
  TetherPageStateNotifier(DocumentReference tetherRef)
      : super(TetherPageInitial()) {
    loadTether(tetherRef);
  }

  FirestoreService _firestoreService = locator<FirestoreService>();

  void loadTether(DocumentReference tetherRef) async {
    state = TetherPageLoading();
    try {
      final tether = await _firestoreService.getTether(tetherRef);
      if (tether == null) {
        throw Exception();
      }
      state = TetherPageLoaded(tether: tether);
    } catch (e) {
      print(e);
      state = TetherPageError();
    }
  }
}

@immutable
abstract class TetherPageState {}

class TetherPageInitial extends TetherPageState {}

class TetherPageLoading extends TetherPageState {}

class TetherPageError extends TetherPageState {}

class TetherPageLoaded extends TetherPageState {
  final Tether tether;

  TetherPageLoaded({@required this.tether});
}

final tetherPageStateProvider = StateNotifierProvider.family
    .autoDispose<TetherPageStateNotifier, TetherPageState, DocumentReference>(
        (ref, tetherRef) {
  return TetherPageStateNotifier(tetherRef);
});
