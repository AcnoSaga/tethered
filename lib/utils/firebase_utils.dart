import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseUtils {
  static Future<bool> isLiked(DocumentReference doc, String uid) async {
    return ((await doc.get())["likes"] as List).contains(uid);
  }

  static Future<bool> changeLikeStatus(
      DocumentReference doc, DocumentReference indexDoc, bool isLiked) async {
    if (isLiked) {
      doc.update({
        "likes": FieldValue.arrayRemove([FirebaseAuth.instance.currentUser.uid])
      });
      indexDoc.update({"likes": FieldValue.increment(-1)});
    } else {
      doc.update({
        "likes": FieldValue.arrayUnion([FirebaseAuth.instance.currentUser.uid])
      });
      indexDoc.update({"likes": FieldValue.increment(1)});
    }
    return !isLiked;
  }
}
