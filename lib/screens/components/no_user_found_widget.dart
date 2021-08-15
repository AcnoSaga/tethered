import 'package:flutter/material.dart';
import 'package:tethered/theme/size_config.dart';
import '../../utils/colors.dart';
import '../../utils/text_styles.dart';

class NoUserFoundWidget extends StatelessWidget {
  final String name;

  const NoUserFoundWidget({Key key, this.name}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: TetheredColors.textFieldBackground,
        ),
        child: Center(
          child: Text(
            name.substring(0, 1).toUpperCase(),
            style: TetheredTextStyles.authSubHeading
                .copyWith(fontSize: sText * 10),
          ),
        ),
      ),
    );
  }
}
