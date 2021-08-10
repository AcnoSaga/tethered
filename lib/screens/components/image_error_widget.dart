import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/text_styles.dart';

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
