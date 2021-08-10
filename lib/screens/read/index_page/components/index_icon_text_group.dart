import 'package:flutter/material.dart';
import '../../../components/gap.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/number_shortener.dart';
import '../../../../utils/text_styles.dart';

class IndexIconTextGroup extends StatelessWidget {
  final IconData icon;
  final int number;

  const IndexIconTextGroup({Key key, this.icon, this.number}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: TetheredColors.indexItemTextColor,
        ),
        Gap(width: 0.5),
        Text(
          numberShortener(number),
          style: TetheredTextStyles.indexItemDescription,
        ), 
      ],
    );
  }
}
