import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tethered/utils/enums/tab_item.dart';
import 'package:provider/provider.dart' as FlutterBase;
import 'package:tethered/utils/inner_routes/home_routes.dart';
import '../../../models/account.dart';
import '../../../riverpods/home/account/account_page_provider.dart';
import '../../components/gap.dart';
import '../../components/proceed_button.dart';
import '../../../theme/size_config.dart';
import '../../../utils/colors.dart';
import '../../../utils/text_styles.dart';

import 'components/account_numeric_data_column.dart';
import 'components/account_page_book_grid.dart';

class AccountPage extends ConsumerWidget {
  final String uid;
  final currentId = FirebaseAuth.instance.currentUser.uid;

  AccountPage({Key key, this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final String id = uid ?? Get.arguments["uid"];
    final state = watch(accountPageStateProvider(id));
    return Scaffold(
        backgroundColor: TetheredColors.primaryDark,
        appBar: AppBar(
          actions: [
            if (currentId == uid)
              IconButton(
                  onPressed: () => Get.toNamed(
                        HomeRoutes.settingsPage,
                        id: tabItemsToIndex[FlutterBase.Provider.of<TabItem>(
                          context,
                          listen: false,
                        )],
                      ),
                  icon: Icon(Icons.settings))
          ],
          title: Text(
            state is AccountPageLoaded ? state.account.name : '',
            style: TetheredTextStyles.homeAppBarHeading,
          ),
          backgroundColor: TetheredColors.primaryDark,
        ),
        body: () {
          if (state is AccountPageInitial) {
            return Container();
          } else if (state is AccountPageLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is AccountPageLoaded) {
            return _accountsDetails(state.account, id);
          } else {
            return Center(child: Text('Please try again'));
          }
        }());
  }

  Widget _accountsDetails(Account account, String id) {
    return CustomScrollView(
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
                  backgroundImage: NetworkImage(account.imageUrl),
                ),
                Gap(height: 2),
                Text(
                  account.name,
                  style: TetheredTextStyles.authSubHeading,
                ),
                Gap(height: 1),
                Text(
                  account.description,
                  style: TetheredTextStyles.descriptionText,
                ),
                Gap(height: 2),
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  spacing: sy * 10,
                  children: [
                    AccountNumericDataColumn(
                      title: 'Followers',
                      data: account.followers,
                    ),
                    AccountNumericDataColumn(
                      title: 'Works',
                      data: account.works,
                    ),
                  ],
                  direction: Axis.horizontal,
                ),
                if (currentId != id) Gap(height: 2),
                if (currentId != id)
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
          sliver: AccountPageBookGrid(
            uid: id,
            isNested: uid != null,
          ),
        )
      ],
    );
  }
}
