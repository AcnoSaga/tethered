import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../../components/gap.dart';
import '../../../../theme/size_config.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/enums/tab_item.dart';
import '../../../../utils/inner_routes/write_routes.dart';
import '../../../../utils/text_styles.dart';

class CreateNewIndexContainer extends StatelessWidget {
  final String text;

  const CreateNewIndexContainer({Key key, this.text}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(
        WriteRoutes.newStory,
        id: tabItemsToIndex[Provider.of<TabItem>(context, listen: false)],
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: sy * 4,
          vertical: sx * 2,
        ),
        decoration: BoxDecoration(
          color: TetheredColors.textFieldBackground,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              'assets/svg/CreateNewTether.svg',
            ),
            Gap(width: 4),
            Text(
              text ?? 'Create new tether',
              style: TetheredTextStyles.indexItemHeading,
            ),
          ],
        ),
      ),
    );
  }
}
