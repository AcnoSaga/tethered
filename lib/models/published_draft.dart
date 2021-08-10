import 'package:cloud_firestore/cloud_firestore.dart';

class PublishedDraft {
  final String title;
  final DocumentSnapshot doc;

  PublishedDraft({this.title, this.doc});

  static PublishedDraft fromDocument(DocumentSnapshot doc) {
    return PublishedDraft(
      title: doc["title"],
      doc: doc,
    );
  }
}
