import 'package:cloud_firestore/cloud_firestore.dart';

import 'book_cover.dart';
import 'category.dart';

class Genre extends Category {
  final String description;
  final List<String> hashtags;
  final List<BookCover> home;
  final String name;

  Genre(
      {this.description = "",
      this.hashtags = const [],
      this.home = const [],
      this.name = "Incomplete data"});

  static Genre fromDocument(DocumentSnapshot doc) {
    return Genre(
      description: doc["description"],
      hashtags: [...doc["hashtags"]],
      home:
          [...doc["home"]].map((data) => BookCover.fromMap(data)).toList(),
      name: doc["name"],
    );
  }
}
