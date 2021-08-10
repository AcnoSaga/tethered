import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:tethered/utils/firebase_utils.dart';
import '../../models/book_details.dart';
import '../../models/entry_item.dart';
import '../../theme/size_config.dart';
import '../../utils/colors.dart';

import 'components/tether_page.dart';

class EntryPage extends StatefulWidget {
  final BookDetails bookDetails;
  final EntryItem entryItem;
  const EntryPage({
    Key key,
    this.bookDetails,
    this.entryItem,
  }) : super(key: key);

  @override
  _EntryPageState createState() => _EntryPageState();
}

class _EntryPageState extends State<EntryPage> {
  ValueNotifier<bool> _isVisible = ValueNotifier(true);
  ScrollController controller;
  ValueNotifier<bool> isLikedNotifier = ValueNotifier(null);

  @override
  void initState() {
    super.initState();
    FirebaseUtils.isLiked(
      widget.bookDetails.doc.reference
          .collection('proposals')
          .doc(widget.entryItem.doc.id),
      FirebaseAuth.instance.currentUser.uid,
    ).then((value) {
      return isLikedNotifier.value = value;
    });
    controller = ScrollController();
    controller.addListener(() {
      // ignore: invalid_use_of_protected_member
      controller.positions.forEach((position) {
        if (position.userScrollDirection == ScrollDirection.reverse) {
          _isVisible.value = false;
        }
        // ignore: invalid_use_of_protected_member
        if (position.userScrollDirection == ScrollDirection.forward) {
          _isVisible.value = true;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: ValueListenableBuilder<bool>(
          valueListenable: _isVisible,
          builder: (context, isVisible, _) {
            return AnimatedContainer(
              color: TetheredColors.primaryDark,
              duration: Duration(milliseconds: 200),
              height: isVisible ? sx * 10 : 0.0,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                height: isVisible ? sx * 10 : 0.0,
                width: sy * 90,
                child: Wrap(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: IconButton(
                        icon: Icon(
                          Icons.chat_bubble_outline,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          //returns tab id which is user tapped
                          Get.toNamed(
                            '/comments',
                            arguments: {
                              "collection": widget.bookDetails.doc.reference
                                  .collection('proposals')
                                  .doc(widget.entryItem.doc.id)
                                  .collection('comments'),
                            },
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
      body: CustomScrollView(
        controller: controller,
        slivers: [
          SliverAppBar(
            actions: [
              ValueListenableBuilder<bool>(
                  valueListenable: isLikedNotifier,
                  builder: (context, isLiked, _) {
                    print(isLiked);
                    return IconButton(
                      icon: Icon(Icons.arrow_circle_up),
                      onPressed: isLiked == null
                          ? null
                          : () async {
                              isLikedNotifier.value =
                                  await FirebaseUtils.changeLikeStatus(
                                widget.bookDetails.doc.reference
                                    .collection('proposals')
                                    .doc(widget.entryItem.doc.id),
                                widget.bookDetails.doc.reference
                                    .collection('proposalIndex')
                                    .doc(widget.entryItem.doc.id),
                                isLiked,
                              );
                            },
                      color: isLiked == true ? Colors.blue : Colors.white,
                    );
                  }),
            ],
            backgroundColor: TetheredColors.primaryDark,
            floating: true,
          ),
          TetherPage(
            doc: widget.bookDetails.doc.reference
                .collection('proposals')
                .doc(widget.entryItem.doc.id),
          ),
        ],
      ),
    );
  }
}
