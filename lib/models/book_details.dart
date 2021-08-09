import 'package:cloud_firestore/cloud_firestore.dart';

class BookDetails {
  final String title;
  final String description;
  final String imageUrl;
  final List<String> hashtags;
  final int numberOfTethers;
  final DocumentSnapshot doc;

  BookDetails({
    this.title,
    this.description,
    this.imageUrl,
    this.hashtags,
    this.doc,
    this.numberOfTethers,
  });

  static BookDetails fromDocument(DocumentSnapshot doc) {
    return BookDetails(
      title: doc["title"],
      description: doc["description"],
      imageUrl: doc["imageUrl"],
      hashtags: [...doc["hashtags"]],
      numberOfTethers: doc["numberOfTethers"],
      doc: doc,
    );
  }
}
