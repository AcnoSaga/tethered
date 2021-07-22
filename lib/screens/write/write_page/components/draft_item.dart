import 'dart:math';

import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tethered/screens/components/gap.dart';
import 'package:tethered/screens/components/image_error_widget.dart';
import 'package:tethered/screens/components/widgets/book_details_tag.dart';
import 'package:tethered/theme/size_config.dart';
import 'package:tethered/utils/colors.dart';
import 'package:tethered/utils/text_styles.dart';

class DraftItem extends StatelessWidget {
  final bool published;

  const DraftItem({Key key, this.published}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: published ? null : () => Get.toNamed('/edit'),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: sy * 2,
          vertical: sx * 2,
        ),
        decoration: BoxDecoration(
          color: TetheredColors.textFieldBackground,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Expanded(
              // child: Container(),
              child: Badge(
                badgeContent: Icon(
                  Icons.add,
                  color: TetheredColors.indexItemTextColor,
                ),
                badgeColor: TetheredColors.primaryDark,
                showBadge: Random().nextBool(),
                position: BadgePosition.bottomEnd(),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    // width: 300,
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: Colors.grey[500],
                      highlightColor: Colors.grey[400],
                      child: Center(
                        child: Container(
                          color: Colors.white,
                          child: LimitedBox(
                            maxHeight: sx * 20,
                            child: SizedBox.expand(),
                          ),
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => ImageErrorWidget(),
                    fit: BoxFit.fill,
                    imageUrl: 'https://picsum.photos/seed/picsum/200/300',
                  ),
                ),
              ),
            ),
            Gap(width: 4),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Text('Jules and Vega',
                          style: TetheredTextStyles.indexItemHeading),
                      if (!published)
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () => showModalBottomSheet(
                              context: context,
                              builder: (context) => BottomSheet(
                                builder: (BuildContext context) => ListView(
                                  shrinkWrap: true,
                                  children: [
                                    ListTile(
                                      title: Text('Delete'),
                                      leading: Icon(Icons.delete),
                                    ),
                                    ListTile(
                                      title: Text('Edit'),
                                      leading: Icon(Icons.edit),
                                    ),
                                  ],
                                ),
                                onClosing: () {},
                              ),
                            ),
                            child: Icon(
                              Icons.more_horiz,
                              color: TetheredColors.indexItemTextColor,
                            ),
                          ),
                        ),
                    ],
                  ),
                  Gap(height: 1.5),
                  Text(
                    '${published ? "Published" : "Last updated"}: 19/11/20',
                    style: TetheredTextStyles.indexItemDescription,
                  ),
                  Gap(height: 1.5),
                  Text(
                    'Hitmen Jules Winnfield and Vincent Vega arrive at an apartment to retrieve a briefcase for their boss, gangster Marsellus Wallace, from a business partner.',
                    style: TetheredTextStyles.indexItemDescription,
                    textAlign: TextAlign.justify,
                    strutStyle: StrutStyle(height: 1.5),
                    softWrap: true,
                  ),
                  Gap(height: 2),
                  Wrap(
                    spacing: sy,
                    children: [
                      BookDetailsTag(
                        label: '#horror',
                        color: TetheredColors.primaryDark,
                      ),
                      BookDetailsTag(
                        label: '#thriller',
                        color: TetheredColors.primaryDark,
                      ),
                      BookDetailsTag(
                        label: '#action',
                        color: TetheredColors.primaryDark,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}