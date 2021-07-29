import 'package:cloud_firestore/cloud_firestore.dart';

import 'book_cover.dart';
import 'category.dart';

class Hashtag extends Category {
  final String name;
  final List<BookCover> works;

  Hashtag({this.name, this.works});

  static Hashtag fromDocument(DocumentSnapshot doc) {
    return Hashtag(
      name: doc.id,
      works: [...doc["works"]].map((data) => BookCover.fromMap(data)).toList(),
    );
  }
}
