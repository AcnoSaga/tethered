import 'package:flutter/material.dart';
import 'package:provider/single_child_widget.dart';
import 'package:tethered/screens/components/gap.dart';
import 'package:tethered/screens/components/input_form_field.dart';
import 'package:tethered/screens/components/validators/text_validators.dart';
import 'package:tethered/screens/search/components/explore_card.dart';
import 'package:tethered/theme/size_config.dart';
import 'package:tethered/utils/colors.dart';
import 'package:tethered/utils/text_styles.dart';

class SearchPage extends StatelessWidget {
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
                        onTap: () {
                          // TODO: Open search page
                        },
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
