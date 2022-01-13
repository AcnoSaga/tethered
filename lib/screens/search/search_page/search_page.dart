import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:tethered/models/published_draft.dart';
import 'package:tethered/models/tethered_user.dart';
import 'package:tethered/screens/components/gap.dart';
import 'package:tethered/screens/search/search_page/components/user_item.dart';
import 'package:tethered/screens/write/write_page/components/published_item.dart';
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
  ValueNotifier<SearchType> searchType =
      ValueNotifier<SearchType>(SearchType.works);

  final Algolia _algoliaApp = AlgoliaApplication.algolia;

  SearchBarController controller = SearchBarController();

  @override
  void initState() {
    super.initState();
    searchType.addListener(() {
      controller.replayLastSearch();
    });
  }

  String searchTypeToIndex() {
    switch (searchType.value) {
      case SearchType.works:
        return 'works';
        break;
      case SearchType.users:
        return 'users';
        break;
      case SearchType.tags:
        return 'tags';
        break;
    }
    throw UnimplementedError();
  }

  Future<List<dynamic>> _operation(String input) async {
    AlgoliaQuery query =
        _algoliaApp.instance.index(searchTypeToIndex()).query(input);
    try {
      AlgoliaQuerySnapshot querySnap = await query.getObjects();
      print('Success');
      List<AlgoliaObjectSnapshot> results = querySnap.hits;

      switch (searchType.value) {
        case SearchType.works:
          List<PublishedDraft> publishedDrafts = [];

          for (AlgoliaObjectSnapshot snapshot in results) {
            publishedDrafts.add(
              PublishedDraft.fromDocument(
                await FirebaseFirestore.instance
                    .doc('works/' + await snapshot.data["id"])
                    .get(),
              ),
            );
            // print(publishedDrafts);
          }

          return publishedDrafts;
          break;
        case SearchType.users:
          List<TetheredUser> users = [];

          for (AlgoliaObjectSnapshot snapshot in results) {
            users.add(await TetheredUser.fromUserId(snapshot.data["id"]));
            // print(publishedDrafts);
          }

          return users;
          break;
        case SearchType.tags:
          List<String> hashtags = [];

          for (AlgoliaObjectSnapshot snapshot in results) {
            hashtags.add(
              snapshot.data["hashtagId"],
            );
            // print(publishedDrafts);
          }

          return hashtags;
          break;
      }
    } on AlgoliaError catch (e) {
      print(e.error);
    }
    throw UnimplementedError();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TetheredColors.primaryDark,
      appBar: AppBar(
        brightness: Brightness.dark,
        elevation: 10,
        backgroundColor: TetheredColors.primaryDark,
        title: Wrap(
          children: [
            ChoiceChip(
              label: Text('Works'),
              selected: SearchType.works == searchType.value,
              onSelected: (bool selected) {
                setState(() {
                  searchType.value = SearchType.works;
                });
              },
              selectedColor: TetheredColors.textFieldBackground,
            ),
            Gap(width: 2),
            ChoiceChip(
              label: Text('Users'),
              selected: SearchType.users == searchType.value,
              onSelected: (bool selected) {
                setState(() {
                  searchType.value = SearchType.users;
                });
              },
              selectedColor: TetheredColors.textFieldBackground,
            ),
            Gap(width: 2),
            ChoiceChip(
              label: Text('Tags'),
              selected: SearchType.tags == searchType.value,
              onSelected: (bool selected) {
                setState(() {
                  searchType.value = SearchType.tags;
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
          child: SearchBar<dynamic>(
            searchBarController: controller,
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
            loader: Center(child: CircularProgressIndicator()),
            shrinkWrap: true,
            onItemFound: (item, index) {
              print('Success');
              if (item == null) {
                return Container();
              }
              switch (searchType.value) {
                case SearchType.works:
                  return PublishedDraftItem(
                    publishedDraft: item,
                  );
                  break;
                case SearchType.users:
                  return UserItem(
                    user: item,
                  );
                  break;
                default:
                  return TagItem(
                    hashtagId: item,
                  );
              }
            },
            onError: (error) {
              return Text(
                error.toString(),
                style: TextStyle(color: Colors.white),
              );
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
