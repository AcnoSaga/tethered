import 'package:get/route_manager.dart';
import 'package:tethered/screens/search/explore_page.dart';
import 'package:tethered/screens/search/search_page/search_page.dart';

class SearchRoutes {
  static const String searchPage = '/search';
}

final searchRouteBuilder = {
  SearchRoutes.searchPage: (args) => GetPageRoute(
        page: () => SearchPage(),
      ),
};

final searchInitialRoute = (args) => GetPageRoute(
      page: () => ExplorePage(),
    );
