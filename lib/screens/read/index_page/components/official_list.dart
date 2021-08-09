import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:tethered/injection/injection.dart';
import 'package:tethered/models/book_details.dart';
import 'package:tethered/models/index_item.dart';
import 'package:tethered/services/firestore_service.dart';
import 'package:tethered/theme/size_config.dart';

import 'index_item_card.dart';

class OfficialList extends StatefulWidget {
  final BookDetails bookDetails;
  final PageController pageController;
  const OfficialList({
    Key key,
    this.bookDetails,
    this.pageController,
  }) : super(key: key);

  @override
  _OfficialListState createState() => _OfficialListState();
}

class _OfficialListState extends State<OfficialList> {
  PagingController<IndexItem, IndexItem> _pagingController =
      PagingController(firstPageKey: null);

  @override
  void initState() {
    super.initState();

    _pagingController.addPageRequestListener((pageKey) {
      _fetchIndexItems(pageKey);
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      child: PagedListView(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<IndexItem>(
          itemBuilder: (context, item, index) => Padding(
            padding: EdgeInsets.symmetric(
              horizontal: sx,
              vertical: sx / 1.5,
            ),
            child: GestureDetector(
              onTap: () {
                widget.pageController.jumpToPage(index);
                Get.back();
              },
              child: IndexItemCard(
                indexItem: item,
              ),
            ),
          ),
        ),
      ),
      onRefresh: () => Future.sync(
        () => _pagingController.refresh(),
      ),
    );
  }

  Future<void> _fetchIndexItems(IndexItem lastIndexItem) async {
    try {
      final newIndexItems = await locator<FirestoreService>()
          .getIndexItems(lastIndexItem, widget.bookDetails);
      if (newIndexItems.length != 0) {
        _pagingController.appendPage(newIndexItems, newIndexItems.last);
      } else {
        _pagingController.appendLastPage(newIndexItems);
      }
    } catch (error) {
      print(error);
      _pagingController.error = error;
    }
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
