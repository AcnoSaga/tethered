import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:tethered/models/book_cover.dart';
import 'package:tethered/models/book_details.dart';
import 'package:tethered/models/genre.dart';
import 'package:tethered/models/hashtag.dart';

@lazySingleton
class FirestoreService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<Genre>> getHomeGenres() async {
    List<Genre> genres = [];
    QuerySnapshot querySnapshot = await firestore
        .collection('genres')
        .where(
          'isOnHome',
          isEqualTo: true,
        )
        .get();
    querySnapshot.docs.forEach((doc) {
      genres.add(Genre.fromDocument(doc));
    });
    return genres;
  }

  Future<List<Hashtag>> getHashtags(Genre genre) async {
    List<Hashtag> hashtags = [];
    QuerySnapshot querySnapshot = await firestore
        .collection('hashtags')
        .where(FieldPath.documentId, whereIn: genre.hashtags)
        .get();
    querySnapshot.docs.forEach((doc) {
      hashtags.add(Hashtag.fromDocument(doc));
    });
    return hashtags;
  }

  Future<BookDetails> getBookDetails(BookCover bookCover) async {
    final docSnapshot = await bookCover.workRef.get();
    return BookDetails.fromDocument(docSnapshot);
  }
}
