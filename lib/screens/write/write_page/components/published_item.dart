import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../models/published_draft.dart';
import '../../../components/gap.dart';
import '../../../components/image_error_widget.dart';
import '../../../components/widgets/book_details_tag.dart';
import '../../../../theme/size_config.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/text_styles.dart';

import 'draft_item.dart';

class PublishedDraftItem extends StatelessWidget {
  final DocumentType documentType;
  final PublishedDraft publishedDraft;

  const PublishedDraftItem({
    Key key,
    this.documentType = DocumentType.tether,
    this.publishedDraft,
  }) : super(key: key);
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
      child: Row(
        children: [
          Expanded(
            child: Badge(
              badgeContent: Icon(
                Icons.add,
                color: TetheredColors.indexItemTextColor,
              ),
              badgeColor: TetheredColors.primaryDark,
              showBadge: documentType == DocumentType.tether,
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
                Text('Jules and Vega',
                    style: TetheredTextStyles.indexItemHeading),
                Gap(height: 1.5),
                Text(
                  'Last updated: 19/11/20',
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
    );
  }
}
