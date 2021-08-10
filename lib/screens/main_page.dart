import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/enums/tab_item.dart';
import 'components/tab_navigator.dart';
import 'home/components/main_page_bottom_nav_bar.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  TabItem selected = TabItem.home;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: MainPageBottomNavBar(
        selected: tabItemsToIndex[selected],
        onChangeTab: _onTabChange,
      ),
      body: Stack(
        children: tabItems
            .map((tabItem) => _buildOffstageNavigator(tabItem))
            .toList(),
      ),
    );
  }

  void _onTabChange(index) {
    setState(() {
      if (selected == indexToTabItem[index]) {
        if (Get.nestedKey(index).currentState.canPop()) {
          Get.offAllNamed('/', id: index);
        }
      } else {
        selected = indexToTabItem[index];
      }
    });
  }

  Widget _buildOffstageNavigator(TabItem tabItem) {
    return Offstage(
      offstage: selected != tabItem,
      child: TabNavigator(
        tabItem: tabItem,
      ),
    );
  }
}
