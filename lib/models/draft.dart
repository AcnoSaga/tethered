import 'package:cloud_firestore/cloud_firestore.dart';

class Draft {
  final String title;
  final String description;
  final String imageUrl;
  final String genre;
  final List<String> hashtags;
  final DateTime lastUpdated;
  final bool isTether;
  final DocumentSnapshot doc;

  Draft({
    this.title,
    this.description,
    this.imageUrl,
    this.genre,
    this.hashtags,
    this.lastUpdated,
    this.isTether,
    this.doc,
  });

  static Draft fromDocument(DocumentSnapshot doc) {
    return Draft(
       title: doc["title"],
      description: doc["description"],
      imageUrl: doc["imageUrl"],
      genre: doc["genre"],
      hashtags: <String>[...(doc["hashtags"])].toList(),
      lastUpdated: (doc["lastUpdated"] as Timestamp).toDate(),
      isTether: doc["isTether"],
      doc: doc,
    );
  }
}
