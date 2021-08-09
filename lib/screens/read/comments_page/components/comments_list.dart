import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:tethered/injection/injection.dart';
import 'package:tethered/models/comment.dart';
import 'package:tethered/riverpods/global/user_provider.dart';
import 'package:tethered/services/firestore_service.dart';
import 'package:tethered/utils/colors.dart';
import 'package:tethered/utils/text_styles.dart';

class CommentsList extends StatefulWidget {
  final PagingController<Comment, Comment> pagingController;

  final CollectionReference collectionRef;
  const CommentsList({
    Key key,
    this.collectionRef,
    this.pagingController,
  }) : super(key: key);

  @override
  _CommentsListState createState() => _CommentsListState();
}

class _CommentsListState extends State<CommentsList> {
  @override
  void initState() {
    super.initState();
    widget.pagingController.addPageRequestListener((pageKey) {
      _fetchComments(pageKey);
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      child: PagedListView<Comment, Comment>(
        pagingController: widget.pagingController,
        builderDelegate: PagedChildBuilderDelegate(
          itemBuilder: (context, comment, index) => ListTile(
            title: GestureDetector(
              onTap: () => Get.toNamed('/account', arguments: {
                "uid": comment.userRef.id,
              }),
              child: Text(comment.username,
                  style: TextStyle(color: Colors.black54)),
            ),
            subtitle:
                Text(comment.content, style: TextStyle(color: Colors.black)),
            trailing: () {
              final user = context.read(userProvider);
              return comment.userRef.id == user.uid
                  ? IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _deleteDialog(comment),
                    )
                  : null;
            }(),
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
        () => widget.pagingController.refresh(),
      ),
    );
  }

  Future<void> _fetchComments(Comment lastComment) async {
    try {
      final newComments = await locator<FirestoreService>()
          .getComments(lastComment, widget.collectionRef);

      if (newComments.length != 0) {
        widget.pagingController.appendPage(newComments, newComments.last);
      } else {
        widget.pagingController.appendLastPage(newComments);
      }
    } catch (error) {
      print(error);
      widget.pagingController.error = error;
    }
  }

  Future _deleteDialog(Comment comment) async {
    await Get.dialog(
      AlertDialog(
        title: Text('Are you sure you want to delete this comment?'),
        actions: [
          TextButton.icon(
            onPressed: () async {
              await widget.collectionRef.doc(comment.doc.id).delete();
              widget.pagingController.refresh();
              Get.back();
            },
            icon: Icon(
              Icons.check_circle,
              color: TetheredColors.acceptNegativeColor,
            ),
            label: Text(
              'Yes',
              style: TetheredTextStyles.acceptNegativeText,
            ),
          ),
          TextButton.icon(
            onPressed: Get.back,
            icon: Icon(
              Icons.cancel,
              color: TetheredColors.rejectNegativeColor,
            ),
            label: Text(
              'No',
              style: TetheredTextStyles.rejectNegativeText,
            ),
          ),
        ],
      ),
    );
  }
}
