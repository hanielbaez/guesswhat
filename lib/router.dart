//Flutter and Dart import
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

//Self import
import 'package:Tekel/ui/pages/riddlePage.dart';
import 'package:Tekel/ui/pages/homePage.dart';
import 'package:Tekel/ui/pages/lovePage.dart';
import 'package:Tekel/ui/pages/supportPage.dart';
import 'package:Tekel/ui/pages/unknownPage.dart';
import 'package:Tekel/ui/pages/userPage.dart';
import 'package:Tekel/ui/pages/editUserPage.dart';
import 'package:Tekel/ui/pages/commentPage.dart';
import 'package:Tekel/ui/pages/solvedByUserPage.dart';
import 'package:Tekel/ui/pages/textCreatePage.dart';
import 'package:Tekel/ui/pages/notificationPage.dart';
import 'package:Tekel/ui/pages/riddleTopSolversPage.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  Object argument = settings.arguments;
  switch (settings.name) {
    case 'homePage':
      return PageTransition(child: HomePage(), type: PageTransitionType.fade);
    case 'lovePage':
      return PageTransition(child: LovePage(), type: PageTransitionType.fade);
    case 'riddlePage':
      return PageTransition(
          child: RiddlePage(argument), type: PageTransitionType.fade);
    case 'userPage':
      return PageTransition(
          child: UserPage(user: argument), type: PageTransitionType.fade);
    case 'supportPage':
      return PageTransition(
          child: SupportPage(user: argument), type: PageTransitionType.fade);
    case 'commentsPage':
      return PageTransition(
          child: CommentPage(riddle: argument), type: PageTransitionType.fade);
    case 'editUserPage':
      return PageTransition(
          child: EditUserPage(user: argument), type: PageTransitionType.fade);
    case 'solvedByPage':
      return PageTransition(
          child: SolvedByPage(user: argument), type: PageTransitionType.fade);
    case 'notificationsPage':
      return PageTransition(
          child: NotificationPage(), type: PageTransitionType.fade);
    case 'createTextRiddle':
      return PageTransition(
          child: TextCreatePage(), type: PageTransitionType.fade);
    case 'topSolversPage':
      return PageTransition(
          child: RiddleTopSolversPage(
            riddleId: argument,
          ),
          type: PageTransitionType.fade);
    default:
      return MaterialPageRoute(
        builder: (context) => UnknownPage(),
      );
  }
}
