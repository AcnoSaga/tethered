import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:tethered/injection/injection.dart';
import 'package:tethered/models/comment.dart';
import 'package:tethered/services/firestore_service.dart';

class CommentsList extends StatefulWidget {
  final CollectionReference collectionRef;
  const CommentsList({
    Key key,
    this.collectionRef,
  }) : super(key: key);

  @override
  _CommentsListState createState() => _CommentsListState();
}

class _CommentsListState extends State<CommentsList> {
  PagingController<Comment, Comment> _pagingController =
      PagingController(firstPageKey: null);

  @override
  void initState() {
    super.initState();

    _pagingController.addPageRequestListener((pageKey) {
      _fetchComments(pageKey);
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      child: PagedListView<Comment, Comment>(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate(
          itemBuilder: (context, comment, index) => ListTile(
            title: GestureDetector(
              onTap: () => Get.toNamed('/account', arguments: {
                "uid": comment.userRef.id,
              }),
              child: Text(comment.username),
            ),
            subtitle: Text(comment.content),
            leading: GestureDetector(
              onTap: () => Get.toNamed('/account', arguments: {
                "uid": comment.userRef.id,
              }),
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                  comment.imageUrl,
                ),
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

  Future<void> _fetchComments(Comment lastComment) async {
    try {
      final newComments = await locator<FirestoreService>()
          .getComments(lastComment, widget.collectionRef);

      if (newComments.length != 0) {
        _pagingController.appendPage(newComments, newComments.last);
      } else {
        _pagingController.appendLastPage(newComments);
      }
    } catch (error) {
      print(error);
      _pagingController.error = error;
    }
  }
}
