import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:provider/provider.dart' as FlutterBase;
import '../../../injection/injection.dart';
import '../../../models/genre.dart';
import '../../../riverpods/home/home_page_provider.dart';
import 'components/book_row.dart';
import '../../components/gap.dart';
import 'components/home_carousel.dart';
import '../../../services/authetication_service.dart';
import '../../../theme/size_config.dart';
import '../../../utils/colors.dart';
import '../../../utils/enums/resource_types.dart';
import '../../../utils/enums/tab_item.dart';
import '../../../utils/inner_routes/home_routes.dart';
import '../../../utils/text_styles.dart';

class HomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final state = watch(homePageStateProvider);
    return Scaffold(
        backgroundColor: TetheredColors.primaryDark,
        appBar: AppBar(
          brightness: Brightness.dark,
          elevation: 10,
          backgroundColor: TetheredColors.primaryDark,
          leading: IconButton(
            icon: Icon(Icons.account_circle, color: Colors.white),
            onPressed: () => Get.toNamed(HomeRoutes.accountPage,
                id: tabItemsToIndex[FlutterBase.Provider.of<TabItem>(
                  context,
                  listen: false,
                )],
                arguments: {
                  "uid": locator<AuthenticationService>().currentUser.uid,
                }),
          ),
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
            return Center(
                child: Text(
              'An unexpected error occured.',
              style: TextStyle(color: Colors.white),
            ));
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
