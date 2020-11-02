import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tethered/screens/components/gap.dart';
import 'package:tethered/theme/size_config.dart';
import 'package:tethered/utils/colors.dart';
import 'package:tethered/utils/text_styles.dart';

class CreateNewTetherContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
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
            'Create new tether',
            style: TetheredTextStyles.indexItemHeading,
          ),
        ],
      ),
    );
  }
}
