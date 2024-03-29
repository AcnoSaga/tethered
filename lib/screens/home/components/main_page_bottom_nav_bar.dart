import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import '../../../theme/tethered_icons.dart';

import '../../../utils/colors.dart';

class MainPageBottomNavBar extends StatelessWidget {
  final int selected;
  final void Function(int) onChangeTab;

  const MainPageBottomNavBar({Key key, this.selected, this.onChangeTab})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SnakeNavigationBar.color(
      selectedItemColor: TetheredColors.authHeading,
      snakeViewColor: TetheredColors.primaryBlue,
      currentIndex: selected,
      backgroundColor: TetheredColors.primaryDark,
      onTap: onChangeTab,
      elevation: 100,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      snakeShape: SnakeShape.indicator,
      items: [
        BottomNavigationBarItem(
          icon: Icon(TetheredIcons.home),
          backgroundColor: TetheredColors.primaryDark,
        ),
        BottomNavigationBarItem(
          icon: Icon(TetheredIcons.edit),
          backgroundColor: TetheredColors.primaryDark,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          backgroundColor: TetheredColors.primaryDark,
        ),
      ],
    );
  }
}
