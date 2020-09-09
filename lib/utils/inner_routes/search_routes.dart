import 'package:get/route_manager.dart';
import 'package:tethered/screens/home/home_page/home_page.dart';

class SearchRoutes {
  static const String detail = '/details';
}

final searchRouteBuilder = {
  SearchRoutes.detail: GetPageRoute(page: () => HomePage()),
};

final searchInitialRoute = GetPageRoute(
  page: () => HomePage(),
);
