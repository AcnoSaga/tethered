import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tethered/injection/injection.dart';
import 'package:tethered/models/tethered_user.dart';
import 'package:tethered/riverpods/global/user_provider.dart';
import 'package:tethered/services/authetication_service.dart';
import 'package:tethered/utils/colors.dart';
import 'package:tethered/utils/text_styles.dart';
import 'package:settings_ui/settings_ui.dart';

import 'edit_profile_page.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final user = watch(userProvider);
    return Scaffold(
      backgroundColor: TetheredColors.primaryDark,
      appBar: AppBar(
        brightness: Brightness.dark,
        title: Text('Settings', style: TetheredTextStyles.homeAppBarHeading),
        backgroundColor: TetheredColors.primaryDark,
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 16.0),
        child: SettingsList(
          // backgroundColor: TetheredColors.primaryDark,
          sections: [
            SettingsSection(
              title: 'Account',
              tiles: [
                SettingsTile(
                  title: user?.name ?? '',
                  subtitle: 'Edit Profile',
                  leading: Icon(
                    Icons.account_box_outlined,
                    color: TetheredColors.primaryBlue,
                  ),
                  onPressed: (BuildContext context) =>
                      Get.to(() => EditProfilePage()),
                ),
                SettingsTile(
                  title: 'Logout',
                  leading: Icon(
                    Icons.logout_outlined,
                    color: TetheredColors.primaryBlue,
                  ),
                  onPressed: (context) async {
                    Get.offAndToNamed('/login');
                    await locator<AuthenticationService>().signOutUser();
                  },
                ),
                SettingsTile(
                  title: 'Delete Account',
                  leading: Icon(
                    Icons.delete_forever,
                    color: TetheredColors.primaryBlue,
                  ),
                  onPressed: (context) async {
                    _deleteDialog(user);
                  },
                ),
              ],
            ),
            SettingsSection(
              title: 'About',
              tiles: [
                SettingsTile(
                  title: 'About the app',
                  leading: Icon(
                    Icons.info,
                    color: TetheredColors.primaryBlue,
                  ),
                  onPressed: (context) async {
                    showAboutDialog(
                      context: context,
                      // applicationIcon: Icon(Icons.ac_unit),
                      useRootNavigator: false,
                      applicationLegalese: 'All Rights Reserved. Tethered Inc.',
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future _deleteDialog(TetheredUser user) async {
    await Get.dialog(
      AlertDialog(
        title: Text(
            'Are you sure you want to delete your account?\nThis action can not be reversed.'),
        actions: [
          TextButton.icon(
            onPressed: () async {
              Get.back();
              Get.offAndToNamed('/login');
              await locator<AuthenticationService>().deleteCurrentUserAccount(
                  !(user == null || user.imageUrl.isEmpty));
            },
            icon: Icon(
              Icons.check_circle,
              color: TetheredColors.acceptNegativeColor,
            ),
            label: Text(
              'Yes',
              style: TetheredTextStyles.acceptNegativeText,
            ),
          ),
          TextButton.icon(
            onPressed: Get.back,
            icon: Icon(
              Icons.cancel,
              color: TetheredColors.rejectNegativeColor,
            ),
            label: Text(
              'No',
              style: TetheredTextStyles.rejectNegativeText,
            ),
          ),
        ],
      ),
    );
    print('------------------------------');
    Get.back();
  }
}
