import 'package:flutter/material.dart';

import 'package:tethered/utils/colors.dart';

class MainPageBottomNavBar extends StatelessWidget {
  final int selected;
  final void Function(int) onChangeTab;

  const MainPageBottomNavBar({Key key, this.selected, this.onChangeTab})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      fixedColor: TetheredColors.bottomNavBarIconActive,
      unselectedItemColor: TetheredColors.bottomNavBarIconInactive,
      currentIndex: selected,
      backgroundColor: TetheredColors.primaryDark,
      onTap: onChangeTab,
      elevation: 100,
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: false,
      showUnselectedLabels: false,
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
