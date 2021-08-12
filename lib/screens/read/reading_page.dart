import 'package:firebase_auth/firebase_auth.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:tethered/models/book_details.dart';
import 'package:tethered/theme/size_config.dart';
import 'package:tethered/utils/colors.dart';
import 'package:tethered/utils/firebase_utils.dart';

import 'components/tether_page.dart';

class ReadingPage extends StatefulWidget {
  final BookDetails bookDetails = Get.arguments["bookDetails"] as BookDetails;

  @override
  _ReadingPageState createState() => _ReadingPageState();
}

class _ReadingPageState extends State<ReadingPage> {
  PageController _pageController;
  RxMap<int, ScrollController> _mapScrollControllers;
  ScrollController _activeScrollController;
  Drag _drag;
  ValueNotifier<bool> _isVisible = ValueNotifier(true);

  Null Function() Function(ScrollController) _changeBarVisibility;

  int numberOfPages;
  int currentIndex = 0;

  ValueNotifier<bool> isLikedNotifier = ValueNotifier(null);

  @override
  void initState() {
    super.initState();
    FirebaseUtils.isLiked(
      widget.bookDetails.doc.reference
          .collection('tethers')
          .doc(currentIndex.toString()),
      FirebaseAuth.instance.currentUser.uid,
    ).then((value) {
      return isLikedNotifier.value = value;
    });
    numberOfPages = widget.bookDetails.numberOfTethers;
    _pageController = PageController(
      initialPage: 0,
      viewportFraction: 1,
      keepPage: true,
    );
    if (numberOfPages <= 3) {
      _mapScrollControllers = RxMap(Map<int, ScrollController>.fromIterables(
        List.generate(numberOfPages, (index) => index),
        List<ScrollController>.filled(
          numberOfPages,
          ScrollController(),
          growable: true,
        ),
      ));
    } else {
      _mapScrollControllers = RxMap(Map<int, ScrollController>.fromIterables(
        [0, 1, 2],
        List<ScrollController>.filled(
          3,
          ScrollController(),
          growable: true,
        ),
      ));
    }

    _mapScrollControllers.forEach((index, controller) {
      if (_changeBarVisibility == null) {
        _changeBarVisibility = (ScrollController scrollController) => () {
              // ignore: invalid_use_of_protected_member
              scrollController.positions.forEach((position) {
                if (position.userScrollDirection == ScrollDirection.reverse) {
                  _isVisible.value = false;
                }
                // ignore: invalid_use_of_protected_member
                if (position.userScrollDirection == ScrollDirection.forward) {
                  _isVisible.value = true;
                }
              });
            };
      }
      controller.addListener(_changeBarVisibility(controller));
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _mapScrollControllers.forEach((index, controller) {
      controller.removeListener(_changeBarVisibility(controller));
      controller.dispose();
    });
    super.dispose();
  }

  void _handleDragStart(DragStartDetails details) {
    if (_mapScrollControllers[currentIndex].hasClients &&
        _mapScrollControllers[currentIndex].position.context.storageContext !=
            null) {
      final RenderBox renderBox = _mapScrollControllers[currentIndex]
          .position
          .context
          .storageContext
          .findRenderObject();
      if (renderBox.paintBounds
          .shift(renderBox.localToGlobal(Offset.zero))
          .contains(details.globalPosition)) {
        _activeScrollController = _mapScrollControllers[currentIndex];
        _drag = _activeScrollController.position.drag(details, _disposeDrag);
        return;
      }
    }
    _activeScrollController = _pageController;
    _drag = _pageController.position.drag(details, _disposeDrag);
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    var scrollDirection = _activeScrollController.position.userScrollDirection;

    if (_activeScrollController == _mapScrollControllers[currentIndex] &&
        ((scrollDirection == ScrollDirection.reverse) &&
                _activeScrollController.offset.roundToDouble() >=
                    _activeScrollController.position.maxScrollExtent
                        .roundToDouble() ||
            (scrollDirection == ScrollDirection.forward) &&
                _activeScrollController.offset <= 0)) {
      _activeScrollController = _pageController;
      _drag?.cancel();
      _drag = _pageController.position.drag(
        DragStartDetails(
          globalPosition: details.globalPosition,
          localPosition: details.localPosition,
        ),
        _disposeDrag,
      );

      if (_activeScrollController == _mapScrollControllers[currentIndex]
          // && (details.primaryDelta < 0)
          &&
          (_activeScrollController.position.pixels.roundToDouble() >=
                  _activeScrollController.position.maxScrollExtent
                      .roundToDouble() ||
              _activeScrollController.position.pixels < 0)) {
        _activeScrollController = _pageController;
        _drag?.cancel();
        _drag = _pageController.position.drag(
            DragStartDetails(
                globalPosition: details.globalPosition,
                localPosition: details.localPosition),
            _disposeDrag);
      }
      _drag?.update(details);
    }
    _drag?.update(details);
  }

  void _handleDragEnd(DragEndDetails details) {
    _drag?.end(details);
  }

  void _handleDragCancel() {
    _drag?.cancel();
  }

  void _disposeDrag() {
    _drag = null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _isVisible.value = !_isVisible.value;
        print('Tap');
      },
      child: Scaffold(
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
                            if (val == 0)
                              Get.toNamed(
                                '/index',
                                arguments: {
                                  "bookDetails": widget.bookDetails,
                                  "pageController": _pageController,
                                },
                              );
                            else
                              Get.toNamed(
                                '/comments',
                                arguments: {
                                  "collection": widget.bookDetails.doc.reference
                                      .collection('tethers')
                                      .doc(currentIndex.toString())
                                      .collection('comments'),
                                },
                              );
                          },
                          currentIndex: 0,
                          items: [
                            FloatingNavbarItem(icon: Icons.menu, title: ''),
                            FloatingNavbarItem(
                                icon: Icons.chat_bubble_outline, title: ''),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            }),
        // extendBody: true,

        // bottomNavigationBar: Container(),
        // backgroundColor: TetheredColors.primaryDark,
        body: RawGestureDetector(
          gestures: <Type, GestureRecognizerFactory>{
            VerticalDragGestureRecognizer: GestureRecognizerFactoryWithHandlers<
                    VerticalDragGestureRecognizer>(
                () => VerticalDragGestureRecognizer(),
                (VerticalDragGestureRecognizer instance) {
              instance
                ..onStart = _handleDragStart
                ..onUpdate = _handleDragUpdate
                ..onEnd = _handleDragEnd
                ..onCancel = _handleDragCancel;
            })
          },
          // behavior: HitTestBehavior.opaque,
          child: PageView.builder(
            physics: NeverScrollableScrollPhysics(),
            dragStartBehavior: DragStartBehavior.down,
            controller: _pageController,
            scrollDirection: Axis.vertical,
            itemCount: numberOfPages,
            onPageChanged: (index) {
              setState(() {
                // if (currentIndex > index) {
                //   final newController = ScrollController();
                //   // newController.addListener(_changeBarVisibility);
                //   _listScrollControllers[index] = newController;
                // }

                // if (_listScrollControllers.length < numberOfPages &&
                //     currentIndex < index) {
                //   final newController = ScrollController();
                //   newController
                //       .addListener(_changeBarVisibility(newController));
                //   _listScrollControllers.add(newController);
                // }
                currentIndex = index;
                // _activeScrollController = _listScrollControllers[index];
              });
            },
            itemBuilder: (context, index) => CustomScrollView(
              physics: NeverScrollableScrollPhysics(),
              controller: () {
                // print(textController.document.toDelta().toJson());
                final newController = ScrollController();
                newController.addListener(_changeBarVisibility(newController));

                _mapScrollControllers[index] = newController;
                return newController;
              }(),
              slivers: [
                SliverAppBar(
                  brightness: Brightness.dark,
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
                                          .collection('tethers')
                                          .doc(currentIndex.toString()),
                                      widget.bookDetails.doc.reference
                                          .collection('index')
                                          .doc(currentIndex.toString()),
                                      isLiked,
                                    );
                                  },
                            color: isLiked == true ? Colors.blue : Colors.white,
                          );
                        }),
                    IconButton(
                      icon: Icon(Icons.account_circle),
                      onPressed: () => Get.toNamed('/account', arguments: {
                        "uid": widget.bookDetails.creatorId,
                      }),
                    ),
                  ],
                  backgroundColor: TetheredColors.primaryDark,
                  floating: true,
                ),
                TetherPage(
                  doc: widget.bookDetails.doc.reference
                      .collection('tethers')
                      .doc(index.toString()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget _loadingUi() => Center(
  //       child: GestureDetector(
  //         onTap: Get.back,
  //         child: SpinKitWave(
  //           color: TetheredColors.primaryBlue,
  //         ),
  //       ),
  //     );
}
