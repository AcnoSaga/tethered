import 'package:flutter/material.dart';
import 'package:tethered/utils/colors.dart';
import 'package:tethered/utils/text_styles.dart';

class GenreDropdownInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      dropdownColor: TetheredColors.textFieldBackground,
      hint: Text(
        'Choose a genre',
        style: TetheredTextStyles.textField,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: TetheredColors.textFieldBackground,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(3.0),
        ),
        hintStyle: TetheredTextStyles.textField,
      ),
      items: [
        DropdownMenuItem(
          child: Text(
            'Horror',
            style: TetheredTextStyles.textField,
          ),
          value: 'Horror',
        ),
        DropdownMenuItem(
          child: Text(
            'Action',
            style: TetheredTextStyles.textField,
          ),
          value: 'Action',
        ),
      ],
      onChanged: (item) {},
    );
  }
}
