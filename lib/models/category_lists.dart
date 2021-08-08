import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryLists {
  final List<String> hashtags;
  final List<Map> genres;

  CategoryLists({this.hashtags, this.genres});

  static CategoryLists fromDocument(DocumentSnapshot doc) {
    return CategoryLists(
      genres:
          [...doc['genres']].map((hashMap) => Map.castFrom(hashMap)).toList(),
      hashtags: [...doc['hashtags']],
    );
  }
}
