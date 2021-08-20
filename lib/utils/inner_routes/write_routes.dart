import 'package:get/route_manager.dart';
import '../../screens/write/new_story_page/new_story_page.dart';
import '../../screens/write/write_page/write_page.dart';

class WriteRoutes {
  static const String newStory = '/new-story';
  static const String initialPage = '/initial-page';
}

final writeRouteBuilder = {
  WriteRoutes.newStory: (args) => GetPageRoute(
        page: () => NewStoryPage(),
      ),
  WriteRoutes.initialPage: (args) => GetPageRoute(
        page: () => WritePage(),
      ),
};

final writeInitialRoute = (args) => GetPageRoute(
      page: () => WritePage(),
    );
