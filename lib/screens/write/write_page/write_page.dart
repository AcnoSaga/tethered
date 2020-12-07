import 'package:flutter/material.dart';
import 'package:tethered/screens/read/index_page/components/create_new_tether_container.dart';
import 'package:tethered/screens/write/write_page/components/draft_item.dart';
import 'package:tethered/theme/size_config.dart';
import 'package:tethered/utils/colors.dart';
import 'package:tethered/utils/text_styles.dart';

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
            ListView.builder(
              shrinkWrap: true,
              itemCount: 10,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: sx,
                      vertical: sx / 1.5,
                    ),
                    child: CreateNewIndexContainer(
                      text: 'Create New Story',
                    ),
                  );
                }
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: sx,
                    vertical: sx / 1.5,
                  ),
                  child: DraftItem(
                    published: false,
                  ),
                );
              },
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: 20,
              itemBuilder: (context, index) => Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: sx,
                  vertical: sx / 1.5,
                ),
                child: DraftItem(
                  published: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
