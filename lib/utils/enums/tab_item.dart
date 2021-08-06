import 'package:tethered/utils/inner_routes/home_routes.dart';
import 'package:tethered/utils/inner_routes/search_routes.dart';
import 'package:tethered/utils/inner_routes/write_routes.dart';

enum TabItem {
  home,
  search,
  write,
}

const List<TabItem> tabItems = [
  TabItem.home,
  TabItem.write,
  TabItem.search,
];

const Map<TabItem, int> tabItemsToIndex = {
  TabItem.home: 0,
  TabItem.write: 1,
  TabItem.search: 2,
};

const Map<int, TabItem> indexToTabItem = {
  0: TabItem.home,
  1: TabItem.write,
  2: TabItem.search,
};

final tabItemToRouteBuilders = {
  TabItem.home: homeRouteBuilder,
  TabItem.write: writeRouteBuilder,
  TabItem.search: searchRouteBuilder,
};

final tabItemToInitialRoute = {
  TabItem.home: homeInitialRoute,
  TabItem.write: writeInitialRoute,
  TabItem.search: searchInitialRoute,
};
