import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tethered/theme/size_config.dart';

import 'colors.dart';

class TetheredTextStyles {
  static TextStyle authHeading = GoogleFonts.montserrat(
    color: TetheredColors.authHeading,
    fontSize: sText * 11,
    letterSpacing: 5,
    fontWeight: FontWeight.w300,
  );
  static TextStyle authSubHeading = GoogleFonts.poppins(
    color: TetheredColors.authHeading,
    fontSize: sText * 5,
    letterSpacing: 2,
    fontWeight: FontWeight.w300,
  );
  static TextStyle textField = GoogleFonts.poppins(
    color: TetheredColors.textFieldText,
    fontWeight: FontWeight.w300,
    letterSpacing: 2,
    fontSize: sText * 4,
  );

  static TextStyle proceedButtonText = GoogleFonts.poppins(
    color: TetheredColors.primaryDark,
    fontWeight: FontWeight.w400,
    letterSpacing: 1,
    fontSize: sText * 4.5,
  );

  static TextStyle passiveTextButton = GoogleFonts.poppins(
    color: TetheredColors.textFieldText,
    fontWeight: FontWeight.w200,
    letterSpacing: 1,
    fontSize: sText * 3.5,
  );
}
