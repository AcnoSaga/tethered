import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:tethered/injection/injection.dart';
import 'package:tethered/models/book_cover.dart';
import 'package:tethered/screens/components/book_card.dart';
import 'package:tethered/services/firestore_service.dart';
import 'package:tethered/theme/size_config.dart';
import 'package:tethered/utils/enums/tab_item.dart';
import 'package:tethered/utils/inner_routes/home_routes.dart';

class AccountPageBookGrid extends StatefulWidget {
  final String uid;

  AccountPageBookGrid({
    Key key,
    this.uid,
  }) : super(key: key);

  @override
  _AccountPageBookGridState createState() => _AccountPageBookGridState();
}

class _AccountPageBookGridState extends State<AccountPageBookGrid> {
  final PagingController<DocumentSnapshot, BookCover> _pagingController =
      PagingController(firstPageKey: null);

  @override
  void initState() {
    super.initState();

    _pagingController.addPageRequestListener((pageKey) {
      _fetchBookCovers(pageKey);
    });
  }

  @override
  Widget build(BuildContext context) {
    return PagedSliverGrid(
      pagingController: _pagingController,
      builderDelegate: PagedChildBuilderDelegate<BookCover>(
        itemBuilder: (context, bookCover, index) {
          print(bookCover.workRef);
          return GestureDetector(
            onTap: () => Get.toNamed(
              HomeRoutes.bookDetails,
              arguments: {
                "bookCovers": [bookCover],
                "index": index,
              },
              id: tabItemsToIndex[Provider.of<TabItem>(context, listen: false)],
            ),
            child: BookCard(
              key: UniqueKey(),
              bookCover: bookCover,
            ),
          );
        },
      ),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: sy * 60,
        mainAxisSpacing: sx * 5,
        crossAxisSpacing: sy * 10,
        childAspectRatio: 0.7,
      ),
    );
  }

  Future<void> _fetchBookCovers(DocumentSnapshot lastBookCover) async {
    try {
      final newSnapshots = await locator<FirestoreService>()
          .getBookCovers(widget.uid, lastBookCover);

      final newBookCovers =
          newSnapshots.map((doc) => BookCover.fromMap(doc.data())).toList();

      if (newBookCovers.length != 0) {
        _pagingController.appendPage(newBookCovers, newSnapshots.last);
      } else {
        _pagingController.appendLastPage(newBookCovers);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
