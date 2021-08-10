import 'package:cloud_firestore/cloud_firestore.dart';

class IndexItem {
  final String title;
  final String description;
  final DateTime published;
  final int likes;
  final DocumentSnapshot doc;

  IndexItem({
    this.title,
    this.description,
    this.published,
    this.likes,
    this.doc,
  });

  static IndexItem fromDocument(DocumentSnapshot doc) {
    return IndexItem(
      title: doc["title"],
      description: doc["description"],
      published: (doc["published"] as Timestamp).toDate(),
      likes: doc["likes"],
      doc: doc,
    );
  }
}
