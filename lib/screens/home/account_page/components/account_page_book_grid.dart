import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import '../../../../injection/injection.dart';
import '../../../../models/book_cover.dart';
import '../../../components/book_card.dart';
import '../../../../services/firestore_service.dart';
import '../../../../theme/size_config.dart';
import '../../../../utils/enums/tab_item.dart';
import '../../../../utils/inner_routes/home_routes.dart';

class AccountPageBookGrid extends StatefulWidget {
  final String uid;
  final bool isNested;

  AccountPageBookGrid({
    Key key,
    this.uid,
    this.isNested,
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
        firstPageErrorIndicatorBuilder: (context) => Center(
          child: Text(
            'An unexpected error occured.',
            style: TextStyle(color: Colors.white),
          ),
        ),
        noItemsFoundIndicatorBuilder: (context) => Center(
          child: Text(
            'No posts yet.',
            style: TextStyle(color: Colors.white),
          ),
        ),
        itemBuilder: (context, bookCover, index) {
          print(bookCover.workRef);
          return GestureDetector(
            onTap: () {
              if (widget.isNested) {
                Get.toNamed(
                  HomeRoutes.bookDetails,
                  arguments: {
                    "bookCovers": [bookCover],
                    "index": 0,
                  },
                  id: tabItemsToIndex[
                      Provider.of<TabItem>(context, listen: false)],
                );
              } else {
                Get.toNamed(
                  '/book-details',
                  arguments: {
                    "bookCovers": [bookCover],
                    "index": 0,
                  },
                );
              }
            },
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
