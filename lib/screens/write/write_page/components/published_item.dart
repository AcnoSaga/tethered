import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tethered/models/book_cover.dart';
import 'package:tethered/utils/enums/tab_item.dart';
import 'package:tethered/utils/inner_routes/home_routes.dart';
import '../../../../models/published_draft.dart';
import '../../../components/gap.dart';
import '../../../components/image_error_widget.dart';
import '../../../components/widgets/book_details_tag.dart';
import '../../../../theme/size_config.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/text_styles.dart';

class PublishedDraftItem extends StatelessWidget {
  final PublishedDraft publishedDraft;

  const PublishedDraftItem({
    Key key,
    this.publishedDraft,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print(publishedDraft.imageUrl);
        print(publishedDraft.workRef);
        return Get.toNamed(
          HomeRoutes.bookDetails,
          arguments: {
            "bookCovers": [
              BookCover(
                imageUrl: publishedDraft.imageUrl,
                workRef: publishedDraft.workRef,
              )
            ],
            "index": 0,
          },
          id: tabItemsToIndex[Provider.of<TabItem>(context, listen: false)],
        );
      },
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
              child: Badge(
                badgeContent: Icon(
                  Icons.add,
                  color: TetheredColors.indexItemTextColor,
                ),
                badgeColor: TetheredColors.primaryDark,
                showBadge: publishedDraft.isTether ?? false,
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
                    imageUrl: publishedDraft.imageUrl,
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
                  Text(publishedDraft.title,
                      style: TetheredTextStyles.indexItemHeading),
                  Gap(height: 1.5),
                  Text(
                    'Published: ' +
                        publishedDraft.published.day.toString() +
                        '/' +
                        publishedDraft.published.month.toString() +
                        '/' +
                        publishedDraft.published.year.toString(),
                    style: TetheredTextStyles.indexItemDescription,
                  ),
                  Gap(height: 1.5),
                  Text(
                    () {
                      if (publishedDraft.description.length > 150) {
                        return publishedDraft.description.substring(0, 150) +
                            '...';
                      }
                      return publishedDraft.description;
                    }(),
                    style: TetheredTextStyles.indexItemDescription,
                    textAlign: TextAlign.justify,
                    strutStyle: StrutStyle(height: 1.5),
                    softWrap: true,
                  ),
                  Gap(height: 2),
                  Wrap(
                    spacing: sy,
                    children: publishedDraft.hashtags
                        .map(
                          (label) => BookDetailsTag(
                            label: label,
                            color: TetheredColors.primaryDark,
                          ),
                        )
                        .toList(),
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
