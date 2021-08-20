import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../../../injection/injection.dart';
import '../../../../models/book_details.dart';
import '../../../../models/entry_item.dart';
import 'entry_item_card.dart';
import '../../../../services/firestore_service.dart';
import '../../../../theme/size_config.dart';

import '../../entry_page.dart';

class EntriesList extends StatefulWidget {
  final BookDetails bookDetails;
  const EntriesList({
    Key key,
    this.bookDetails,
  }) : super(key: key);

  @override
  _EntriesListState createState() => _EntriesListState();
}

class _EntriesListState extends State<EntriesList> {
  PagingController<EntryItem, EntryItem> _pagingController =
      PagingController(firstPageKey: null);

  @override
  void initState() {
    super.initState();

    _pagingController.addPageRequestListener((pageKey) {
      _fetchEntryItems(pageKey);
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      child: PagedListView(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<EntryItem>(
          firstPageErrorIndicatorBuilder: (context) => Center(
            child: Text(
              'An unexpected error occured.',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          noItemsFoundIndicatorBuilder: (context) => Center(
            child: Text(
              'Seems like this list is empty',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          itemBuilder: (context, item, index) => Padding(
            padding: EdgeInsets.symmetric(
              horizontal: sx,
              vertical: sx / 1.5,
            ),
            child: GestureDetector(
              onTap: () => Get.to(() => EntryPage(
                    bookDetails: widget.bookDetails,
                    entryItem: item,
                  )),
              child: EntryItemCard(
                entryItem: item,
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

  Future<void> _fetchEntryItems(EntryItem lastEntryItem) async {
    try {
      final newEntryItems = await locator<FirestoreService>()
          .getEntryItems(lastEntryItem, widget.bookDetails);
      if (newEntryItems.length != 0) {
        _pagingController.appendPage(newEntryItems, newEntryItems.last);
      } else {
        _pagingController.appendLastPage(newEntryItems);
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
