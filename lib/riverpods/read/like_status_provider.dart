import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../injection/injection.dart';
import '../../models/Tether.dart';
import '../../services/firestore_service.dart';

class LikeStatusStateNotifier extends StateNotifier<LikeStatusState> {
  LikeStatusStateNotifier(DocumentReference tetherRef)
      : super(LikeStatusInitial()) {
    loadTether(tetherRef);
  }

  FirestoreService _firestoreService = locator<FirestoreService>();

  void loadTether(DocumentReference tetherRef) async {
    state = LikeStatusLoading();
    try {
      final tether = await _firestoreService.getTether(tetherRef);
      if (tether == null) {
        throw Exception();
      }
      state = LikeStatusLoaded(tether: tether);
    } catch (e) {
      print(e);
      state = LikeStatusError();
    }
  }
}

@immutable
abstract class LikeStatusState {}

class LikeStatusInitial extends LikeStatusState {}

class LikeStatusLoading extends LikeStatusState {}

class LikeStatusError extends LikeStatusState {}

class LikeStatusLoaded extends LikeStatusState {
  final Tether tether;

  LikeStatusLoaded({@required this.tether});
}

final LikeStatusStateProvider = StateNotifierProvider.family
    .autoDispose<LikeStatusStateNotifier, LikeStatusState, DocumentReference>(
        (ref, tetherRef) {
  return LikeStatusStateNotifier(tetherRef);
});
