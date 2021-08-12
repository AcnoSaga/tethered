import 'package:cloud_firestore/cloud_firestore.dart';

class PublishedDraft {
  final String title;
  final String description;
  final String imageUrl;
  final String genre;
  final List<String> hashtags;
  final DateTime published;
  final bool isTether;
  final String creatorId;
  final DocumentReference workRef;
  final DocumentSnapshot doc;

  PublishedDraft({
    this.title,
    this.description,
    this.imageUrl,
    this.genre,
    this.hashtags,
    this.published,
    this.creatorId,
    this.isTether,
    this.workRef,
    this.doc,
  });

  static PublishedDraft fromDocument(DocumentSnapshot doc) {
    return PublishedDraft(
      title: doc["title"],
      description: doc["description"],
      imageUrl: doc["imageUrl"],
      genre: doc["genre"],
      hashtags: <String>[...(doc["hashtags"])].toList(),
      published: (doc["published"] as Timestamp).toDate(),
      isTether: doc["isTether"],
      creatorId: doc["creatorId"],
      workRef: doc["workRef"],
      doc: doc,
    );
  }
}
