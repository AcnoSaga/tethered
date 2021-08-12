import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:tethered/models/tethered_user.dart';
import 'package:tethered/theme/size_config.dart';
import 'package:tethered/utils/colors.dart';
import 'package:tethered/utils/enums/tab_item.dart';
import 'package:tethered/utils/inner_routes/home_routes.dart';

class UserItem extends StatelessWidget {
  final TetheredUser user;
  const UserItem({Key key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => Get.toNamed(HomeRoutes.accountPage,
          id: tabItemsToIndex[Provider.of<TabItem>(context, listen: false)],
          arguments: {
            "uid": user.uid,
          }),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(user.imageUrl),
      ),
      title: Text(
        user.name,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: sText * 4,
            color: TetheredColors.textColor),
      ),
      subtitle: Text(
        user.description,
        style: TextStyle(
          fontSize: sText * 3,
          color: TetheredColors.textColor,
        ),
      ),
    );
  }
}
