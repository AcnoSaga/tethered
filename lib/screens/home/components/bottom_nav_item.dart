import 'package:flutter/material.dart';
import '../../../theme/size_config.dart';
import '../../../utils/colors.dart';

class BottomNavItem extends StatelessWidget {
  final IconData icon;
  final void Function() onPressed;
  final bool isActive;

  const BottomNavItem({Key key, this.icon, this.onPressed, this.isActive})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      size: sText * 9,
      color: isActive
          ? TetheredColors.bottomNavBarIconActive
          : TetheredColors.bottomNavBarIconInactive,
    );
  }
}
