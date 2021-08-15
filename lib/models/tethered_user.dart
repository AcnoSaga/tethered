import 'package:cloud_firestore/cloud_firestore.dart';

class TetheredUser {
  final String uid;
  final String name;
  final String username;
  final String description;
  final int followers;
  final String imageUrl;
  final int following;
  final DocumentSnapshot doc;

  TetheredUser({
    this.imageUrl,
    this.uid,
    this.name,
    this.username,
    this.description,
    this.followers,
    this.following,
    this.doc,
  });

  static Future<TetheredUser> fromUserId(String uid) async {
    final doc =
        await FirebaseFirestore.instance.collection('accounts').doc(uid).get();
    return TetheredUser(
      uid: uid,
      name: doc["name"],
      username: doc["username"],
      description: doc["description"],
      followers: doc["followers"].length,
      following: doc["following"].length,
      imageUrl: doc["imageUrl"],
      doc: doc,
    );
  }
}
