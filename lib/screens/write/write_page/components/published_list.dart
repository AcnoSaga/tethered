import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../../../injection/injection.dart';
import '../../../../models/published_draft.dart';
import 'published_item.dart';
import '../../../../services/firestore_service.dart';
import '../../../../theme/size_config.dart';

class PublishedList extends StatefulWidget {
  PublishedList({Key key}) : super(key: key);

  @override
  _PublishedListState createState() => _PublishedListState();
}

class _PublishedListState extends State<PublishedList> {
  PagingController<PublishedDraft, PublishedDraft> _pagingController =
      PagingController(firstPageKey: null);

  @override
  void initState() {
    super.initState();

    _pagingController.addPageRequestListener((pageKey) {
      _fetchPublishedDrafts(pageKey);
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      child: PagedListView(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate(
          firstPageErrorIndicatorBuilder: (context) =>
              Center(child: Text(_pagingController.error.toString())),
          itemBuilder: (context, publishedDraft, index) => Padding(
            padding: EdgeInsets.symmetric(
              horizontal: sx,
              vertical: sx / 1.5,
            ),
            child: PublishedDraftItem(
              publishedDraft: publishedDraft,
            ),
          ),
        ),
      ),
      onRefresh: () => Future.sync(
        () => _pagingController.refresh(),
      ),
    );
  }

  Future<void> _fetchPublishedDrafts(PublishedDraft lastPublishedDraft) async {
    try {
      final newPublishedDrafts = await locator<FirestoreService>()
          .getPublishedDrafts(lastPublishedDraft);

      if (newPublishedDrafts.length != 0) {
        _pagingController.appendPage(
            newPublishedDrafts, newPublishedDrafts.last);
      } else {
        _pagingController.appendLastPage(newPublishedDrafts);
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
