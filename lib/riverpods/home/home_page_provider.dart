import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../injection/injection.dart';
import '../../models/genre.dart';
import '../../services/firestore_service.dart';

class HomePageStateNotifier extends StateNotifier<HomePageState> {
  HomePageStateNotifier() : super(HomePageInitial()) {
    loadGenres();
  }

  FirestoreService _firestoreService = locator<FirestoreService>();

  void loadGenres() async {
    state = HomePageLoading();
    try {
      final genres = await _firestoreService.getHomeGenres();
      if (genres.isEmpty) {
        throw Exception();
      }
      state =
          HomePageLoaded(genres: genres..insert(0, Genre(name: 'Top Picks')));
    } catch (e) {
      state = HomePageError();
    }
  }
}

@immutable
abstract class HomePageState {}

class HomePageInitial extends HomePageState {}

class HomePageLoading extends HomePageState {}

class HomePageError extends HomePageState {}

class HomePageLoaded extends HomePageState {
  final List<Genre> genres;

  HomePageLoaded({@required this.genres});
}

final homePageStateProvider =
    StateNotifierProvider<HomePageStateNotifier, HomePageState>((ref) {
  return HomePageStateNotifier();
});
