import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../injection/injection.dart';
import '../../models/genre.dart';
import '../../models/hashtag.dart';
import '../../services/firestore_service.dart';

class GenrePageStateNotifier extends StateNotifier<GenrePageState> {
  GenrePageStateNotifier(Genre genre) : super(GenrePageInitial()) {
    loadHashtags(genre);
  }

  FirestoreService _firestoreService = locator<FirestoreService>();

  void loadHashtags(Genre genre) async {
    state = GenrePageLoading();
    try {
      final hashtags = await _firestoreService.getHashtags(genre);
      if (hashtags.isEmpty) {
        throw Exception();
      }
      state = GenrePageLoaded(hashtags: hashtags);
    } catch (e) {
      print(e);
      state = GenrePageError();
    }
  }
}

@immutable
abstract class GenrePageState {}

class GenrePageInitial extends GenrePageState {}

class GenrePageLoading extends GenrePageState {}

class GenrePageError extends GenrePageState {}

class GenrePageLoaded extends GenrePageState {
  final List<Hashtag> hashtags;

  GenrePageLoaded({@required this.hashtags});
}

final genrePageStateProvider = StateNotifierProvider.family
    .autoDispose<GenrePageStateNotifier, GenrePageState, Genre>((ref, genre) {
  return GenrePageStateNotifier(genre);
});
