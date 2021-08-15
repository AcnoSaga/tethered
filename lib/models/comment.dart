import 'package:cloud_firestore/cloud_firestore.dart';
import 'tethered_user.dart';

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

  static Comment fromStringAndUser(String text, TetheredUser tetheredUser) {
    print(tetheredUser);
    if (tetheredUser == null) {
      throw Exception();
    }
    return Comment(
      content: text,
      imageUrl: tetheredUser.imageUrl,
      username: tetheredUser.username,
      userRef: tetheredUser.doc.reference,
      published: DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "content": content,
      "imageUrl": imageUrl,
      "published": published,
      "userRef": userRef,
      "username": username,
    };
  }
}
