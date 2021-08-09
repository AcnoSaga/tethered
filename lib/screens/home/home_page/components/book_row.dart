import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:tethered/models/category.dart';
import 'package:tethered/models/genre.dart';
import 'package:tethered/models/hashtag.dart';
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
  final Category resource;
  const BookRow({
    Key key,
    this.title,
    this.titlePadding,
    this.isResourceExpandable = false,
    this.resourceType = ResourceTypes.hashtag,
    this.resource,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                                  "genre": resource,
                                }
                              : {
                                  "hashtagId": (resource as Hashtag).name,
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
            itemCount: () {
              if (resource is Genre) {
                return (resource as Genre).home.length;
              } else if (resource is Hashtag) {
                return (resource as Hashtag).works.length;
              }
              return 0;
            }(),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: sy * 2),
                child: Container(
                  color: Colors.transparent,
                  width: sy * 30,
                  child: _renderBookCard(index, context),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _renderBookCard(int index, BuildContext context) {
    if (resource is Genre) {
      final bookCovers = (resource as Genre).home;
      return GestureDetector(
        onTap: () {
          Get.toNamed(
            HomeRoutes.bookDetails,
            arguments: {
              "bookCovers": bookCovers,
              "index": index,
            },
            id: tabItemsToIndex[TabItem.home],
          );
        },
        child: Container(
          margin: EdgeInsets.symmetric(vertical: sx),
          child: BookCard(bookCover: bookCovers[index]),
        ),
      );
    } else if (resource is Hashtag) {
      final bookCovers = (resource as Hashtag).works;
      return GestureDetector(
        onTap: () => Get.toNamed(
          HomeRoutes.bookDetails,
          arguments: {
            "bookCovers": bookCovers,
            "index": index,
          },
          id: tabItemsToIndex[Provider.of<TabItem>(context, listen: false)],
        ),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: sx),
          child: BookCard(bookCover: bookCovers[index]),
        ),
      );
    } else {
      throw UnimplementedError();
    }
  }
}
