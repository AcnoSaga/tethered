import 'package:cloud_firestore/cloud_firestore.dart';

class BookDetails {
  final String title;
  final String description;
  final String imageUrl;
  final List<String> hashtags;

  BookDetails({
    this.title,
    this.description,
    this.imageUrl,
    this.hashtags,
  });

  static BookDetails fromDocument(DocumentSnapshot doc) {
    return BookDetails(
      title: doc["title"],
      description: doc["description"],
      imageUrl: doc["imageUrl"],
      hashtags: [...doc["hashtags"]],
    );
  }
}
