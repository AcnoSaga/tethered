import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:tethered/screens/components/enums/tab_item.dart';
import 'package:tethered/screens/home/home_page/home_page.dart';

class TabNavigatorRoutes {
  static const String root = '/';
  static const String detail = '/detail';
}

class TabNavigator extends StatelessWidget {
  TabNavigator({this.tabItem});
  final TabItem tabItem;

  @override
  Widget build(BuildContext context) {
    return Provider<TabItem>.value(
      value: tabItem,
      child: Navigator(
          key: Get.nestedKey(tabItemsToIndex[tabItem]),
          initialRoute: '/',
          onGenerateRoute: (routeSettings) {
            Map<String, GetPageRoute> routes = {};
            tabItems
                .forEach((item) => routes.addAll(tabItemToRouteBuilders[item]));
            routes.putIfAbsent('/', () => tabItemToInitialRoute[tabItem]);
            print(routes);
            print(routeSettings.name);
            return GetPageRoute(
              page: routes[routeSettings.name].page,
              settings: routeSettings,
            );
          }),
    );
  }
}
