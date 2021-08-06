import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tethered/injection/injection.dart';
import 'package:tethered/models/catergory_lists.dart';
import 'package:tethered/services/firestore_service.dart';

class NewStoryPageStateNotifier extends StateNotifier<NewStoryPageState> {
  NewStoryPageStateNotifier() : super(NewStoryPageInitial()) {
    loadNewStoryPageData();
  }

  FirestoreService _firestoreService = locator<FirestoreService>();

  void loadNewStoryPageData() async {
    state = NewStoryPageLoading();
    try {
      final categoryLists = await _firestoreService.getNewStoryPageData();
      if (categoryLists.genres.isEmpty || categoryLists.hashtags.isEmpty) {
        throw Exception();
      }
      state = NewStoryPageLoaded(categoryLists: categoryLists);
    } catch (e) {
      print(e);
      state = NewStoryPageError();
    }
  }
}

@immutable
abstract class NewStoryPageState {}

class NewStoryPageInitial extends NewStoryPageState {}

class NewStoryPageLoading extends NewStoryPageState {}

class NewStoryPageError extends NewStoryPageState {}

class NewStoryPageLoaded extends NewStoryPageState {
  final CategoryLists categoryLists;

  NewStoryPageLoaded({@required this.categoryLists});
}

final newStoryPageStateProvider = StateNotifierProvider.autoDispose<
    NewStoryPageStateNotifier, NewStoryPageState>((ref) {
  return NewStoryPageStateNotifier();
});
