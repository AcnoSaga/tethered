import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:tethered/screens/home/home_page/components/book_row.dart';
import 'package:tethered/screens/components/gap.dart';
import 'package:tethered/screens/home/home_page/components/home_carousel.dart';
import 'package:tethered/theme/size_config.dart';
import 'package:tethered/utils/colors.dart';
import 'package:tethered/utils/enums/resource_types.dart';
import 'package:tethered/utils/enums/tab_item.dart';
import 'package:tethered/utils/inner_routes/home_routes.dart';
import 'package:tethered/utils/text_styles.dart';

const List<String> names = [
  "Top Picks",
  "Horror",
  "Romance",
  "Comedy",
];

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Container(
          color: TetheredColors.primaryDark,
          child: ListView(
            children: [
              DrawerHeader(
                child: GestureDetector(
                  onTap: () async {
                    await Get.toNamed(
                      HomeRoutes.accountPage,
                      id: tabItemsToIndex[
                          Provider.of<TabItem>(context, listen: false)],
                    );
                    // Get cannot manage this, Drawer is controlled by default Navigator
                    Navigator.of(context).pop();
                  },
                  child: Text('Account'),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: TetheredColors.primaryDark,
      appBar: AppBar(
        elevation: 10,
        backgroundColor: TetheredColors.primaryDark,
        title: Text(
          'Tethered',
          style: TetheredTextStyles.homeAppBarHeading,
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(height: 5),
              HomeCarousel(),
              Gap(height: 3),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: names.length,
                itemBuilder: (context, index) => Padding(
                  padding: EdgeInsets.symmetric(vertical: sx),
                  child: BookRow(
                    titlePadding: EdgeInsets.symmetric(
                        horizontal: sy * 3, vertical: sx * 2),
                    title: names[index],
                    isResourceExpandable: index != 0,
                    resourceType: ResourceTypes.genre,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
