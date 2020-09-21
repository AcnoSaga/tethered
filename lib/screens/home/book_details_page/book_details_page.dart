import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tethered/screens/components/gap.dart';
import 'package:tethered/screens/components/image_error_widget.dart';
import 'package:tethered/screens/components/proceed_button.dart';
import 'package:tethered/screens/home/book_details_page/components/book_details_info_text.dart';
import 'package:tethered/screens/home/home_page/components/book_row.dart';

import 'package:tethered/theme/size_config.dart';
import 'package:tethered/utils/colors.dart';
import 'package:tethered/utils/enums/resource_types.dart';
import 'package:tethered/utils/text_styles.dart';

import 'components/book_details_tag.dart';

class BookDetailPage extends StatefulWidget {
  final List<String> urls;
  final int startingIndex;

  const BookDetailPage({Key key, this.urls, this.startingIndex})
      : super(key: key);

  @override
  _BookDetailPageState createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  int currentIndex;
  double scrollValue = 0;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.startingIndex;
  }

  @override
  Widget build(BuildContext context) {
    final itemBorderRadius = BorderRadius.circular(10);

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
              // Gap(height: 2),
              CarouselSlider(
                options: CarouselOptions(
                  viewportFraction: 0.66,
                  enableInfiniteScroll: false,
                  aspectRatio: 1,
                  enlargeCenterPage: true,
                  initialPage: widget.startingIndex,
                  onScrolled: (value) {
                    setState(() {
                      scrollValue = (value - currentIndex).abs();
                    });
                  },
                  onPageChanged: (index, reason) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                ),
                items: widget.urls
                    .map((url) => Container(
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
                                placeholder: (context, url) =>
                                    Shimmer.fromColors(
                                        baseColor: Colors.grey[500],
                                        highlightColor: Colors.grey[400],
                                        child: Center(
                                          child: Container(
                                            color: Colors.white,
                                            child: SizedBox.expand(),
                                          ),
                                        )),
                                errorWidget: (context, url, error) =>
                                    ImageErrorWidget(),
                                fit: BoxFit.fill,
                                imageUrl: url,
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              ),
              Gap(height: 5),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: sy * 5),
                child: Opacity(
                  opacity: 1 - (scrollValue * 2),
                  child: Column(
                    children: [
                      Text(
                        // 'Title $currentIndex',
                        // 'Fatal Conclusions (Book 3, the Fatal Trilogy Series)',
                        'Albratoss',
                        style: TetheredTextStyles.bookDetailsHeading,
                        textAlign: TextAlign.center,
                      ),
                      Gap(height: 2),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        alignment: WrapAlignment.center,
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          BookDetailsInfoText(
                            icon: Icons.visibility,
                            text: '21M views',
                          ),
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
                        loremIpsum,
                        style: TetheredTextStyles.descriptionText,
                        textAlign: TextAlign.justify,
                        strutStyle: StrutStyle(height: 1.1),
                        // strutStyle: StrutStyle.disabled,
                      ),
                      Gap(height: 3),
                    ],
                  ),
                ),
              ),
              Opacity(
                opacity: 1 - (scrollValue * 2),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        // shrinkWrap: true,
                        // scrollDirection: Axis.horizontal,
                        children: [
                          Gap(width: 2),
                          BookDetailsTag(label: '#horror'),
                          Gap(width: 2),
                          BookDetailsTag(label: '#horror'),
                          Gap(width: 2),
                          BookDetailsTag(label: '#action'),
                          Gap(width: 2),
                          BookDetailsTag(label: '#thriller'),
                          Gap(width: 2),
                          BookDetailsTag(label: '#romcom'),
                          Gap(width: 2),
                          BookDetailsTag(label: '#suspense'),
                        ],
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
                    Gap(height: 4),
                    BookRow(
                      title: 'More like this',
                      resourceType: ResourceTypes.genre,
                      titlePadding: EdgeInsets.symmetric(
                        horizontal: sy * 5,
                        vertical: sx * 2,
                      ),
                    ),
                    Gap(height: 4),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

const loremIpsum = '''

Sixth his open. Years whose fish third from let, a life forth won't day I made every deep so him It deep waters. Darkness. Likeness heaven created wherein upon under stars green air fill. Creeping two. Us given fruit own that there.

First rule beginning own itself midst divide fish gathered shall for us form unto seas created bring forth be. Fruitful seasons Man abundantly moved is. Thing moved hath. Lesser seas. Creepeth place, saw all tree also air all.

Blessed made seasons his. Fowl fruit had i dominion his saw be divide in, third days creepeth yielding green third.
''';
