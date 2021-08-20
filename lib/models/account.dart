import 'package:cloud_firestore/cloud_firestore.dart';

class Account {
  final String description;
  final int followers;
  final int following;
  final String imageUrl;
  final String name;
  final String username;
  final int works;
  final DocumentSnapshot doc;

  Account({
    this.description,
    this.followers,
    this.following,
    this.imageUrl,
    this.name,
    this.username,
    this.works,
    this.doc,
  });

  static Account fromDocument(DocumentSnapshot doc) {
    print(doc.data());
    return Account(
      description: doc["description"],
      followers: doc["followers"].length,
      following: doc["following"].length,
      imageUrl: doc["imageUrl"],
      name: doc["name"],
      username: doc["username"],
      works: doc["works"],
      doc: doc,
    );
  }
}
