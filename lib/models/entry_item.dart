import 'package:cloud_firestore/cloud_firestore.dart';

class EntryItem {
  final String title;
  final String description;
  final DateTime published;
  final int likes;
  final String creatorId;
  final DocumentSnapshot doc;

  EntryItem({
    this.title,
    this.description,
    this.published,
    this.likes,
    this.creatorId,
    this.doc,
  });

  static EntryItem fromDocument(DocumentSnapshot doc) {
    ;
    return EntryItem(
      title: doc["title"],
      description: doc["description"],
      published: (doc["published"] as Timestamp).toDate(),
      likes: doc["likes"].length,
      creatorId: (doc.data() as Map).containsKey('creatorId')
          ? doc["creatorId"]
          : null,
      doc: doc,
    );
  }
}
