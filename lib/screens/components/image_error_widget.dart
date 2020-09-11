import 'package:flutter/material.dart';
import 'package:tethered/utils/colors.dart';
import 'package:tethered/utils/text_styles.dart';

class ImageErrorWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Container(
        color: TetheredColors.textFieldBackground,
        child: Center(
          child: Text(
            'Error',
            style: TetheredTextStyles.authSubHeading,
          ),
        ),
      ),
    );
  }
}
