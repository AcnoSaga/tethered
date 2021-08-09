import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tethered/screens/components/gap.dart';
import 'package:tethered/theme/size_config.dart';
import 'package:tethered/utils/colors.dart';
import 'package:tethered/utils/text_styles.dart';

import 'components/comments_list.dart';

class CommentsPage extends StatefulWidget {
  final CollectionReference collectionReference = Get.arguments["collection"];
  CommentsPage({Key key}) : super(key: key);

  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  final TextEditingController controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
            Row(
              children: [
                Flexible(
                  child: TextField(
                    controller: controller,
                    onSubmitted: (s) => print(s),
                  ),
                ),
                TextButton(
                  onPressed: () => setState(() {
                    controller.clear();
                  }),
                  child: Text('POST'),
                ),
              ],
            ),
            Gap(height: 2),
            Expanded(
              child: CommentsList(
                collectionRef: widget.collectionReference,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
