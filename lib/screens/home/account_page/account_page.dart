import 'dart:math';

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:tethered/screens/components/book_card.dart';
import 'package:tethered/screens/components/gap.dart';
import 'package:tethered/screens/components/proceed_button.dart';
import 'package:tethered/theme/size_config.dart';
import 'package:tethered/utils/colors.dart';
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
                      'https://images.unsplash.com/photo-1552058544-f2b08422138a?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=644&q=80',
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
