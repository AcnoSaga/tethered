import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:injectable/injectable.dart';
import 'package:tethered/utils/network_handler.dart';
import '../models/Tether.dart';
import '../models/account.dart';
import '../models/book_cover.dart';
import '../models/book_details.dart';
import '../models/category_lists.dart';
import '../models/comment.dart';
import '../models/draft.dart';
import '../models/entry_item.dart';
import '../models/genre.dart';
import '../models/hashtag.dart';
import '../models/index_item.dart';
import '../models/published_draft.dart';

@lazySingleton
class FirestoreService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  NetworkHandler _networkHandler = NetworkHandler(
      baseURL: 'https://secret-bastion-04725.herokuapp.com/api/v1/');

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
    print(bookCover.workRef);
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
    return Delta.fromJson(jsonDecode(doc["content"]));
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

  Future<Tether> getTether(DocumentReference workRef) async {
    final doc = await workRef.get();
    return Tether.fromDocument(doc);
  }

  Future<List<Comment>> getComments(
      Comment lastComment, CollectionReference collectionRef) async {
    final query = lastComment == null
        ? await collectionRef
            .orderBy('published', descending: true)
            .limit(10)
            .get()
        : await collectionRef
            .orderBy('published', descending: true)
            .limit(10)
            .startAfterDocument(lastComment.doc)
            .get();
    return query.docs.map((doc) => Comment.fromDocument(doc)).toList();
  }

  Future<List<IndexItem>> getIndexItems(
      IndexItem lastIndexItem, BookDetails bookDetails) async {
    final query = lastIndexItem == null
        ? await bookDetails.doc.reference
            .collection('index')
            .orderBy('published')
            .limit(10)
            .get()
        : await bookDetails.doc.reference
            .collection('index')
            .limit(10)
            .orderBy('published')
            .startAfterDocument(lastIndexItem.doc)
            .get();
    return query.docs.map((doc) => IndexItem.fromDocument(doc)).toList();
  }

  Future<List<EntryItem>> getEntryItems(
      EntryItem lastEntryItem, BookDetails bookDetails) async {
    final query = lastEntryItem == null
        ? await bookDetails.doc.reference
            .collection('proposalIndex')
            .orderBy(FieldPath.documentId)
            .limit(10)
            .get()
        : await bookDetails.doc.reference
            .collection('proposalIndex')
            .limit(10)
            .startAfterDocument(lastEntryItem.doc)
            .get();
    return query.docs.map((doc) => EntryItem.fromDocument(doc)).toList();
  }

  Future<bool> submitDraft(String docPath, String workRef, String uid) async {
    try {
      Map data = {
        'docPath': docPath,
        'workRef': workRef,
        'uid': uid,
      };
      return (await _networkHandler.post('submitdraft', data))['success'];
    } catch (e) {
      return false;
    }
  }
   Future<bool> submitNewStory(String docPath, String uid) async {
    try {
      Map data = {
        'docPath': docPath,
        'uid': uid,
      };
      return (await _networkHandler.post('submitdraft', data))['success'];
    } catch (e) {
      return false;
    }
  }
}
