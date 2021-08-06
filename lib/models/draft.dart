import 'package:cloud_firestore/cloud_firestore.dart';

class Draft {
  final String title;
  final DocumentSnapshot doc;

  Draft({this.doc, this.title});

  static Draft fromDocument(DocumentSnapshot doc) {
    return Draft(
      title: doc["title"],
      doc: doc,
    );
  }
}
