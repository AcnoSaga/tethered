import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../models/draft.dart';
import '../../../components/gap.dart';
import '../../../components/image_error_widget.dart';
import '../../../components/widgets/book_details_tag.dart';
import '../../../../theme/size_config.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/text_styles.dart';

class DraftItem extends StatelessWidget {
  final Draft draft;
  final void Function() onDelete;
  const DraftItem({Key key, this.draft, this.onDelete}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed('/edit', arguments: draft.doc),
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
                showBadge: draft.isTether,
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
                    imageUrl: draft.imageUrl,
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
                      Text(draft.title,
                          style: TetheredTextStyles.indexItemHeading),
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
                    'Last updated: ' +
                        draft.lastUpdated.day.toString() +
                        '/' +
                        draft.lastUpdated.month.toString() +
                        '/' +
                        draft.lastUpdated.year.toString(),
                    style: TetheredTextStyles.indexItemDescription,
                  ),
                  Gap(height: 1.5),
                  Text(
                    () {
                      if (draft.description.length > 150) {
                        return draft.description.substring(0, 150) + '...';
                      }
                      return draft.description;
                    }(),
                    style: TetheredTextStyles.indexItemDescription,
                    textAlign: TextAlign.justify,
                    strutStyle: StrutStyle(height: 1.5),
                    softWrap: true,
                  ),
                  Gap(height: 2),
                  Wrap(
                    spacing: sy,
                    children: draft.hashtags
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

  Future _deleteDialog() async {
    await Get.dialog(
      AlertDialog(
        title: Text(
            'Are you sure you want to delete this ${draft.isTether ? 'draft' : 'story'}?'),
        actions: [
          TextButton.icon(
            onPressed: () async {
              await draft.doc.reference.delete();
              onDelete();
              Get.back();
            },
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
    print('------------------------------');
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

enum DocumentType {
  tether,
  story,
}
