import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:tethered/theme/size_config.dart';
import 'package:tethered/utils/colors.dart';
import 'package:tethered/utils/enums/tab_item.dart';
import 'package:tethered/utils/inner_routes/home_routes.dart';

class UserItem extends StatelessWidget {
  const UserItem({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => Get.toNamed(
        HomeRoutes.accountPage,
        id: tabItemsToIndex[Provider.of<TabItem>(context, listen: false)],
      ),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS22RO1vyrwFBgngHIYwwa_Dqo_GRM3UN6nNB5hmBGYrueb0wan272oZDrvA254rgSS5ZY&usqp=CAU"),
      ),
      title: Text(
        'jrhuman',
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: sText * 4,
            color: TetheredColors.textColor),
      ),
      subtitle: Text(
        "Saad Khan",
        style: TextStyle(
          fontSize: sText * 3,
          color: TetheredColors.textColor,
        ),
      ),
    );
  }
}
