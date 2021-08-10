import 'package:flutter/material.dart';
import '../../../../models/index_item.dart';
import '../../../components/gap.dart';
import 'index_icon_text_group.dart';
import '../../../../theme/size_config.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/text_styles.dart';

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
