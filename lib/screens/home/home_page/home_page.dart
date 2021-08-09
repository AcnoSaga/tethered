import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:provider/provider.dart' as FlutterBase;
import 'package:tethered/injection/injection.dart';
import 'package:tethered/models/genre.dart';
import 'package:tethered/riverpods/home/home_page_provider.dart';
import 'package:tethered/screens/home/home_page/components/book_row.dart';
import 'package:tethered/screens/components/gap.dart';
import 'package:tethered/screens/home/home_page/components/home_carousel.dart';
import 'package:tethered/services/authetication_service.dart';
import 'package:tethered/theme/size_config.dart';
import 'package:tethered/utils/colors.dart';
import 'package:tethered/utils/enums/resource_types.dart';
import 'package:tethered/utils/enums/tab_item.dart';
import 'package:tethered/utils/inner_routes/home_routes.dart';
import 'package:tethered/utils/text_styles.dart';

class HomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final state = watch(homePageStateProvider);
    return Scaffold(
        drawer: Drawer(
          child: Container(
            color: TetheredColors.primaryDark,
            child: ListView(
              children: [
                DrawerHeader(
                  child: GestureDetector(
                    onTap: () async {
                      await Get.toNamed(HomeRoutes.accountPage,
                          id: tabItemsToIndex[FlutterBase.Provider.of<TabItem>(
                            context,
                            listen: false,
                          )],
                          arguments: {
                            "uid": locator<AuthenticationService>()
                                .currentUser
                                .uid,
                          });
                      // Get cannot manage this, Drawer is controlled by default Navigator
                      Navigator.of(context).pop();
                    },
                    child: Text('Account'),
                  ),
                ),
              ],
            ),
          ),
        ),
        backgroundColor: TetheredColors.primaryDark,
        appBar: AppBar(
          elevation: 10,
          backgroundColor: TetheredColors.primaryDark,
          title: Text(
            'Tethered',
            style: TetheredTextStyles.homeAppBarHeading,
          ),
        ),
        body: () {
          if (state is HomePageInitial) {
            return Container();
          } else if (state is HomePageLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is HomePageLoaded) {
            return _loadedPage(state.genres);
          } else {
            return Center(child: Text('Please try again'));
          }
        }());
  }

  Widget _loadedPage(List<Genre> genres) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(height: 5),
            HomeCarousel(),
            Gap(height: 3),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: genres.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: sx),
                  child: BookRow(
                    resource: genres[index],
                    titlePadding: EdgeInsets.symmetric(
                        horizontal: sy * 3, vertical: sx * 2),
                    title: genres[index].name,
                    isResourceExpandable: index != 0,
                    resourceType: ResourceTypes.genre,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
