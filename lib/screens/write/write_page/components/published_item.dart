import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
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
              showBadge: publishedDraft.isTether,
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
                Stack(
                  children: [
                    Text(publishedDraft.title,
                        style: TetheredTextStyles.indexItemHeading),
                    if (publishedDraft.creatorId ==
                        FirebaseAuth.instance.currentUser.uid)
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () => _showDeleteDialog(context),
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
    );
  }

  Future _deleteDialog() async {
    await Get.dialog(
      AlertDialog(
        title: Text(
            'Are you sure you want to delete this ${publishedDraft.isTether ? 'draft' : 'story'}?'),
        actions: [
          TextButton.icon(
            onPressed: Get.back,
            icon: Icon(
              Icons.check_circle,
              color: TetheredColors.acceptNegativeColor,
            ),
            label: Text(
              'Yes',
              style: TetheredTextStyles.acceptNegativeText,
            ),
          ),
          TextButton.icon(
            onPressed: Get.back,
            icon: Icon(
              Icons.cancel,
              color: TetheredColors.rejectNegativeColor,
            ),
            label: Text(
              'No',
              style: TetheredTextStyles.rejectNegativeText,
            ),
          ),
        ],
      ),
    );
    Get.back();
  }

  void _showDeleteDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => BottomSheet(
        builder: (BuildContext context) => ListView(
          shrinkWrap: true,
          children: [
            ListTile(
              title: Text('Delete'),
              leading: Icon(Icons.delete),
              onTap: () async {
                await _deleteDialog();
                Navigator.pop(context);
              },
            ),
          ],
        ),
        onClosing: () {},
      ),
    );
  }
}
