import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:provider/provider.dart' as FlutterBase;
import 'package:shimmer/shimmer.dart';
import 'package:tethered/utils/enums/tab_item.dart';
import 'package:tethered/utils/inner_routes/home_routes.dart';
import '../../../models/book_cover.dart';
import '../../../models/book_details.dart';
import '../../../riverpods/home/book_detail/book_carousel_index_provider.dart';
import '../../../riverpods/home/book_detail/book_info_provider.dart';
import '../../components/gap.dart';
import '../../components/image_error_widget.dart';
import '../../components/proceed_button.dart';

import '../../../theme/size_config.dart';
import '../../../utils/colors.dart';
import '../../../utils/text_styles.dart';

import '../../components/widgets/book_details_tag.dart';

class BookDetailsPage extends HookWidget {
  final List<BookCover> bookCoverList;
  final int index;

  const BookDetailsPage({
    this.bookCoverList,
    this.index,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int startingIndex = index ?? Get.arguments["index"] as int;
    final List<BookCover> bookCovers =
        bookCoverList ?? Get.arguments["bookCovers"] as List<BookCover>;
    print('--------------------------------');
    print(bookCovers);
    print(startingIndex);
    print('--------------------------------');

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
        brightness: Brightness.dark,
        elevation: 0,
        backgroundColor: TetheredColors.primaryDark,
      ),
      body: SingleChildScrollView(
        child: GestureDetector(
          child: Column(
            children: [
              _bookCarousel(
                itemBorderRadius,
                currentIndex,
                startingIndex,
                bookCovers,
              ),
              Gap(height: 5),
              () {
                if (bookDetailsState is BookDetailsInitial) {
                  return Container();
                } else if (bookDetailsState is BookDetailsLoading) {
                  return CircularProgressIndicator();
                } else if (bookDetailsState is BookDetailsError) {
                  return Center(
                    child: Text(
                      "An unexpected error occured..",
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                } else if (bookDetailsState is BookDetailsLoaded) {
                  return _bookInfo(bookDetailsState.bookDetails, context);
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
    int startingIndex,
    List<BookCover> bookCovers,
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

  Widget _bookInfo(BookDetails details, BuildContext context) {
    final BannerAd adBanner = BannerAd(
      adUnitId: 'ca-app-pub-7031715585886499/6085808574',
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(),
    );
    final loadBanner = adBanner.load();
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
              GestureDetector(
                onTap: () => Get.toNamed(HomeRoutes.accountPage,
                    arguments: {
                      "uid": details.creatorId,
                    },
                    id: tabItemsToIndex[FlutterBase.Provider.of<TabItem>(
                        context,
                        listen: false)]),
                child: Icon(
                  Icons.account_circle,
                  color: Colors.white,
                ),
              ),
              Gap(height: 2),
              TextButton(
                child: Text(
                  'ID: ' + details.doc.id,
                  style: TetheredTextStyles.descriptionText,
                ),
                onPressed: () {
                  Clipboard.setData(new ClipboardData(text: details.doc.id))
                      .then((_) {
                    Get.snackbar(
                      'ID copied to clipboard',
                      'You can use it to search for this work.',
                      colorText: Colors.white,
                    );
                  });
                },
              ),
              Gap(height: 2),
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
                              isNested: index != null,
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
                onPressed: () => Get.toNamed(
                  '/read',
                  arguments: {"bookDetails": details},
                ),
              ),
            ),
            Gap(height: 8),
            FutureBuilder(
              future: loadBanner,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done)
                  return Container(height: 50, child: AdWidget(ad: adBanner));
                return Container();
              },
            ),
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
