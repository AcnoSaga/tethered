import 'package:get/route_manager.dart';
import '../../screens/home/book_details_page/book_details_page.dart';
import '../../screens/home/hashtag_page/hashtag_page.dart';
import '../../screens/search/explore_page.dart';
import '../../screens/search/search_page/search_page.dart';

class SearchRoutes {
  static const String searchPage = '/search';
  static const String hashtagPage = '/hashtag-page';
  static const String bookDetails = '/book-details';
}

final searchRouteBuilder = {
  SearchRoutes.searchPage: (args) => GetPageRoute(
        page: () => SearchPage(),
      ),
  SearchRoutes.hashtagPage: (args) => GetPageRoute(
        page: () => HashtagPage(
          hashtagId: args["hashtagId"],
        ),
      ),
  SearchRoutes.bookDetails: (args) => GetPageRoute(
        page: () => BookDetailsPage(
          bookCoverList: args["bookCovers"],
          index: args["index"],
        ),
      ),
};

final searchInitialRoute = (args) => GetPageRoute(
      page: () => ExplorePage(),
    );
