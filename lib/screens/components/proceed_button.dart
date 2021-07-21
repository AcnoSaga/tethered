import 'package:flutter/material.dart';
import 'package:tethered/theme/size_config.dart';
import 'package:tethered/utils/colors.dart';
import 'package:tethered/utils/text_styles.dart';

class ProceedButton extends StatelessWidget {
  final String text;
  final void Function() onPressed;

  const ProceedButton({Key key, this.text, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        elevation: MaterialStateProperty.all<double>(5.0),
        backgroundColor:
            MaterialStateProperty.all<Color>(TetheredColors.primaryBlue),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: sy * 3),
            child: Text(
              text,
              style: TetheredTextStyles.proceedButtonText,
            ),
          ),
        ],
      ),
      onPressed: onPressed,
    );
  }
}
