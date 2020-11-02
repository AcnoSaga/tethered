import 'package:flutter/material.dart';
import 'package:tethered/screens/components/gap.dart';
import 'package:tethered/utils/colors.dart';
import 'package:tethered/utils/text_styles.dart';

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
          number.toString(),
          style: TetheredTextStyles.indexItemDescription,
        ), // TODO: Shorten number with suffix (K, M, B)
      ],
    );
  }
}
