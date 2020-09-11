import 'package:get/route_manager.dart';
import 'package:tethered/screens/home/book_details_page/book_details_page.dart';
import 'package:tethered/screens/home/hashtag_page/hashtag_page.dart';
import 'package:tethered/screens/home/home_page/home_page.dart';

class HomeRoutes {
  static const String bookDetails = '/book-details';
  static const String hashtagPage = '/resource-page';
}

final homeRouteBuilder = {
  HomeRoutes.bookDetails: (args) => GetPageRoute(
        page: () => BookDetailPage(
          urls: args["urls"],
          startingIndex: args["index"],
          title: args["title"],
        ),
      ),
  HomeRoutes.hashtagPage: (args) => GetPageRoute(
        page: () => HashtagPage(
          hashtag: args["resource"],
        ),
      )
};

final homeInitialRoute = (args) => GetPageRoute(
      page: () => HomePage(),
    );
