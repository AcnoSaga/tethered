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
  final String title = 'Jules and Vega';
  final String imgUrl = "https://picsum.photos/seed/picsum/200/300";
  final String description =
      "Hitmen Jules Winnfield and Vincent Vega arrive at an apartment to retrieve a briefcase for their boss, gangster Marsellus Wallace, from a business partner.";
  final bool published;
  final DocumentType documentType;
  final Draft draft;

  const DraftItem(
      {Key key, this.published, this.documentType = DocumentType.tether, this.draft})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: published ? null : () => Get.toNamed('/edit', arguments: draft.doc),
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
                    imageUrl: book == null ? imgUrl : book.imgUrl,
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
                      Text(book == null ? title : book.authorName,
                          style: TetheredTextStyles.indexItemHeading),
                      if (!published)
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
                    '${published ? "Published" : "Last updated"}: ${book == null ? "Dummy Date" : book.date}',
                    style: TetheredTextStyles.indexItemDescription,
                  ),
                  Gap(height: 1.5),
                  Text(
                    book == null ? description : book.desc,
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

  Future _deleteDialog() async {
    await Get.dialog(
      AlertDialog(
        title: Text(
            'Are you sure you want to delete this ${documentType == DocumentType.tether ? 'draft' : 'story'}?'),
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
            ListTile(
              title: Text('Edit'),
              leading: Icon(Icons.edit),
              onTap: () => Navigator.pop(context),
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
