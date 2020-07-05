import 'package:get/get.dart';
import 'package:tethered/screens/home/demo_page.dart';

class Routes {
  static List<GetPage> getPages() {
    return [
      GetPage(
        name: '/',
        page: () => DemoPage(),
      ),
    ];
  }

  static String getInitialRoute() {
    return '/';
  }
}
