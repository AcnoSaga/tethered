import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../injection/injection.dart';
import '../../../models/book_cover.dart';
import '../../../models/book_details.dart';
import '../../../services/firestore_service.dart';

class BookDetailsStateNotifier extends StateNotifier<BookDetailsState> {
  BookDetailsStateNotifier(BookCover bookCover) : super(BookDetailsInitial()) {
    loadBookDetails(bookCover);
  }

  FirestoreService _firestoreService = locator<FirestoreService>();

  void loadBookDetails(BookCover bookCover) async {
    state = BookDetailsLoading();
    try {
      final bookDetails = await _firestoreService.getBookDetails(bookCover);
      if (bookDetails == null) {
        throw Exception();
      }
      state = BookDetailsLoaded(bookDetails: bookDetails);
    } catch (e) {
      print(e);
      state = BookDetailsError();
    }
  }
}

@immutable
abstract class BookDetailsState {}

class BookDetailsInitial extends BookDetailsState {}

class BookDetailsLoading extends BookDetailsState {}

class BookDetailsError extends BookDetailsState {}

class BookDetailsLoaded extends BookDetailsState {
  final BookDetails bookDetails;

  BookDetailsLoaded({@required this.bookDetails});
}

final bookDetailsStateProvider = StateNotifierProvider.family
    .autoDispose<BookDetailsStateNotifier, BookDetailsState, BookCover>(
        (ref, bookCover) {
  return BookDetailsStateNotifier(bookCover);
});

final bookDetailsStateProviderProvider = Provider.family.autoDispose<
    AutoDisposeStateNotifierProvider<BookDetailsStateNotifier,
        BookDetailsState>,
    BookDetailsStateProviderProviderData>((ref, data) {
  final carouselIndex = ref.watch(data.provider);
  return bookDetailsStateProvider(data.bookCovers[carouselIndex.state]);
});

class BookDetailsStateProviderProviderData {
  final StateProvider<int> provider;
  final List<BookCover> bookCovers;

  BookDetailsStateProviderProviderData({
    @required this.provider,
    @required this.bookCovers,
  });
}
