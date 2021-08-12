import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../../models/comment.dart';
import '../../../models/tethered_user.dart';
import '../../../riverpods/global/user_provider.dart';
import '../../components/gap.dart';
import '../../components/validators/text_validators.dart';
import '../../../theme/size_config.dart';
import '../../../utils/colors.dart';
import '../../../utils/text_styles.dart';

import 'components/comments_list.dart';

class CommentsPage extends StatefulWidget {
  final CollectionReference collectionReference = Get.arguments["collection"];
  CommentsPage({Key key}) : super(key: key);

  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  final TextEditingController controller = new TextEditingController();
  final PagingController<Comment, Comment> _pagingController =
      PagingController(firstPageKey: null);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        title: Text(
          'Comments',
          style: TetheredTextStyles.secondaryAppBarHeading,
        ),
        centerTitle: true,
        backgroundColor: TetheredColors.textFieldBackground,
      ),
      body: Padding(
        padding: EdgeInsets.all(sy * 5),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Row(
                children: [
                  Flexible(
                    child: TextFormField(
                      controller: controller,
                      validator: TextValidators.comment,
                      maxLines: 4,
                      minLines: 1,
                      maxLength: 1000,
                    ),
                  ),
                  TextButton(
                    onPressed: () => setState(() {
                      if (!_formKey.currentState.validate()) return;
                      _postComment(controller.text, context.read(userProvider));
                      controller.clear();
                    }),
                    child: Text('POST'),
                  ),
                ],
              ),
            ),
            Gap(height: 2),
            Expanded(
              child: CommentsList(
                collectionRef: widget.collectionReference,
                pagingController: _pagingController,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _postComment(String text, TetheredUser user) async {
    final docRef = await widget.collectionReference
        .add(Comment.fromStringAndUser(text, user).toMap());
    if (!docRef.isBlank) {
      _pagingController.refresh();
    }
  }
}
