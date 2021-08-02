import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tethered/models/book_cover.dart';
import 'package:tethered/models/book_details.dart';
import 'package:tethered/riverpods/home/book_detail/book_carousel_index_provider.dart';
import 'package:tethered/riverpods/home/book_detail/book_info_provider.dart';
import 'package:tethered/screens/components/gap.dart';
import 'package:tethered/screens/components/image_error_widget.dart';
import 'package:tethered/screens/components/proceed_button.dart';
import 'package:tethered/screens/home/book_details_page/components/book_details_info_text.dart';

import 'package:tethered/theme/size_config.dart';
import 'package:tethered/utils/colors.dart';
import 'package:tethered/utils/text_styles.dart';

import '../../components/widgets/book_details_tag.dart';

class BookDetailPage extends HookWidget {
  final List<BookCover> bookCovers;
  final int startingIndex;

  const BookDetailPage({Key key, this.bookCovers, this.startingIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final itemBorderRadius = BorderRadius.circular(10);
    final indexProvider = bookCarouselIndexProvider(startingIndex);
    final currentIndex = useProvider(indexProvider);
    final bookDetailsProvider = useProvider(
      bookDetailsStateProviderProvider(
        BookDetailsStateProviderProviderData(
          bookCovers: bookCovers,
          provider: indexProvider,
        ),
      ),
    );
    final bookDetailsState = useProvider(bookDetailsProvider);

    return Scaffold(
      backgroundColor: TetheredColors.primaryDark,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: TetheredColors.primaryDark,
        actions: [
          GestureDetector(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: sy * 5),
              child: Icon(Icons.bookmark_border),
            ),
            onTap: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: GestureDetector(
          child: Column(
            children: [
              _bookCarousel(itemBorderRadius, currentIndex),
              Gap(height: 5),
              () {
                if (bookDetailsState is BookDetailsInitial) {
                  return Container();
                } else if (bookDetailsState is BookDetailsLoading) {
                  return CircularProgressIndicator();
                } else if (bookDetailsState is BookDetailsError) {
                  return Center(
                    child: Text("Please try again."),
                  );
                } else if (bookDetailsState is BookDetailsLoaded) {
                  return _bookInfo(bookDetailsState.bookDetails);
                } else {
                  throw UnimplementedError();
                }
              }(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bookCarousel(
    BorderRadius itemBorderRadius,
    StateController<int> currentIndex,
  ) {
    return CarouselSlider(
      options: CarouselOptions(
        viewportFraction: 0.66,
        enableInfiniteScroll: false,
        aspectRatio: 1,
        enlargeCenterPage: true,
        initialPage: startingIndex,
        onPageChanged: (index, reason) {
          currentIndex.state = index;
          print(currentIndex.state);
        },
      ),
      items: bookCovers
          .map((bookCover) => Container(
                margin: EdgeInsets.all(sx * 2),
                child: Material(
                  color: Colors.transparent,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: itemBorderRadius,
                  ),
                  child: ClipRRect(
                    borderRadius: itemBorderRadius,
                    child: CachedNetworkImage(
                      placeholder: (context, url) => Shimmer.fromColors(
                          baseColor: Colors.grey[500],
                          highlightColor: Colors.grey[400],
                          child: Center(
                            child: Container(
                              color: Colors.white,
                              child: SizedBox.expand(),
                            ),
                          )),
                      errorWidget: (context, url, error) => ImageErrorWidget(),
                      fit: BoxFit.fill,
                      imageUrl: bookCover.imageUrl,
                    ),
                  ),
                ),
              ))
          .toList(),
    );
  }

  Widget _bookInfo(BookDetails details) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: sy * 5),
          child: Column(
            children: [
              Text(
                details.title,
                style: TetheredTextStyles.bookDetailsHeading,
                textAlign: TextAlign.center,
              ),
              Gap(height: 2),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                alignment: WrapAlignment.center,
                children: [
                  BookDetailsInfoText(
                    icon: Icons.arrow_upward,
                    text: '12K upvotes',
                  ),
                  BookDetailsInfoText(
                    icon: Icons.list,
                    text: '21 Tethers',
                  ),
                ],
              ),
              Gap(height: 1),
              Text(
                details.description,
                style: TetheredTextStyles.descriptionText,
                textAlign: TextAlign.justify,
                strutStyle: StrutStyle(height: 1.1),
                // strutStyle: StrutStyle.disabled,
              ),
              Gap(height: 3),
            ],
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                // shrinkWrap: true,
                // scrollDirection: Axis.horizontal,
                children: details.hashtags
                    .map((label) => Row(
                          children: [
                            Gap(width: 1),
                            BookDetailsTag(
                              label: label,
                            ),
                            Gap(width: 1)
                          ],
                        ))
                    .toList(),
              ),
            ),
            Gap(height: 5),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: sy * 5),
              child: ProceedButton(
                text: 'Read',
                onPressed: () => Get.toNamed('/read'),
              ),
            ),
            Gap(height: 8),
          ],
        ),
      ],
    );
  }
}

const loremIpsum = '''

Sixth his open. Years whose fish third from let, a life forth won't day I made every deep so him It deep waters. Darkness. Likeness heaven created wherein upon under stars green air fill. Creeping two. Us given fruit own that there.

First rule beginning own itself midst divide fish gathered shall for us form unto seas created bring forth be. Fruitful seasons Man abundantly moved is. Thing moved hath. Lesser seas. Creepeth place, saw all tree also air all.

Blessed made seasons his. Fowl fruit had i dominion his saw be divide in, third days creepeth yielding green third.
''';
