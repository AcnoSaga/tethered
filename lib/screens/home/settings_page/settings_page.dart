import 'package:flutter/material.dart';
import 'package:tethered/utils/colors.dart';
import 'package:tethered/utils/text_styles.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TetheredColors.primaryDark,
      appBar: AppBar(
        title: Text('Settings', style: TetheredTextStyles.homeAppBarHeading),
        backgroundColor: TetheredColors.primaryDark,
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 16.0),
        child: SettingsList(
          backgroundColor: TetheredColors.primaryDark,
          sections: [
            SettingsSection(
              title: 'Account',
              tiles: [
                SettingsTile(
                  title: 'lljr.humanll',
                  subtitle: 'Edit Profile',
                  leading: Icon(
                    Icons.account_box_outlined,
                    color: TetheredColors.primaryBlue,
                  ),
                  onPressed: (BuildContext context) {},
                ),
                SettingsTile(
                  title: 'Privacy',
                  subtitle: 'Configure privacy',
                  leading: Icon(
                    Icons.vpn_key_outlined,
                    color: TetheredColors.primaryBlue,
                  ),
                ),
                SettingsTile(
                  title: 'Logout',
                  leading: Icon(
                    Icons.logout_outlined,
                    color: TetheredColors.primaryBlue,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
