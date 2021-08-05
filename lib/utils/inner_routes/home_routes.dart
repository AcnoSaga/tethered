import 'package:get/route_manager.dart';
import 'package:tethered/screens/home/account_page/account_page.dart';
import 'package:tethered/screens/home/book_details_page/book_details_page.dart';
import 'package:tethered/screens/home/genre_page/genre_page.dart';
import 'package:tethered/screens/home/hashtag_page/hashtag_page.dart';
import 'package:tethered/screens/home/home_page/home_page.dart';

class HomeRoutes {
  static const String bookDetails = '/book-details';
  static const String hashtagPage = '/hashtag-page';
  static const String genrePage = '/genre-page';
  static const String accountPage = '/account-page';
}

final homeRouteBuilder = {
  HomeRoutes.bookDetails: (args) => GetPageRoute(
        page: () => BookDetailPage(
          bookCovers: args["bookCovers"],
          startingIndex: args["index"],
        ),
      ),
  HomeRoutes.hashtagPage: (args) => GetPageRoute(
        page: () => HashtagPage(
          hashtagId: args["hashtagId"],
        ),
      ),
  HomeRoutes.genrePage: (args) => GetPageRoute(
        page: () => GenrePage(
          genre: args["genre"],
        ),
      ),
  HomeRoutes.accountPage: (args) => GetPageRoute(
    // Also present in global routes
        page: () => AccountPage(),
      ),
};

final homeInitialRoute = (args) => GetPageRoute(
      page: () => HomePage(),
    );
