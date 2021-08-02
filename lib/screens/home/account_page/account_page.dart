import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:tethered/screens/components/book_card.dart';
import 'package:tethered/screens/components/gap.dart';
import 'package:tethered/screens/components/proceed_button.dart';
import 'package:tethered/theme/size_config.dart';
import 'package:tethered/utils/colors.dart';
import 'package:tethered/utils/enums/tab_item.dart';
import 'package:tethered/utils/inner_routes/home_routes.dart';
import 'package:tethered/utils/text_styles.dart';

import 'components/account_numeric_data_column.dart';

// TODO: Fix errors in this page

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final PagingController<int, String> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    super.initState();
    List<String> urls = [];
    List.filled(20, null).forEach((element) {
      Random rnd;
      int min = 1050;
      int max = 1080;
      rnd = new Random();
      int value = min + rnd.nextInt(max - min);
      final String url = 'https://picsum.photos/id/$value/400/600';
      urls.add(url);
    });
    _pagingController.appendPage(urls, urls.length);
    _pagingController.addPageRequestListener((pageKey) {
      List<String> urls = [];
      List.filled(20, null).forEach((element) {
        Random rnd;
        int min = 1050;
        int max = 1080;
        rnd = new Random();
        int value = min + rnd.nextInt(max - min);
        final String url = 'https://picsum.photos/id/$value/400/600';
        urls.add(url);
      });
      _pagingController.appendPage(urls, pageKey + urls.length);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TetheredColors.primaryDark,
      appBar: AppBar(
        title: Text(
          '@john_smith',
          style: TetheredTextStyles.homeAppBarHeading,
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () async {
              await Get.toNamed(
                HomeRoutes.settingsPage,
                id: tabItemsToIndex[
                    Provider.of<TabItem>(context, listen: false)],
              );
              // Get cannot manage this, Drawer is controlled by default Navigator
              Navigator.of(context).pop();
            },
          ),
        ],
        backgroundColor: TetheredColors.primaryDark,
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.symmetric(
              horizontal: sy * 5,
              vertical: sx * 5,
            ),
            sliver: SliverToBoxAdapter(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    maxRadius: sy * 15,
                    minRadius: sy * 10,
                    backgroundImage: NetworkImage(
                      'https://widgetwhats.com/app/uploads/2019/11/free-profile-photo-whatsapp-4.png',
                    ),
                  ),
                  Gap(height: 2),
                  Text(
                    'John Smith',
                    style: TetheredTextStyles.authSubHeading,
                  ),
                  Gap(height: 1),
                  Text(
                    'Traveler by day, Author at night. Love life and food.',
                    style: TetheredTextStyles.descriptionText,
                  ),
                  Gap(height: 2),
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    spacing: sy * 10,
                    children: [
                      AccountNumericDataColumn(
                        title: 'Followers',
                        data: 12000,
                      ),
                      AccountNumericDataColumn(
                        title: 'Works',
                        data: 21,
                      ),
                      AccountNumericDataColumn(
                        title: 'Following',
                        data: 120,
                      ),
                    ],
                    direction: Axis.horizontal,
                  ),
                  Gap(height: 2),
                  ProceedButton(
                    text: 'Follow',
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(
              horizontal: sy * 5,
            ),
            sliver: PagedSliverGrid(
              pagingController: _pagingController,
              builderDelegate: PagedChildBuilderDelegate<String>(
                itemBuilder: (context, url, index) => BookCard(
                  key: UniqueKey(),
                  url: url,
                ),
              ),
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: sy * 60,
                mainAxisSpacing: sx * 5,
                crossAxisSpacing: sy * 10,
                childAspectRatio: 0.7,
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
