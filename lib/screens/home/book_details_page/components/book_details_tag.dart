import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:tethered/utils/colors.dart';
import 'package:tethered/utils/enums/resource_types.dart';
import 'package:tethered/utils/enums/tab_item.dart';
import 'package:tethered/utils/inner_routes/home_routes.dart';

class BookDetailsTag extends StatelessWidget {
  final String label;

  const BookDetailsTag({Key key, this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(
        HomeRoutes.hashtagPage,
        arguments: {
          "hashtag": label,
        },
        id: tabItemsToIndex[Provider.of<TabItem>(context, listen: false)],
      ),
      child: Badge(
        badgeColor: TetheredColors.textFieldBackground,
        shape: BadgeShape.square,
        borderRadius: 20,
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
