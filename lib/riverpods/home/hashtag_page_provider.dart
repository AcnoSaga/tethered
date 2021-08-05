import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tethered/injection/injection.dart';
import 'package:tethered/models/hashtag.dart';
import 'package:tethered/services/firestore_service.dart';

class HashtagPageStateNotifier extends StateNotifier<HashtagPageState> {
  HashtagPageStateNotifier(String id) : super(HashtagPageInitial()) {
    loadHashtag(id);
  }

  FirestoreService _firestoreService = locator<FirestoreService>();

  void loadHashtag(String hashtagId) async {
    state = HashtagPageLoading();
    try {
      final hashtag = await _firestoreService.getHashtagById(hashtagId);
      if (hashtag.works.isEmpty) {
        throw Exception();
      }
      state = HashtagPageLoaded(hashtag: hashtag);
    } catch (e) {
      print(e);
      state = HashtagPageError();
    }
  }
}

@immutable
abstract class HashtagPageState {}

class HashtagPageInitial extends HashtagPageState {}

class HashtagPageLoading extends HashtagPageState {}

class HashtagPageError extends HashtagPageState {}

class HashtagPageLoaded extends HashtagPageState {
  final Hashtag hashtag;

  HashtagPageLoaded({@required this.hashtag});
}

final hashtagPageStateProvider = StateNotifierProvider.family
    .autoDispose<HashtagPageStateNotifier, HashtagPageState, String>((ref, id) {
  return HashtagPageStateNotifier(id);
});
