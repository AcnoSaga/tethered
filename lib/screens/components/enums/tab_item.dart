import 'package:tethered/utils/inner_routes/home_routes.dart';
import 'package:tethered/utils/inner_routes/search_routes.dart';

enum TabItem {
  home,
  search,
  write,
  notifications,
  account,
}

const List<TabItem> tabItems = [
  TabItem.home,
  TabItem.search,
  TabItem.write,
  TabItem.notifications,
  TabItem.account,
];

const Map<TabItem, int> tabItemsToIndex = {
  TabItem.home: 0,
  TabItem.search: 1,
  TabItem.write: 2,
  TabItem.notifications: 3,
  TabItem.account: 4,
};

const Map<int, TabItem> indexToTabItem = {
  0: TabItem.home,
  1: TabItem.search,
  2: TabItem.write,
  3: TabItem.notifications,
  4: TabItem.account,
};

final tabItemToRouteBuilders = {
  TabItem.home: homeRouteBuilder,
  TabItem.search: searchRouteBuilder,
  TabItem.write: homeRouteBuilder,
  TabItem.notifications: homeRouteBuilder,
  TabItem.account: homeRouteBuilder,
};

final tabItemToInitialRoute = {
  TabItem.home: homeInitialRoute,
  TabItem.search: searchInitialRoute,
  TabItem.write: homeInitialRoute,
  TabItem.notifications: homeInitialRoute,
  TabItem.account: homeInitialRoute,
};
