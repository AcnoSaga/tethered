import 'package:flutter/material.dart';
import 'package:tethered/screens/home/home_page/components/book_row.dart';
import 'package:tethered/screens/components/gap.dart';
import 'package:tethered/screens/home/home_page/components/home_carousel.dart';
import 'package:tethered/theme/size_config.dart';
import 'package:tethered/utils/colors.dart';
import 'package:tethered/utils/enums/resource_types.dart';
import 'package:tethered/utils/text_styles.dart';

const List<String> names = [
  "Top Picks",
  "Horror",
  "Romance",
  "Comedy",
];

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TetheredColors.primaryDark,
      appBar: AppBar(
        elevation: 10,
        backgroundColor: TetheredColors.primaryDark,
        title: Text('Tethered', style: TetheredTextStyles.homeAppBarHeading),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(height: 5),
              HomeCarousel(),
              Gap(height: 3),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: names.length,
                itemBuilder: (context, index) => Padding(
                  padding: EdgeInsets.symmetric(vertical: sx),
                  child: BookRow(
                    titlePadding: EdgeInsets.symmetric(
                        horizontal: sy * 3, vertical: sx * 2),
                    title: names[index],
                    isResourceExpandable: index != 0,
                    resourceType: ResourceTypes.genre,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
