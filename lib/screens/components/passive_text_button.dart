import 'package:flutter/material.dart';
import 'package:tethered/utils/text_styles.dart';

class PassiveTextButton extends StatelessWidget {
  final String text;
  final void Function() onPressed;

  const PassiveTextButton({Key key, this.text, this.onPressed})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Text(
        text ?? 'Proceed',
        style: TetheredTextStyles.passiveTextButton,
      ),
    );
  }
}
