import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../../../injection/injection.dart';
import '../../../../models/draft.dart';
import 'draft_item.dart';
import '../../../../services/firestore_service.dart';
import '../../../../theme/size_config.dart';

class DraftList extends StatefulWidget {
  DraftList({Key key}) : super(key: key);

  @override
  _DraftListState createState() => _DraftListState();
}

class _DraftListState extends State<DraftList> {
  PagingController<Draft, Draft> _pagingController =
      PagingController(firstPageKey: null);

  @override
  void initState() {
    super.initState();

    _pagingController.addPageRequestListener((pageKey) {
      _fetchDrafts(pageKey);
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      child: PagedListView(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate(
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
          itemBuilder: (context, draft, index) => Padding(
            padding: EdgeInsets.symmetric(
              horizontal: sx,
              vertical: sx / 1.5,
            ),
            child: DraftItem(
                draft: draft,
                onDelete: () {
                  _pagingController.refresh();
                }),
          ),
        ),
      ),
      onRefresh: () => Future.sync(
        () => _pagingController.refresh(),
      ),
    );
  }

  Future<void> _fetchDrafts(Draft lastDraft) async {
    try {
      final newDrafts = await locator<FirestoreService>().getDrafts(lastDraft);

      if (newDrafts.length != 0) {
        _pagingController.appendPage(newDrafts, newDrafts.last);
      } else {
        _pagingController.appendLastPage(newDrafts);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  void dispose() {
    // 4
    _pagingController.dispose();
    super.dispose();
  }
}
