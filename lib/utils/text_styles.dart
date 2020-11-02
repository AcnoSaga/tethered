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
  static TextStyle bookDetailsHeading = GoogleFonts.montserrat(
    color: TetheredColors.authHeading,
    fontSize: sText * 5,
    // letterSpacing: 2,
    fontWeight: FontWeight.w300,
  );
  static TextStyle authSubHeading = GoogleFonts.poppins(
    color: TetheredColors.authHeading,
    fontSize: sText * 5,
    letterSpacing: 2,
    fontWeight: FontWeight.w300,
  );

  static TextStyle displayText = GoogleFonts.poppins(
    color: TetheredColors.authHeading,
    fontSize: sText * 3,
    letterSpacing: 2,
    fontWeight: FontWeight.w300,
  );

  static TextStyle descriptionText = GoogleFonts.roboto(
    color: TetheredColors.authHeading,
    fontSize: sText * 3,
    letterSpacing: 1,
    // fontWeight: FontWeight.w300,
  );

  static TextStyle displayTextSelected = GoogleFonts.poppins(
    color: TetheredColors.authHeading,
    fontSize: sText * 3,
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

  static TextStyle homeAppBarHeading = GoogleFonts.montserrat(
    color: TetheredColors.primaryBlue,
    letterSpacing: 2,
    fontSize: sText * 6,
  );

  static TextStyle indexItemHeading = GoogleFonts.montserrat(
    color: TetheredColors.indexItemTextColor,
    fontSize: sText * 5,
    letterSpacing: 1.5,
    fontWeight: FontWeight.w400,
  );

  static TextStyle indexTabTextStyle = indexItemHeading.copyWith(
    fontSize: sText * 4,
  );

  static TextStyle indexItemDescription = TextStyle(
    color: TetheredColors.indexItemTextColor,
  );
}
