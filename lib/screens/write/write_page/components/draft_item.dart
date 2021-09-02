import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tethered/riverpods/global/app_busy_status_provider.dart';
import '../../../../models/draft.dart';
import '../../../components/gap.dart';
import '../../../components/image_error_widget.dart';
import '../../../components/widgets/book_details_tag.dart';
import '../../../../theme/size_config.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/text_styles.dart';

class DraftItem extends ConsumerWidget {
  final Draft draft;
  final void Function() onDelete;
  DraftItem({Key key, this.draft, this.onDelete}) : super(key: key);

  final ValueNotifier<bool> deleting = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final isAppBusyStatusNotifier = watch(appBusyStatusProvider.notifier);
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

  Future _deleteDialog(AppBusyStatusNotifier appBusyStatusNotifier) async {
    await Get.dialog(
      AlertDialog(
        title: Text(
            'Are you sure you want to delete this ${draft.isTether ? 'draft' : 'story'}?'),
        actions: [
          TextButton.icon(
            onPressed: deleting.value
                ? null
                : () async {
                    appBusyStatusNotifier.startWork();
                    if (!draft.doc['isTether']) {
                      final ref = FirebaseStorage.instance
                          .ref(draft.doc.reference.path + '.png');
                      print(draft.doc.reference.path + '.png');
                      await ref.delete();
                    }
                    await draft.doc.reference.delete();
                    onDelete();
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
      BuildContext context, AppBusyStatusNotifier appBusyStatusNotifier) {
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
                await _deleteDialog(appBusyStatusNotifier);

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
