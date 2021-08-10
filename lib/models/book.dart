import 'package:algolia/algolia.dart';

class Book {
  final String authorName;
  final String imgUrl;
  final String date;
  final String desc;
  final List<String> tags;

  Book({this.authorName, this.imgUrl, this.date, this.desc, this.tags});

  static Book fromSnapshot(AlgoliaObjectSnapshot snapshot) {
    print(snapshot.data["content"]);
    return Book(
      authorName: snapshot.data["author_name"],
      imgUrl: snapshot.data["image"],
      date: snapshot.data["post_date_formatted"],
      desc: snapshot.data["content"],
      tags: snapshot.data["categories"],
    );
  }
}
