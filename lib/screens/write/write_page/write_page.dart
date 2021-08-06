import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:tethered/screens/read/index_page/components/create_new_tether_container.dart';
import 'package:tethered/screens/write/write_page/components/draft_item.dart';
import 'package:tethered/screens/write/write_page/components/draft_list.dart';
import 'package:tethered/theme/size_config.dart';
import 'package:tethered/utils/colors.dart';
import 'package:tethered/utils/enums/tab_item.dart';
import 'package:tethered/utils/inner_routes/write_routes.dart';
import 'package:tethered/utils/text_styles.dart';

import 'components/published_list.dart';

class WritePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Write',
            style: TetheredTextStyles.secondaryAppBarHeading,
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () => Get.toNamed(
                WriteRoutes.newStory,
                id: tabItemsToIndex[
                    Provider.of<TabItem>(context, listen: false)],
              ),
            )
          ],
          centerTitle: true,
          backgroundColor: TetheredColors.textFieldBackground,
          bottom: TabBar(
            indicatorColor: TetheredColors.indexTabBarIndicatorColor,
            tabs: [
              Tab(
                child: Text(
                  'DRAFTS',
                  style: TetheredTextStyles.indexTabTextStyle,
                ),
              ),
              Tab(
                child: Text(
                  'PUBLISHED',
                  style: TetheredTextStyles.indexTabTextStyle,
                ),
              ),
            ],
          ),
        ),
        backgroundColor: TetheredColors.primaryDark,
        body: TabBarView(
          children: [
            DraftList(),
            PublishedList(),
          ],
        ),
      ),
    );
  }
}
