import 'package:tethered/utils/inner_routes/library_routes.dart';
import 'package:tethered/utils/inner_routes/home_routes.dart';
import 'package:tethered/utils/inner_routes/notification_routes.dart';
import 'package:tethered/utils/inner_routes/search_routes.dart';
import 'package:tethered/utils/inner_routes/write_routes.dart';

enum TabItem {
  home,
  search,
  write,
  notifications,
  library,
}

const List<TabItem> tabItems = [
  TabItem.home,
  TabItem.search,
  TabItem.write,
  TabItem.notifications,
  TabItem.library,
];

const Map<TabItem, int> tabItemsToIndex = {
  TabItem.home: 0,
  TabItem.search: 1,
  TabItem.write: 2,
  TabItem.notifications: 3,
  TabItem.library: 4,
};

const Map<int, TabItem> indexToTabItem = {
  0: TabItem.home,
  1: TabItem.search,
  2: TabItem.write,
  3: TabItem.notifications,
  4: TabItem.library,
};

final tabItemToRouteBuilders = {
  TabItem.home: homeRouteBuilder,
  TabItem.search: searchRouteBuilder,
  TabItem.write: writeRouteBuilder,
  TabItem.notifications: notificationsRouteBuilder,
  TabItem.library: libraryRouteBuilder,
};

final tabItemToInitialRoute = {
  TabItem.home: homeInitialRoute,
  TabItem.search: searchInitialRoute,
  TabItem.write: writeInitialRoute,
  TabItem.notifications: notificationsInitialRoute,
  TabItem.library: libraryInitialRoute,
};
