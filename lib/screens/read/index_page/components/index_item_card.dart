import 'package:flutter/material.dart';
import 'package:tethered/models/index_item.dart';
import 'package:tethered/screens/components/gap.dart';
import 'package:tethered/screens/read/index_page/components/index_icon_text_group.dart';
import 'package:tethered/theme/size_config.dart';
import 'package:tethered/utils/colors.dart';
import 'package:tethered/utils/text_styles.dart';

class IndexItemCard extends StatelessWidget {
  final IndexItem indexItem;
  final void Function() onTap;

  const IndexItemCard({Key key, this.indexItem, this.onTap}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: sy * 2,
        vertical: sx * 2,
      ),
      decoration: BoxDecoration(
        color: TetheredColors.textFieldBackground,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(indexItem.title, style: TetheredTextStyles.indexItemHeading),
          Gap(height: 1.5),
          Text(
            indexItem.description,
            style: TetheredTextStyles.indexItemDescription,
            textAlign: TextAlign.justify,
            strutStyle: StrutStyle(height: 1.5),
          ),
          Gap(height: 2),
          Wrap(
            runAlignment: WrapAlignment.end,
            alignment: WrapAlignment.end,
            spacing: sy * 3,
            children: [
              IndexIconTextGroup(
                icon: Icons.arrow_upward_sharp,
                number: indexItem.likes,
              ),
              // Spacer(),
            ],
          ),
        ],
      ),
    );
  }
}
