import 'package:get/route_manager.dart';
import 'package:tethered/screens/home/home_page/demo_page.dart';

class NotificationsRoutes {
  static const String detail = '/details';
}

final notificationsRouteBuilder = {
  NotificationsRoutes.detail: (args) => GetPageRoute(page: () => DemoPage()),
};

final notificationsInitialRoute = (args) => GetPageRoute(
      page: () => DemoPage(),
    );
