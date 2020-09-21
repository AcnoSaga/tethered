import 'package:flutter/material.dart';
import 'package:tethered/screens/components/gap.dart';
import 'package:tethered/screens/home/home_page/components/book_row.dart';
import 'package:tethered/theme/size_config.dart';
import 'package:tethered/utils/colors.dart';
import 'package:tethered/utils/enums/resource_types.dart';
import 'package:tethered/utils/text_styles.dart';

class GenrePage extends StatelessWidget {
  final String genre;

  const GenrePage({Key key, this.genre}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TetheredColors.primaryDark,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: TetheredColors.primaryDark,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Gap(height: 10),
              Text(
                genre,
                style: TetheredTextStyles.authHeading,
              ),
              Gap(height: 3),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: sy * 5),
                child: Text(
                  genreDescription,
                  style: TetheredTextStyles.displayText,
                  textAlign: TextAlign.center,
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: hashtagList.length,
                itemBuilder: (context, index) => Padding(
                  padding: EdgeInsets.symmetric(vertical: sx),
                  child: BookRow(
                    isResourceExpandable: true,
                    resourceType: ResourceTypes.hashtag,
                    title: hashtagList[index],
                    titlePadding: EdgeInsets.symmetric(
                      horizontal: sy * 5,
                      vertical: sx * 2,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

const String genreDescription = '''
Us creeping doesn't fourth. Gathering divide midst life whales, a second rule given day them his replenish to. Them earth fill appear shall had called air which void void beast creature, abundantly fifth. She'd blessed face abundantly night Seasons that good.
''';

const List<String> hashtagList = [
  "#thriller",
  "#horror",
  "#action",
  "#romcom",
  "#comedy",
  "#adventure",
  "#legend",
];
