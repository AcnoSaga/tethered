import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tethered/models/hashtag.dart';
import 'package:tethered/screens/components/book_card.dart';
import 'package:tethered/screens/components/gap.dart';
import 'package:tethered/theme/size_config.dart';
import 'package:tethered/utils/colors.dart';
import 'package:tethered/utils/enums/tab_item.dart';
import 'package:tethered/utils/inner_routes/home_routes.dart';

import 'package:tethered/utils/text_styles.dart';

class HashtagPage extends StatefulWidget {
  final Hashtag hashtag;

  const HashtagPage({Key key, this.hashtag}) : super(key: key);

  @override
  _HashtagPageState createState() => _HashtagPageState();
}

class _HashtagPageState extends State<HashtagPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TetheredColors.primaryDark,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            elevation: 10,
            // pinned: true,
            floating: true,
            backgroundColor: TetheredColors.primaryDark,
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: sy * 5, vertical: sx * 7),
            sliver: SliverToBoxAdapter(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.hashtag.name,
                    style: TetheredTextStyles.authHeading,
                    textAlign: TextAlign.center,
                  ),
                  Gap(height: 2),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: sy * 10),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () => Get.toNamed(
                      HomeRoutes.bookDetails,
                      arguments: {
                        "bookCovers": widget.hashtag.works,
                        "index": index,
                        "title": widget.hashtag,
                      },
                      id: tabItemsToIndex[TabItem.home],
                    ),
                    child: BookCard(bookCover: widget.hashtag.works[index]),
                  );
                },
                childCount: widget.hashtag.works.length,
              ),
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: sy * 60,
                mainAxisSpacing: sx * 5,
                crossAxisSpacing: sy * 10,
                childAspectRatio: 0.7,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
