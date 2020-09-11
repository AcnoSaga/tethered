import 'package:get/route_manager.dart';
import 'package:tethered/screens/home/home_page/demo_page.dart';

class AccountRoutes {
  static const String detail = '/details';
}

final accountRouteBuilder = {
  AccountRoutes.detail: (args) => GetPageRoute(page: () => DemoPage()),
};

final accountInitialRoute = (args) => GetPageRoute(
      page: () => DemoPage(),
    );
