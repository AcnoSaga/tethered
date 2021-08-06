import 'package:get/route_manager.dart';
import 'package:tethered/screens/write/new_story_page/new_story_page.dart';
import 'package:tethered/screens/write/write_page/write_page.dart';

class WriteRoutes {
  static const String newStory = '/new-story';
}

final writeRouteBuilder = {
  WriteRoutes.newStory: (args) => GetPageRoute(
        page: () => NewStoryPage(),
      ),
};

final writeInitialRoute = (args) => GetPageRoute(
      page: () => WritePage(),
    );
