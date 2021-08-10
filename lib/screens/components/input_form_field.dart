import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/text_styles.dart';

class InputFormField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final String Function(String) validator;
  final bool isObscure;
  final int minLines;
  final int maxLines;

  const InputFormField({
    Key key,
    this.hintText,
    this.controller,
    this.validator,
    this.isObscure = false,
    this.minLines,
    this.maxLines,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      minLines: minLines,
      maxLines: maxLines ?? 1,
      style: TetheredTextStyles.textField,
      cursorColor: TetheredTextStyles.textField.color,
      controller: controller,
      validator: validator,
      obscureText: isObscure,
      decoration: InputDecoration(
        filled: true,
        fillColor: TetheredColors.textFieldBackground,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(3.0),
        ),
        hintText: hintText,
        hintStyle: TetheredTextStyles.textField,
      ),
    );
  }
}
