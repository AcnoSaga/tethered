import 'package:flutter/material.dart';
import 'package:tethered/screens/components/gap.dart';
import 'package:tethered/theme/size_config.dart';
import 'package:tethered/utils/colors.dart';
import 'package:tethered/utils/text_styles.dart';

class BookDetailsInfoText extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const BookDetailsInfoText({
    Key key,
    this.icon,
    this.text,
    this.color,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: sy * 2,
        vertical: sx,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            child: Icon(
              icon,
              color: color ?? TetheredColors.bookDetailText,
            ),
          ),
          Gap(width: 1),
          Text(
            text,
            style: color == null
                ? TetheredTextStyles.displayText
                : TetheredTextStyles.displayText.copyWith(
                    color: color,
                  ),
          ),
        ],
      ),
    );
  }
}