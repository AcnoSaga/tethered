import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String content;
  final String imageUrl;
  final DateTime published;
  final String username;
  final DocumentReference userRef;
  final DocumentSnapshot doc;

  Comment({
    this.content,
    this.imageUrl,
    this.published,
    this.username,
    this.userRef,
    this.doc,
  });

  static Comment fromDocument(DocumentSnapshot doc) {
    return Comment(
      content: doc['content'],
      imageUrl: doc['imageUrl'],
      published: (doc['published'] as Timestamp).toDate(),
      username: doc['username'],
      userRef: doc['userRef'],
      doc: doc,
    );
  }
}
