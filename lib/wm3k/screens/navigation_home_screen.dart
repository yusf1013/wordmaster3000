import 'package:wm3k/wm3k/themes/app_theme.dart';
import 'package:wm3k/custom_drawer/drawer_user_controller.dart';
import 'package:wm3k/custom_drawer/home_drawer.dart';
import 'package:wm3k/wm3k/screens/my_word_list.dart';
import 'package:wm3k/wm3k/screens/toDelete/help_screen.dart';
import 'package:wm3k/wm3k/screens/main_home_screen.dart';
import 'package:wm3k/wm3k/screens/toDelete/invite_friend_screen.dart';
import 'package:wm3k/wm3k/screens/market_page.dart';
import 'package:flutter/material.dart';

import 'toDelete/feedback_screen.dart';

class NavigationHomeScreen extends StatefulWidget {
  @override
  _NavigationHomeScreenState createState() => _NavigationHomeScreenState();
}

class _NavigationHomeScreenState extends State<NavigationHomeScreen> {
  Widget screenView;
  DrawerIndex drawerIndex;
  AnimationController sliderAnimationController;

  @override
  void initState() {
    drawerIndex = DrawerIndex.HOME;
    screenView = MainHomePage();
    /*screenView = Container(
      color: Colors.red,
    );*/
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.nearlyWhite,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          backgroundColor: AppTheme.nearlyWhite,
          body: DrawerUserController(
            screenIndex: drawerIndex,
            drawerWidth: MediaQuery.of(context).size.width * 0.75,
            animationController: (AnimationController animationController) {
              sliderAnimationController = animationController;
            },
            onDrawerCall: (DrawerIndex drawerIndexdata) {
              changeIndex(drawerIndexdata);
            },
            screenView: screenView,
          ),
        ),
      ),
    );
  }

  /*Widget build(BuildContext context) {
    return Container(
      color: AppTheme.nearlyWhite,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          backgroundColor: AppTheme.nearlyWhite,
          body: MyHomePage(),
          drawer: Drawer(
            child: SizedBox(
              width: 100,
              height: 100,
              child: Container(
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }*/

  void changeIndex(DrawerIndex drawerIndexdata) {
    if (drawerIndex != drawerIndexdata) {
      drawerIndex = drawerIndexdata;
      if (drawerIndex == DrawerIndex.HOME) {
        setState(() {
          screenView = MainHomePage();
          //screenView = DesignCourseHomeScreen();
        });
      } else if (drawerIndex == DrawerIndex.Help) {
        setState(() {
          screenView = HelpScreen();
        });
      } else if (drawerIndex == DrawerIndex.FeedBack) {
        setState(() {
          screenView = FeedbackScreen();
        });
      } else if (drawerIndex == DrawerIndex.Invite) {
        setState(() {
          screenView = InviteFriend();
        });
      } else if (drawerIndex == DrawerIndex.MarketPlace)
        setState(() {
          screenView = MarketPage();
        });
      else if (drawerIndex == DrawerIndex.MyWordList) {
        setState(() {
          screenView = MyWordList();
        });
      } else {
        //do in your way......
      }
    }
  }
}
