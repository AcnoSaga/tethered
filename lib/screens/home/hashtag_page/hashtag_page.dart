import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../riverpods/home/hashtag_page_provider.dart';
import '../../components/book_card.dart';
import '../../components/gap.dart';
import '../../../theme/size_config.dart';
import '../../../utils/colors.dart';
import 'package:provider/provider.dart' as FlutterBase;
import '../../../utils/enums/tab_item.dart';
import '../../../utils/inner_routes/home_routes.dart';

import '../../../utils/text_styles.dart';

class HashtagPage extends ConsumerWidget {
  final String hashtagId;

  const HashtagPage({Key key, this.hashtagId}) : super(key: key);

  Widget build(BuildContext context, ScopedReader watch) {
    final String id = hashtagId ?? Get.arguments["hashtagId"] as String;
    final hashtagPageState = watch(hashtagPageStateProvider(id));
    return Scaffold(
      backgroundColor: TetheredColors.primaryDark,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            brightness: Brightness.dark,

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
                    id,
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
              sliver: () {
                if (hashtagPageState is HashtagPageInitial) {
                  return SliverToBoxAdapter(child: Container());
                } else if (hashtagPageState is HashtagPageLoading) {
                  return SliverToBoxAdapter(
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (hashtagPageState is HashtagPageError) {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: Text(
                        "An unexpected error occured..",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                } else if (hashtagPageState is HashtagPageLoaded) {
                  return SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            if (hashtagId != null) {
                              Get.toNamed(
                                HomeRoutes.bookDetails,
                                arguments: {
                                  "bookCovers": hashtagPageState.hashtag.works,
                                  "index": index,
                                },
                                id: tabItemsToIndex[
                                    FlutterBase.Provider.of<TabItem>(
                                  context,
                                  listen: false,
                                )],
                              );
                            } else {
                              Get.toNamed(
                                '/book-details',
                                arguments: {
                                  "bookCovers": hashtagPageState.hashtag.works,
                                  "index": index,
                                },
                              );
                            }
                          },
                          child: BookCard(
                              bookCover: hashtagPageState.hashtag.works[index]),
                        );
                      },
                      childCount: hashtagPageState.hashtag.works.length,
                    ),
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: sy * 60,
                      mainAxisSpacing: sx * 5,
                      crossAxisSpacing: sy * 10,
                      childAspectRatio: 0.7,
                    ),
                  );
                } else {
                  throw UnimplementedError();
                }
              }()),
        ],
      ),
    );
  }
}
