import 'package:flutter/material.dart';
import 'package:tethered/screens/read/index_page/components/index_item.dart';
import 'package:tethered/theme/size_config.dart';
import 'package:tethered/utils/colors.dart';
import 'package:tethered/utils/text_styles.dart';

import 'components/create_new_tether_container.dart';

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
                    'ENTRIES',
                    style: TetheredTextStyles.indexTabTextStyle,
                  ),
                ),
                Tab(
                  child: Text(
                    'OFFICIAL',
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
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: sx,
                        vertical: sx / 1.5,
                      ),
                      child: CreateNewTetherContainer(),
                    );
                  }
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: sx,
                      vertical: sx / 1.5,
                    ),
                    child: IndexItem(),
                  );
                },
              ),
              ListView.builder(
                itemBuilder: (context, index) => Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: sx,
                    vertical: sx / 1.5,
                  ),
                  child: IndexItem(),
                ),
              ),
            ],
          )),
    );
  }
}
