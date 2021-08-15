import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../utils/enums/tab_item.dart';

class TabNavigator extends StatelessWidget {
  TabNavigator({this.tabItem});
  final TabItem tabItem;

  @override
  Widget build(BuildContext context) {
    print(tabItem);
    return Provider<TabItem>.value(
      value: tabItem,
      child: Builder(builder: (context) {
        return WillPopScope(
          onWillPop: () async {
            print(tabItem);
            Get.back(
                id: tabItemsToIndex[
                    Provider.of<TabItem>(context, listen: true)]);
            return false;
          },
          child: Navigator(
              key: Get.nestedKey(tabItemsToIndex[tabItem]),
              initialRoute: '/',
              onGenerateRoute: (routeSettings) {
                Map<String, GetPageRoute Function(dynamic)> routes = {};
                tabItems.forEach(
                    (item) => routes.addAll(tabItemToRouteBuilders[item]));
                routes.putIfAbsent('/', () => tabItemToInitialRoute[tabItem]);
                final getPageRoute =
                    routes[routeSettings.name](routeSettings.arguments);
                return GetPageRoute(
                  page: getPageRoute.page,
                  transition: getPageRoute.transition,
                  curve: getPageRoute.curve,
                  transitionDuration: getPageRoute.transitionDuration,
                  settings: routeSettings,
                );
              }),
        );
      }),
    );
  }
}
