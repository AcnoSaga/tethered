import 'package:get/route_manager.dart';
import 'package:tethered/screens/home/home_page/demo_page.dart';

class LibraryRoutes {
  static const String detail = '/details';
}

final libraryRouteBuilder = {
  LibraryRoutes.detail: (args) => GetPageRoute(page: () => DemoPage()),
};

final libraryInitialRoute = (args) => GetPageRoute(
      page: () => DemoPage(),
    );

