import 'package:algolia/algolia.dart';
import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:provider/provider.dart' as FlutterBase;
import 'package:shimmer/shimmer.dart';
import 'package:tethered/models/book_cover.dart';
import 'package:tethered/riverpods/global/app_busy_status_provider.dart';
import 'package:tethered/screens/search/search_page/components/algoliaapp.dart';
import 'package:tethered/utils/enums/tab_item.dart';
import 'package:tethered/utils/inner_routes/home_routes.dart';
import '../../../../models/published_draft.dart';
import '../../../components/gap.dart';
import '../../../components/image_error_widget.dart';
import '../../../components/widgets/book_details_tag.dart';
import '../../../../theme/size_config.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/text_styles.dart';

class PublishedDraftItem extends ConsumerWidget {
  final PublishedDraft publishedDraft;
  final void Function() onDelete;

  PublishedDraftItem({
    Key key,
    this.publishedDraft,
    this.onDelete,
  }) : super(key: key);

  final ValueNotifier<bool> deleting = ValueNotifier<bool>(false);
  final AlgoliaIndexReference algoliaUserIndex =
      AlgoliaApplication.writeAlgolia.index('works');

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final isAppBusyStatusNotifier = watch(appBusyStatusProvider.notifier);

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
          id: tabItemsToIndex[
              FlutterBase.Provider.of<TabItem>(context, listen: false)],
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
                  Stack(
                    children: [
                      Text(publishedDraft.title,
                          style: TetheredTextStyles.indexItemHeading),
                      if (!publishedDraft.isTether &&
                          publishedDraft.creatorId ==
                              FirebaseAuth.instance.currentUser.uid &&
                          onDelete != null)
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () => _showDeleteDialog(
                                context, isAppBusyStatusNotifier),
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
      ),
    );
  }

  Future _deleteDialog(AppBusyStatusNotifier appBusyStatusNotifier) async {
    await Get.dialog(
      AlertDialog(
        title: Text('Are you sure you want to delete this book?'),
        actions: [
          TextButton.icon(
            onPressed: deleting.value
                ? null
                : () async {
                    deleting.value = true;
                    appBusyStatusNotifier.startWork();
                    if (!publishedDraft.doc['isTether']) {
                      print(
                          'works/' + publishedDraft.doc.reference.id + '.png');
                      final ref = FirebaseStorage.instance.ref("works/" +
                          (publishedDraft.doc['workRef'] as DocumentReference)
                              .id +
                          '.png');
                      print(ref.fullPath);
                      await ref.delete();
                    }
                    final workRef =
                        (publishedDraft.doc['workRef'] as DocumentReference);
                    await algoliaUserIndex.object(workRef.id).deleteObject();
                    await workRef.delete();
                    await publishedDraft.doc.reference.delete();
                    onDelete();
                    deleting.value = false;
                    Get.back();
                    appBusyStatusNotifier.endWork();
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
            onPressed: deleting.value ? null : () => Get.back(),
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

  void _showDeleteDialog(
      BuildContext context, AppBusyStatusNotifier isAppBusyStatusNotifier) {
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
                await _deleteDialog(isAppBusyStatusNotifier);

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
