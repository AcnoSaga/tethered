import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:tethered/screens/components/gap.dart';
import 'package:tethered/screens/components/input_form_field.dart';
import 'package:tethered/screens/components/validators/text_validators.dart';
import 'package:tethered/screens/search/components/explore_card.dart';
import 'package:tethered/theme/size_config.dart';
import 'package:tethered/utils/colors.dart';
import 'package:tethered/utils/enums/tab_item.dart';
import 'package:tethered/utils/inner_routes/search_routes.dart';
import 'package:tethered/utils/text_styles.dart';

class ExplorePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TetheredColors.primaryDark,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: sy * 5),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Gap(height: 5),
                      Text(
                        "Explore",
                        style: TetheredTextStyles.authHeading,
                      ),
                      Gap(height: 5),
                      GestureDetector(
                        onTap: () => Get.toNamed(
                          SearchRoutes.searchPage,
                          id: tabItemsToIndex[
                              Provider.of<TabItem>(context, listen: false)],
                        ),
                        child: AbsorbPointer(
                          absorbing: true,
                          child: InputFormField(
                            hintText: 'Search',
                            validator: TextValidators.email,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.symmetric(vertical: sx * 5),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      childAspectRatio: 3 / 2,
                      maxCrossAxisExtent: sy * 40,
                      crossAxisSpacing: sy * 6,
                      mainAxisSpacing: sx * 4,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return ExploreCard();
                      },
                      childCount: 100,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
