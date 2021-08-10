import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/colors.dart';
import '../../../utils/text_styles.dart';
import 'components/entries_list.dart';
import 'components/official_list.dart';

class IndexPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Tethered',
            style: TetheredTextStyles.homeAppBarHeading,
          ),
          centerTitle: true,
          backgroundColor: TetheredColors.textFieldBackground,
          bottom: TabBar(
            indicatorColor: TetheredColors.indexTabBarIndicatorColor,
            tabs: [
              Tab(
                child: Text(
                  'OFFICIAL',
                  style: TetheredTextStyles.indexTabTextStyle,
                ),
              ),
              Tab(
                child: Text(
                  'ENTRIES',
                  style: TetheredTextStyles.indexTabTextStyle,
                ),
              ),
            ],
          ),
        ),
        backgroundColor: TetheredColors.primaryDark,
        body: TabBarView(
          children: [
            OfficialList(
              bookDetails: Get.arguments["bookDetails"],
              pageController: Get.arguments["pageController"],
            ),
            EntriesList(
              bookDetails: Get.arguments["bookDetails"],
            ),
          ],
        ),
      ),
    );
  }
}
