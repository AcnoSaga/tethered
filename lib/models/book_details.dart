import 'package:cloud_firestore/cloud_firestore.dart';

class BookDetails {
  final String title;
  final String description;
  final String imageUrl;
  final String creatorId;
  final String genre;
  final List<String> hashtags;
  final int numberOfTethers;
  final DocumentSnapshot doc;

  BookDetails({
    this.creatorId,
    this.genre,
    this.title,
    this.description,
    this.imageUrl,
    this.hashtags,
    this.doc,
    this.numberOfTethers,
  });

  static BookDetails fromDocument(DocumentSnapshot doc) {
    print(doc.data());
    return BookDetails(
      title: doc["title"],
      genre: doc["genre"],
      description: doc["description"],
      imageUrl: doc["imageUrl"],
      creatorId: doc["creatorId"],
      hashtags: [...doc["hashtags"]],
      numberOfTethers: doc["numberOfTethers"],
      doc: doc,
    );
  }
}
