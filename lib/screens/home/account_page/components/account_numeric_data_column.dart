import 'package:flutter/material.dart';
import 'package:tethered/utils/number_shortener.dart';
import 'package:tethered/utils/text_styles.dart';

class AccountNumericDataColumn extends StatelessWidget {
  final String title;
  final num data;

  const AccountNumericDataColumn({Key key, this.title, this.data})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: TetheredTextStyles.displayText,
        ),
        Text(
          numberShortener(data),
          style: TetheredTextStyles.displayText,
        ),
      ],
    );
  }
}
