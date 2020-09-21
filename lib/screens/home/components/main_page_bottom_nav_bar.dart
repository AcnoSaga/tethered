import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';

import 'package:tethered/utils/colors.dart';

class MainPageBottomNavBar extends StatelessWidget {
  final int selected;
  final void Function(int) onChangeTab;

  const MainPageBottomNavBar({Key key, this.selected, this.onChangeTab})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SnakeNavigationBar(
      selectedItemColor: TetheredColors.authHeading,
      snakeColor: TetheredColors.primaryBlue,
      currentIndex: selected,
      backgroundColor: TetheredColors.primaryDark,
      onPositionChanged: onChangeTab,
      elevation: 100,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      snakeShape: SnakeShape.indicator,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          backgroundColor: TetheredColors.primaryDark,
          title: Container(),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          backgroundColor: TetheredColors.primaryDark,
          title: Container(),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.edit),
          backgroundColor: TetheredColors.primaryDark,
          title: Container(),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          backgroundColor: TetheredColors.primaryDark,
          title: Container(),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          backgroundColor: TetheredColors.primaryDark,
          title: Container(),
        ),
      ],
    );
  }
}
