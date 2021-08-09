import 'package:cloud_firestore/cloud_firestore.dart';

class Tether {
  final String content;
  final int likes;
  final DocumentSnapshot doc;
  final String title;
  final String description;

  Tether({
    this.content,
    this.likes,
    this.doc,
    this.title,
    this.description,
  });

  static Tether fromDocument(DocumentSnapshot<Object> doc) {
    return Tether(
      content: doc["content"],
      likes: doc["likes"].length,
      title: doc["title"],
      description: doc["description"],
      doc: doc,
    );
  }
}
