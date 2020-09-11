import 'package:get/route_manager.dart';
import 'package:tethered/screens/home/home_page/demo_page.dart';

class SearchRoutes {
  static const String detail = '/details';
}

final searchRouteBuilder = {
  SearchRoutes.detail: (args) => GetPageRoute(page: () => DemoPage()),
};

final searchInitialRoute = (args) => GetPageRoute(
      page: () => DemoPage(),
    );
