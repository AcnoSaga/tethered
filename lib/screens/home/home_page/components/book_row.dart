import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:tethered/screens/components/book_card.dart';
import 'package:tethered/theme/size_config.dart';
import 'package:tethered/utils/enums/resource_types.dart';
import 'package:tethered/utils/enums/tab_item.dart';
import 'package:tethered/utils/inner_routes/home_routes.dart';
import 'package:tethered/utils/text_styles.dart';

class BookRow extends StatelessWidget {
  final String title;
  final EdgeInsetsGeometry titlePadding;
  final bool isResourceExpandable;
  final ResourceTypes resourceType;
  const BookRow({
    Key key,
    this.title,
    this.titlePadding,
    this.isResourceExpandable = false,
    this.resourceType = ResourceTypes.hashtag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final urls = <String>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 3,
              child: Padding(
                padding: titlePadding ?? EdgeInsets.zero,
                child: Text(
                    resourceType == ResourceTypes.genre
                        ? title
                        : "Trending in $title",
                    style: TetheredTextStyles.authSubHeading),
              ),
            ),
            isResourceExpandable
                ? Expanded(
                    flex: 2,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () => Get.toNamed(
                          resourceType == ResourceTypes.genre
                              ? HomeRoutes.genrePage
                              : HomeRoutes.hashtagPage,
                          arguments: resourceType == ResourceTypes.genre
                              ? {
                                  "genre": title,
                                }
                              : {
                                  "hashtag": title,
                                },
                          id: tabItemsToIndex[
                              Provider.of<TabItem>(context, listen: false)],
                        ),
                        child: Padding(
                          padding: titlePadding ?? EdgeInsets.zero,
                          child: Text('See all >',
                              style: TetheredTextStyles.passiveTextButton),
                        ),
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
        Container(
          color: Colors.transparent,
          height: sx * 22,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: 20,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              Random rnd;
              int min = 1050;
              int max = 1080;
              rnd = new Random();
              int value = min + rnd.nextInt(max - min);
              final String url = 'https://picsum.photos/id/$value/400/600';
              urls.add(url);
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: sy * 2),
                child: Container(
                  color: Colors.transparent,
                  width: sy * 30,
                  child: GestureDetector(
                    onTap: () => Get.toNamed(
                      HomeRoutes.bookDetails,
                      arguments: {
                        "urls": urls,
                        "index": urls.indexOf(url),
                        "title": title,
                      },
                      id: tabItemsToIndex[TabItem.home],
                    ),
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: sx),
                      child: BookCard(url: url),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
