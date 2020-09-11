import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tethered/screens/components/book_card.dart';
import 'package:tethered/screens/components/gap.dart';
import 'package:tethered/theme/size_config.dart';
import 'package:tethered/utils/colors.dart';

import 'package:tethered/utils/text_styles.dart';

class HashtagPage extends StatefulWidget {
  final String hashtag;

  const HashtagPage({Key key, this.hashtag}) : super(key: key);

  @override
  _HashtagPageState createState() => _HashtagPageState();
}

class _HashtagPageState extends State<HashtagPage> {
  int bookCount = 20;
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
            title: Text(
              'Tethered',
              style: TetheredTextStyles.homeAppBarHeading,
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: sy * 5, vertical: sx * 7),
            sliver: SliverToBoxAdapter(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(widget.hashtag,
                      style: TetheredTextStyles.authHeading,
                      textAlign: TextAlign.center),
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
                  Random rnd;
                  int min = 1050;
                  int max = 1080;
                  rnd = new Random();
                  int value = min + rnd.nextInt(max - min);
                  final String url = 'https://picsum.photos/id/$value/400/600';
                  return BookCard(url: url);
                },
                childCount: bookCount,
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

const String dummyText =
    '''Life yielding bring so third night of seasons face herb abundantly void doesn't said evening signs. Darkness above be greater It that seed, isn't fruit void also bearing light third image thing give. Divided can't.

Forth above to first morning all greater also, open. Signs female without gathering let blessed heaven light there second greater created make. Morning, whose brought i seasons, sixth own replenish firmament.''';
