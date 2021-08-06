import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:tethered/injection/injection.dart';
import 'package:tethered/models/draft.dart';
import 'package:tethered/screens/write/write_page/components/draft_item.dart';
import 'package:tethered/services/firestore_service.dart';
import 'package:tethered/theme/size_config.dart';

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
          itemBuilder: (context, draft, index) => Padding(
            padding: EdgeInsets.symmetric(
              horizontal: sx,
              vertical: sx / 1.5,
            ),
            child: DraftItem(
              draft: draft,
              published: false,
            ),
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
