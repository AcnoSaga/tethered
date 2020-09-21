import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:tethered/screens/components/gap.dart';
import 'package:tethered/screens/home/book_details_page/components/book_details_info_text.dart';
import 'package:tethered/theme/size_config.dart';
import 'package:tethered/utils/colors.dart';
import 'package:tethered/utils/text_styles.dart';
import 'package:zefyr/zefyr.dart';

class ReadingPage extends StatefulWidget {
  @override
  _ReadingPageState createState() => _ReadingPageState();
}

class _ReadingPageState extends State<ReadingPage> {
  PageController _pageController;
  List<ScrollController> _listScrollControllers;
  ScrollController _activeScrollController;
  Drag _drag;
  ValueNotifier<bool> _isVisible = ValueNotifier(true);

  Function _changeBarVisibility;

  int numberOfPages = 15;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    if (numberOfPages <= 3) {
      _listScrollControllers = List.filled(
        numberOfPages,
        ScrollController(),
        growable: true,
      );
    } else {
      _listScrollControllers = List.filled(
        3,
        ScrollController(),
        growable: true,
      );
    }

    _listScrollControllers.forEach((controller) {
      if (_changeBarVisibility == null) {
        _changeBarVisibility = () {
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
        };
      }
      controller.addListener(_changeBarVisibility);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _listScrollControllers.forEach((controller) {
      controller.removeListener(_changeBarVisibility);
      controller.dispose();
    });
    super.dispose();
  }

  void _handleDragStart(DragStartDetails details) {
    if (_listScrollControllers[currentIndex].hasClients &&
        _listScrollControllers[currentIndex].position.context.storageContext !=
            null) {
      final RenderBox renderBox = _listScrollControllers[currentIndex]
          .position
          .context
          .storageContext
          .findRenderObject();
      if (renderBox.paintBounds
          .shift(renderBox.localToGlobal(Offset.zero))
          .contains(details.globalPosition)) {
        _activeScrollController = _listScrollControllers[currentIndex];
        _drag = _activeScrollController.position.drag(details, _disposeDrag);
        return;
      }
    }
    _activeScrollController = _pageController;
    _drag = _pageController.position.drag(details, _disposeDrag);
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    var scrollDirection = _activeScrollController.position.userScrollDirection;

    if (_activeScrollController == _listScrollControllers[currentIndex] &&
        ((scrollDirection == ScrollDirection.reverse) &&
                _activeScrollController.offset.roundToDouble() >=
                    _activeScrollController.position.maxScrollExtent
                        .roundToDouble() ||
            (scrollDirection == ScrollDirection.forward) &&
                _activeScrollController.offset < 0)) {
      _activeScrollController = _pageController;
      _drag?.cancel();
      _drag = _pageController.position.drag(
        DragStartDetails(
          globalPosition: details.globalPosition,
          localPosition: details.localPosition,
        ),
        _disposeDrag,
      );
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
                          _pageController.nextPage(
                              duration: Duration(seconds: 1),
                              curve: Curves.easeOutSine);
                        },
                        currentIndex: 0,
                        items: [
                          FloatingNavbarItem(icon: Icons.home, title: 'Home'),
                          FloatingNavbarItem(
                              icon: Icons.explore, title: 'Explore'),
                          FloatingNavbarItem(
                              icon: Icons.chat_bubble_outline, title: 'Chats'),
                          FloatingNavbarItem(
                              icon: Icons.settings, title: 'Settings'),
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
      body: ZefyrTheme(
        data: ZefyrThemeData(
          attributeTheme: AttributeTheme(
            bold: TextStyle(
              color: Colors.deepOrange,
            ),
            heading1: LineTheme(
              textStyle: TextStyle(color: Colors.blue),
              padding: EdgeInsets.zero,
            ),
          ),
        ),
        child: RawGestureDetector(
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
          behavior: HitTestBehavior.opaque,
          child: PageView.builder(
              physics: NeverScrollableScrollPhysics(),
              dragStartBehavior: DragStartBehavior.down,
              controller: _pageController,
              scrollDirection: Axis.vertical,
              itemCount: numberOfPages,
              onPageChanged: (index) {
                setState(() {
                  // if (currentIndex != index) {
                  //   _listScrollControllers[index] = ScrollController()
                  //     ..addListener(_changeBarVisibility);
                  // }

                  if (_listScrollControllers.length < numberOfPages &&
                      currentIndex < index) {
                    _listScrollControllers.add(
                      ScrollController()..addListener(_changeBarVisibility),
                    );
                  }
                  currentIndex = index;
                  // _activeScrollController = _listScrollControllers[index];
                });
              },
              itemBuilder: (context, index) => CustomScrollView(
                    physics: NeverScrollableScrollPhysics(),
                    controller: _listScrollControllers[index],
                    slivers: [
                      SliverAppBar(
                        actions: [],
                        backgroundColor: TetheredColors.primaryDark,
                        floating: true,
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: sy * 4),
                          child: Column(
                            children: [
                              Gap(height: 5),
                              Text(
                                'The Story of How London Got Its Name',
                                textAlign: TextAlign.center,
                                style:
                                    TetheredTextStyles.authSubHeading.copyWith(
                                  color: TetheredColors.readingPageTitle,
                                ),
                              ),
                              Gap(height: 5),
                              Wrap(
                                alignment: WrapAlignment.center,
                                children: [
                                  BookDetailsInfoText(
                                    icon: Icons.visibility,
                                    text: '21M views',
                                    color: TetheredColors.readingPageInfo,
                                  ),
                                  BookDetailsInfoText(
                                    icon: Icons.arrow_upward,
                                    text: '12K upvotes',
                                    color: TetheredColors.readingPageInfo,
                                  ),
                                  BookDetailsInfoText(
                                    icon: Icons.list,
                                    text: '21 Tethers',
                                    color: TetheredColors.readingPageInfo,
                                  ),
                                ],
                              ),
                              Gap(height: 5),
                              ZefyrView(
                                document: NotusDocument.fromJson(content),
                              ),
                              Gap(height: 5),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )),
        ),
      ),
    );
  }

  Widget _loadingUi() => Center(
        child: GestureDetector(
          onTap: Get.back,
          child: SpinKitWave(
            color: TetheredColors.primaryBlue,
          ),
        ),
      );
}

const content = [
  {"insert": "Research App"},
  {
    "insert": "\n",
    "attributes": {"heading": 1}
  },
  {"insert": "MS ToDo"},
  {
    "insert": "\n",
    "attributes": {"block": "ul"}
  },
  {"insert": "Google Task"},
  {
    "insert": "\n",
    "attributes": {"block": "ul"}
  },
  {"insert": "MinimaList"},
  {
    "insert": "\n",
    "attributes": {"block": "ul"}
  },
  {"insert": "Taskify"},
  {
    "insert": "\n",
    "attributes": {"block": "ul"}
  },
  {"insert": "Google Keep"},
  {
    "insert": "\n",
    "attributes": {"block": "ul"}
  },
  {"insert": "Google Calendar"},
  {
    "insert": "\n",
    "attributes": {"block": "ul"}
  },
  {"insert": "Asana"},
  {
    "insert": "\n",
    "attributes": {"block": "ul"}
  },
  {
    "insert": "\n",
    "attributes": {"heading": 1}
  },
  {"insert": "MS ToDo"},
  {
    "insert": "\n",
    "attributes": {"block": "ul"}
  },
  {"insert": "Google Task"},
  {
    "insert": "\n",
    "attributes": {"block": "ul"}
  },
  {"insert": "MinimaList"},
  {
    "insert": "\n",
    "attributes": {"block": "ul"}
  },
  {"insert": "Taskify"},
  {
    "insert": "\n",
    "attributes": {"block": "ul"}
  },
  {"insert": "Google Keep"},
  {
    "insert": "\n",
    "attributes": {"block": "ul"}
  },
  {"insert": "Google Calendar"},
  {
    "insert": "\n",
    "attributes": {"block": "ul"}
  },
  {"insert": "Asana"},
  {
    "insert": "\n",
    "attributes": {"block": "ul"}
  },
  {
    "insert": "\n",
    "attributes": {"heading": 1}
  },
  {"insert": "MS ToDo"},
  {
    "insert": "\n",
    "attributes": {"block": "ul"}
  },
  {"insert": "Google Task"},
  {
    "insert": "\n",
    "attributes": {"block": "ul"}
  },
  {"insert": "MinimaList"},
  {
    "insert": "\n",
    "attributes": {"block": "ul"}
  },
  {"insert": "Taskify"},
  {
    "insert": "\n",
    "attributes": {"block": "ul"}
  },
  {"insert": "Google Keep"},
  {
    "insert": "\n",
    "attributes": {"block": "ul"}
  },
  {"insert": "Google Calendar"},
  {
    "insert": "\n",
    "attributes": {"block": "ul"}
  },
  {"insert": "Asana"},
  {
    "insert": "\n",
    "attributes": {"block": "ul"}
  },
  {
    "insert": "\n",
    "attributes": {"heading": 1}
  },
  {"insert": "MS ToDo"},
  {
    "insert": "\n",
    "attributes": {"block": "ul"}
  },
  {"insert": "Google Task"},
  {
    "insert": "\n",
    "attributes": {"block": "ul"}
  },
  {"insert": "MinimaList"},
  {
    "insert": "\n",
    "attributes": {"block": "ul"}
  },
  {"insert": "Taskify"},
  {
    "insert": "\n",
    "attributes": {"block": "ul"}
  },
  {"insert": "Google Keep"},
  {
    "insert": "\n",
    "attributes": {"block": "ul"}
  },
  {"insert": "Google Calendar"},
  {
    "insert": "\n",
    "attributes": {"block": "ul"}
  },
  {"insert": "Asana"},
  {
    "insert": "\n",
    "attributes": {"block": "ul"}
  },
  {
    "insert": "\n",
    "attributes": {"heading": 1}
  },
  {"insert": "MS ToDo"},
  {
    "insert": "\n",
    "attributes": {"block": "ul"}
  },
  {"insert": "Google Task"},
  {
    "insert": "\n",
    "attributes": {"block": "ul"}
  },
  {"insert": "MinimaList"},
  {
    "insert": "\n",
    "attributes": {"block": "ul"}
  },
  {"insert": "Taskify"},
  {
    "insert": "\n",
    "attributes": {"block": "ul"}
  },
  {"insert": "Google Keep"},
  {
    "insert": "\n",
    "attributes": {"block": "ul"}
  },
  {"insert": "Google Calendar"},
  {
    "insert": "\n",
    "attributes": {"block": "ul"}
  },
  {"insert": "Asana"},
  {
    "insert": "\n",
    "attributes": {"block": "ul"}
  },
  {
    "insert": "\n",
    "attributes": {"heading": 1}
  },
  {"insert": "MS ToDo"},
  {
    "insert": "\n",
    "attributes": {"block": "ul"}
  },
  {"insert": "Google Task"},
  {
    "insert": "\n",
    "attributes": {"block": "ul"}
  },
  {"insert": "MinimaList"},
  {
    "insert": "\n",
    "attributes": {"block": "ul"}
  },
  {"insert": "Taskify"},
  {
    "insert": "\n",
    "attributes": {"block": "ul"}
  },
  {"insert": "Google Keep"},
  {
    "insert": "\n",
    "attributes": {"block": "ul"}
  },
  {"insert": "Google Calendar"},
  {
    "insert": "\n",
    "attributes": {"block": "ul"}
  },
  {"insert": "Asana"},
  {
    "insert": "\n",
    "attributes": {"block": "ul"}
  },
  {
    "insert": "\n",
    "attributes": {"heading": 1}
  },
  {"insert": "MS ToDo"},
  {
    "insert": "\n",
    "attributes": {"block": "ul"}
  },
  {"insert": "Google Task"},
  {
    "insert": "\n",
    "attributes": {"block": "ul"}
  },
  {"insert": "MinimaList"},
  {
    "insert": "\n",
    "attributes": {"block": "ul"}
  },
  {"insert": "Taskify"},
  {
    "insert": "\n",
    "attributes": {"block": "ul"}
  },
  {"insert": "Google Keep"},
  {
    "insert": "\n",
    "attributes": {"block": "ul"}
  },
  {"insert": "Google Calendar"},
  {
    "insert": "\n",
    "attributes": {"block": "ul"}
  },
  {"insert": "Asana"},
  {
    "insert": "\n",
    "attributes": {"block": "ul"}
  },
  {
    "insert": "\n",
    "attributes": {"heading": 1}
  },
  {"insert": "MS ToDo"},
  {
    "insert": "\n",
    "attributes": {"block": "ul"}
  },
  {"insert": "Google Task"},
  {
    "insert": "\n",
    "attributes": {"block": "ul"}
  },
  {"insert": "MinimaList"},
  {
    "insert": "\n",
    "attributes": {"block": "ul"}
  },
  {"insert": "Taskify"},
  {
    "insert": "\n",
    "attributes": {"block": "ul"}
  },
  {"insert": "Google Keep"},
  {
    "insert": "\n",
    "attributes": {"block": "ul"}
  },
  {"insert": "Google Calendar"},
  {
    "insert": "\n",
    "attributes": {"block": "ul"}
  },
  {"insert": "Asana"},
  {
    "insert": "\n",
    "attributes": {"block": "ul"}
  },
  {
    "insert": "\n",
    "attributes": {"heading": 1}
  },
  {"insert": "MS ToDo"},
  {
    "insert": "\n",
    "attributes": {"block": "ul"}
  },
  {"insert": "Google Task"},
  {
    "insert": "\n",
    "attributes": {"block": "ul"}
  },
  {"insert": "MinimaList"},
  {
    "insert": "\n",
    "attributes": {"block": "ul"}
  },
  {"insert": "Taskify"},
  {
    "insert": "\n",
    "attributes": {"block": "ul"}
  },
  {"insert": "Google Keep"},
  {
    "insert": "\n",
    "attributes": {"block": "ul"}
  },
  {"insert": "Google Calendar"},
  {
    "insert": "\n",
    "attributes": {"block": "ul"}
  },
  {"insert": "Asana"},
  {
    "insert": "\n",
    "attributes": {"block": "ul"}
  },
  {
    "insert": "\n",
    "attributes": {"heading": 1}
  },
  {"insert": "MS ToDo"},
  {
    "insert": "\n",
    "attributes": {"block": "ul"}
  },
  {"insert": "Google Task"},
  {
    "insert": "\n",
    "attributes": {"block": "ul"}
  },
  {"insert": "MinimaList"},
  {
    "insert": "\n",
    "attributes": {"block": "ul"}
  },
  {"insert": "Taskify"},
  {
    "insert": "\n",
    "attributes": {"block": "ul"}
  },
  {"insert": "Google Keep"},
  {
    "insert": "\n",
    "attributes": {"block": "ul"}
  },
  {"insert": "Google Calendar"},
  {
    "insert": "\n",
    "attributes": {"block": "ul"}
  },
  {"insert": "Asana"},
  {
    "insert": "\n",
    "attributes": {"block": "ul"}
  },
  {
    "insert": "\n",
    "attributes": {"heading": 1}
  },
  {"insert": "MS ToDo"},
  {
    "insert": "\n",
    "attributes": {"block": "ul"}
  },
  {"insert": "Google Task"},
  {
    "insert": "\n",
    "attributes": {"block": "ul"}
  },
  {"insert": "MinimaList"},
  {
    "insert": "\n",
    "attributes": {"block": "ul"}
  },
  {"insert": "Taskify"},
  {
    "insert": "\n",
    "attributes": {"block": "ul"}
  },
  {"insert": "Google Keep"},
  {
    "insert": "\n",
    "attributes": {"block": "ul"}
  },
  {"insert": "Google Calendar"},
  {
    "insert": "\n",
    "attributes": {"block": "ul"}
  },
  {"insert": "Asana"},
  {
    "insert": "\n",
    "attributes": {"block": "ul"}
  },
  {
    "insert": "\n",
    "attributes": {"heading": 1}
  },
  {"insert": "MS ToDo"},
  {
    "insert": "\n",
    "attributes": {"block": "ul"}
  },
  {"insert": "Google Task"},
  {
    "insert": "\n",
    "attributes": {"block": "ul"}
  },
  {"insert": "MinimaList"},
  {
    "insert": "\n",
    "attributes": {"block": "ul"}
  },
  {"insert": "Taskify"},
  {
    "insert": "\n",
    "attributes": {"block": "ul"}
  },
  {"insert": "Google Keep"},
  {
    "insert": "\n",
    "attributes": {"block": "ul"}
  },
  {"insert": "Google Calendar"},
  {
    "insert": "\n",
    "attributes": {"block": "ul"}
  },
  {"insert": "Asana"},
  {
    "insert": "\n",
    "attributes": {"block": "ul"}
  },
  {
    "insert": "\n",
    "attributes": {"heading": 1}
  },
  {"insert": "MS ToDo"},
  {
    "insert": "\n",
    "attributes": {"block": "ul"}
  },
  {"insert": "Google Task"},
  {
    "insert": "\n",
    "attributes": {"block": "ul"}
  },
  {"insert": "MinimaList"},
  {
    "insert": "\n",
    "attributes": {"block": "ul"}
  },
  {"insert": "Taskify"},
  {
    "insert": "\n",
    "attributes": {"block": "ul"}
  },
  {"insert": "Google Keep"},
  {
    "insert": "\n",
    "attributes": {"block": "ul"}
  },
  {"insert": "Google Calendar"},
  {
    "insert": "\n",
    "attributes": {"block": "ul"}
  },
  {"insert": "Asana"},
  {
    "insert": "\n",
    "attributes": {"block": "ul"}
  },
  {
    "insert": "\n",
    "attributes": {"heading": 1}
  },
  {"insert": "MS ToDo"},
  {
    "insert": "\n",
    "attributes": {"block": "ul"}
  },
  {"insert": "Google Task"},
  {
    "insert": "\n",
    "attributes": {"block": "ul"}
  },
  {"insert": "MinimaList"},
  {
    "insert": "\n",
    "attributes": {"block": "ul"}
  },
  {"insert": "Taskify"},
  {
    "insert": "\n",
    "attributes": {"block": "ul"}
  },
  {"insert": "Google Keep"},
  {
    "insert": "\n",
    "attributes": {"block": "ul"}
  },
  {"insert": "Google Calendar"},
  {
    "insert": "\n",
    "attributes": {"block": "ul"}
  },
  {"insert": "Asana"},
  {
    "insert": "\n",
    "attributes": {"block": "ul"}
  },
];
