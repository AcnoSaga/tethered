import 'package:flutter/material.dart';
import '../../../../models/entry_item.dart';
import '../../../components/gap.dart';
import '../../../../theme/size_config.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/text_styles.dart';

import 'index_icon_text_group.dart';

class EntryItemCard extends StatelessWidget {
  final EntryItem entryItem;

  const EntryItemCard({Key key, this.entryItem}) : super(key: key);
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
          Text(entryItem.title, style: TetheredTextStyles.indexItemHeading),
          Gap(height: 1.5),
          Text(
            entryItem.description,
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
                number: entryItem.likes,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
