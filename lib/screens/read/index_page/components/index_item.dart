import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tethered/screens/components/gap.dart';
import 'package:tethered/screens/read/index_page/components/index_icon_text_group.dart';
import 'package:tethered/theme/size_config.dart';
import 'package:tethered/utils/colors.dart';
import 'package:tethered/utils/text_styles.dart';

class IndexItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: Get.back,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: sy * 2,
          vertical: sx * 2,
        ),
        decoration: BoxDecoration(
          color: TetheredColors.textFieldBackground,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Jules and Vega', style: TetheredTextStyles.indexItemHeading),
            Gap(height: 1.5),
            Text(
              'Hitmen Jules Winnfield and Vincent Vega arrive at an apartment to retrieve a briefcase for their boss, gangster Marsellus Wallace, from a business partner.',
              style: TetheredTextStyles.indexItemDescription,
              textAlign: TextAlign.justify,
              strutStyle: StrutStyle(height: 1.5),
            ),
            Gap(height: 2),
            Wrap(
              runAlignment: WrapAlignment.end,
              alignment: WrapAlignment.end,
              spacing: sy * 3,
              children: [
                IndexIconTextGroup(
                  icon: Icons.arrow_upward_sharp,
                  number: 90700,
                ),
                IndexIconTextGroup(
                  icon: Icons.message,
                  number: 2050000,
                ),
                IndexIconTextGroup(
                  icon: Icons.visibility,
                  number: 1000,
                ),
                // Spacer(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
