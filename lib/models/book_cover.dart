import 'package:cloud_firestore/cloud_firestore.dart';

class BookCover {
  final String imageUrl;
  final DocumentReference workRef;

  BookCover({this.imageUrl, this.workRef});

  static BookCover fromMap(Map doc) {
    print(doc);
    return BookCover(
      imageUrl: doc["imageUrl"],
      workRef: doc["workRef"],
    );
  }
}
