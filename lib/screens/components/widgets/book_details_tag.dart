import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../../utils/colors.dart';
import '../../../utils/enums/tab_item.dart';
import '../../../utils/inner_routes/home_routes.dart';

class BookDetailsTag extends StatelessWidget {
  final String label;
  final Color color;
  final bool isNested;

  const BookDetailsTag({
    Key key,
    this.label,
    this.color = TetheredColors.textFieldBackground,
    this.isNested = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isNested) {
          Get.toNamed(
            HomeRoutes.hashtagPage,
            arguments: {
              "hashtagId": label,
            },
            id: tabItemsToIndex[Provider.of<TabItem>(context, listen: false)],
          );
        } else {
          Get.toNamed(
            '/hashtag',
            arguments: {
              "hashtagId": label,
            },
          );
        }
      },
      child: Badge(
        badgeColor: color,
        shape: BadgeShape.square,
        borderRadius: BorderRadius.circular(20),
        padding: EdgeInsets.symmetric(
          vertical: 7,
          horizontal: 10,
        ),
        badgeContent: Text(
          label,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
