import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:tethered/models/book_details.dart';
import 'package:tethered/models/entry_item.dart';
import 'package:tethered/theme/size_config.dart';
import 'package:tethered/utils/colors.dart';

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

  @override
  void initState() {
    super.initState();
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
                      child: FloatingNavbar(
                        unselectedItemColor: Colors.white,
                        selectedItemColor: Colors.white,
                        selectedBackgroundColor: Colors.transparent,
                        backgroundColor: Colors.transparent,
                        onTap: (int val) {
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
                        currentIndex: 0,
                        items: [
                          FloatingNavbarItem(icon: Icons.home, title: ''),
                          FloatingNavbarItem(icon: Icons.menu, title: ''),
                          FloatingNavbarItem(
                              icon: Icons.chat_bubble_outline, title: ''),
                          FloatingNavbarItem(icon: Icons.share, title: ''),
                        ],
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
            actions: [],
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
