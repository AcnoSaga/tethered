import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'components/draft_list.dart';
import '../../../utils/colors.dart';
import '../../../utils/enums/tab_item.dart';
import '../../../utils/inner_routes/write_routes.dart';
import '../../../utils/text_styles.dart';

import 'components/published_list.dart';

class WritePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          brightness: Brightness.dark,
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
