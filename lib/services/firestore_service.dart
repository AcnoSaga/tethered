import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:injectable/injectable.dart';
import 'package:tethered/models/account.dart';
import 'package:tethered/models/book_cover.dart';
import 'package:tethered/models/book_details.dart';
import 'package:tethered/models/category_lists.dart';
import 'package:tethered/models/draft.dart';
import 'package:tethered/models/genre.dart';
import 'package:tethered/models/hashtag.dart';
import 'package:tethered/models/published_draft.dart';

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

  Future<Hashtag> getHashtagById(String id) async {
    final doc = await firestore.collection('hashtags').doc(id).get();
    return Hashtag.fromDocument(doc);
  }

  Future<CategoryLists> getNewStoryPageData() async {
    final doc = await firestore.collection('categories').doc('list').get();
    return CategoryLists.fromDocument(doc);
  }

  Future<List<Draft>> getDrafts(Draft item) async {
    final query = item == null
        ? await firestore
            .collection(
                "accounts/" + FirebaseAuth.instance.currentUser.uid + "/drafts")
            .orderBy('lastUpdated', descending: true)
            .limit(10)
            .get()
        : await firestore
            .collection(
                "accounts/" + FirebaseAuth.instance.currentUser.uid + "/drafts")
            .orderBy('lastUpdated', descending: true)
            .limit(10)
            .startAfterDocument(item.doc)
            .get();
    return query.docs.map((doc) => Draft.fromDocument(doc)).toList();
  }

  Future<List<PublishedDraft>> getPublishedDrafts(PublishedDraft item) async {
    final query = item == null
        ? await firestore
            .collection("accounts/" +
                FirebaseAuth.instance.currentUser.uid +
                "/published")
            .orderBy('published', descending: true)
            .limit(10)
            .get()
        : await firestore
            .collection("accounts/" +
                FirebaseAuth.instance.currentUser.uid +
                "/published")
            .orderBy('published', descending: true)
            .limit(10)
            .startAfterDocument(item.doc)
            .get();
    return query.docs.map((doc) => PublishedDraft.fromDocument(doc)).toList();
  }

  Future<Delta> getEditPageData(DocumentReference docRef) async {
    final doc = await docRef.get(GetOptions(source: Source.server));
    return Delta.fromJson(doc["content"]);
  }

  Future<List<DocumentSnapshot>> getBookCovers(
      String uid, DocumentSnapshot bookCover) async {
    final query = bookCover == null
        ? await firestore
            .collection('accounts/$uid/published')
            .orderBy('published', descending: true)
            .limit(10)
            .get()
        : await firestore
            .collection('accounts/$uid/published')
            .orderBy('published', descending: true)
            .limit(10)
            .startAfterDocument(bookCover)
            .get();

    return query.docs;
  }

  Future<Account> getAccount(String uid) async {
    final doc = await firestore.collection('accounts').doc(uid).get();
    return Account.fromDocument(doc);
  }
}
