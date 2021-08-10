import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:tethered/models/book.dart';
import 'package:tethered/screens/components/gap.dart';
import 'package:tethered/screens/search/search_page/components/user_item.dart';
import 'package:tethered/screens/write/write_page/components/draft_item.dart';
import 'package:tethered/theme/size_config.dart';
import 'package:tethered/utils/colors.dart';
import 'package:tethered/utils/text_styles.dart';
import 'package:algolia/algolia.dart';
import 'components/algoliaapp.dart';
import 'components/tag_item.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  SearchType searchType = SearchType.works;

  final Algolia _algoliaApp = AlgoliaApplication.algolia;

  Future<List<Book>> _operation(String input) async {
    AlgoliaQuery query =
        _algoliaApp.instance.index("practice_algolia").query(input);
    AlgoliaQuerySnapshot querySnap = await query.getObjects();
    List<AlgoliaObjectSnapshot> results = querySnap.hits;
    return results.map((snapshot) => Book.fromSnapshot(snapshot)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TetheredColors.primaryDark,
      appBar: AppBar(
        elevation: 10,
        backgroundColor: TetheredColors.primaryDark,
        title: Wrap(
          children: [
            ChoiceChip(
              label: Text('Works'),
              selected: SearchType.works == searchType,
              onSelected: (bool selected) {
                setState(() {
                  searchType = SearchType.works;
                });
              },
              selectedColor: TetheredColors.textFieldBackground,
            ),
            Gap(width: 2),
            ChoiceChip(
              label: Text('Users'),
              selected: SearchType.users == searchType,
              onSelected: (bool selected) {
                setState(() {
                  searchType = SearchType.users;
                });
              },
              selectedColor: TetheredColors.textFieldBackground,
            ),
            Gap(width: 2),
            ChoiceChip(
              label: Text('Tags'),
              selected: SearchType.tags == searchType,
              onSelected: (bool selected) {
                setState(() {
                  searchType = SearchType.tags;
                });
              },
              selectedColor: TetheredColors.textFieldBackground,
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: sy * 3),
          child: SearchBar(
            mainAxisSpacing: sx * 2,
            textStyle: TetheredTextStyles.descriptionText,
            icon: Icon(
              Icons.search,
              color: TetheredTextStyles.descriptionText.color,
            ),
            cancellationWidget: Text(
              'Cancel',
              style: TetheredTextStyles.descriptionText,
            ),
            loader: CircularProgressIndicator(),
            shrinkWrap: true,
            onItemFound: (item, index) {
              switch (searchType) {
                case SearchType.works:
                  return DraftItem(
                    published: true,
                    book: item,
                  );
                  break;
                case SearchType.users:
                  return UserItem();
                  break;
                default:
                  return TagItem();
              }
            },
            onSearch: (String text) {
              return _operation(text); //working here
            },
          ),
        ),
      ),
    );
  }
}

enum SearchType {
  works,
  users,
  tags,
}
