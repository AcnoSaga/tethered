import 'package:flutter/animation.dart';
import 'package:flutter_bloc/flutter_bloc.dart' as bloc;
import 'package:get/get.dart';
import 'package:tethered/cubits/auth_blocs/login_bloc/login_bloc.dart';
import 'package:tethered/injection/injection.dart';
import 'package:tethered/models/book_details.dart';
import 'package:tethered/screens/auth/forgot_password/forgot_password.dart';
import 'package:tethered/screens/auth/login/login_screen.dart';
import 'package:tethered/screens/auth/signup/signup_screen.dart';
import 'package:tethered/screens/home/account_page/account_page.dart';
import 'package:tethered/screens/home/book_details_page/book_details_page.dart';
import 'package:tethered/screens/home/hashtag_page/hashtag_page.dart';
import 'package:tethered/screens/main_page.dart';
import 'package:tethered/screens/read/comments_page/comments_page.dart';
import 'package:tethered/screens/read/index_page/index_page.dart';
import 'package:tethered/screens/read/reading_page.dart';
import 'package:tethered/screens/welcome_screen.dart';
import 'package:tethered/screens/write/edit_page/edit_page.dart';
import 'package:tethered/screens/write/new_story_page/new_story_page.dart';
import 'package:tethered/services/authetication_service.dart';

class Routes {
  static List<GetPage> getPages() {
    // ignore: close_sinks
    LoginBloc loginBloc = locator<LoginBloc>();
    return [
      GetPage(
        name: '/',
        page: () => WelcomeScreen(),
      ),
      GetPage(
        name: '/login',
        page: () => bloc.BlocProvider<LoginBloc>.value(
          value: loginBloc,
          child: LoginScreen(),
        ),
        transition: Transition.fadeIn,
      ),
      GetPage(
        name: '/forgot-password',
        page: () => bloc.BlocProvider<LoginBloc>.value(
          value: loginBloc,
          child: ForgotPassword(),
        ),
        curve: Curves.decelerate,
        transitionDuration: Duration(milliseconds: 250),
      ),
      GetPage(
        name: '/signup',
        page: () => SignupScreen(),
        curve: Curves.decelerate,
        transitionDuration: Duration(milliseconds: 250),
      ),
      GetPage(
        name: '/home',
        page: () => MainPage(),
      ),
      GetPage(
        name: '/read',
        page: () => ReadingPage(),
      ),
      GetPage(
        name: '/index',
        page: () => IndexPage(),
        transition: Transition.downToUp,
      ),
      GetPage(
        name: '/comments',
        page: () => CommentsPage(),
      ),
      GetPage(
        name: '/edit',
        page: () => EditPage(),
      ),
      GetPage(
        name: '/account',
        page: () => AccountPage(),
      ),
      GetPage(
        name: '/book-details',
        page: () => BookDetailPage(),
      ),
      GetPage(
        name: '/hashtag',
        page: () => HashtagPage(),
      ),
      GetPage(
        name: '/account',
        page: () => AccountPage(),
      ),
      GetPage(
        name: '/new-story',
        page: () => NewStoryPage(),
        transition: Transition.downToUp,
      ),
    ];
  }

  static Future<String> getInitialRoute() async {
    if (locator<AuthenticationService>().isUserLoggedIn()) {
      return '/home';
    }
    return '/';
  }
}
