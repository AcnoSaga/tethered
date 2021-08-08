import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tethered/models/account.dart';
import 'package:tethered/riverpods/home/account/account_page_provider.dart';
import 'package:tethered/screens/components/gap.dart';
import 'package:tethered/screens/components/proceed_button.dart';
import 'package:tethered/theme/size_config.dart';
import 'package:tethered/utils/colors.dart';
import 'package:tethered/utils/text_styles.dart';

import 'components/account_numeric_data_column.dart';
import 'components/account_page_book_grid.dart';

class AccountPage extends ConsumerWidget {
  final String uid;

  const AccountPage({Key key, this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final state = watch(accountPageStateProvider(uid));
    return Scaffold(
        backgroundColor: TetheredColors.primaryDark,
        appBar: AppBar(
          title: Text(
            state is AccountPageLoaded ? state.account.name : 'Account',
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
            return _accountsDetails(state.account);
          } else {
            return Center(child: Text('Please try again'));
          }
        }());
  }

  Widget _accountsDetails(Account account) {
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
                    AccountNumericDataColumn(
                      title: 'Following',
                      data: account.following,
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
          sliver: AccountPageBookGrid(uid: uid),
        )
      ],
    );
  }
}
