import 'package:flutter/material.dart';
import 'package:tethered/utils/colors.dart';

class ExploreCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: TetheredColors.primaryBlue,
        borderRadius: BorderRadius.circular(10),
      ),
      width: 200,
    );
  }
}
