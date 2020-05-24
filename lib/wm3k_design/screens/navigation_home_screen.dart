import 'package:wm3k/dbConnection/connector.dart';
import 'package:wm3k/dbConnection/dbManager.dart';
import 'package:wm3k/wm3k_design/controllers/dictionary_database_controller.dart';
import 'package:wm3k/wm3k_design/screens/leaderboard_screen.dart';
import 'package:wm3k/wm3k_design/themes/app_theme.dart';
import 'package:wm3k/custom_drawer/drawer_user_controller.dart';
import 'package:wm3k/custom_drawer/home_drawer.dart';
import 'package:wm3k/wm3k_design/screens/my_word_list.dart';
import 'package:wm3k/wm3k_design/screens/toDelete/help_screen.dart';
import 'package:wm3k/wm3k_design/screens/main_home_screen.dart';
import 'package:wm3k/wm3k_design/screens/toDelete/invite_friend_screen.dart';
import 'package:wm3k/wm3k_design/screens/market_page.dart';
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

  /*printSearch(String word) async {
    SearchedWord con = new SearchedWord();
    //Word searched= Word();
    await con.search(word);
    String wordfound = con.word;
    if (word == wordfound) {
      print(" the properties for $wordfound");

      for (Meaning pos in con.searchedWordMeaning) {
        for (SubMeaning submeaningobject in pos.sub_meaning) {
          print('${pos.partsOfSpeech}:');
          print(submeaningobject.submeaning);
          for (String example in submeaningobject.example) print(example);
        }
        for (String moreExamples in pos.moreExample) print(moreExamples);
        for (String synonyms in pos.synonyms) print(synonyms);
        for (String idioms in con.idioms) print(idioms);
        for (String phrases in con.phrases) print(phrases);

        print('\n\n');
      }
    } else {
      print("The word is $word.word");
    }
  }*/

  Future<void> printAllWords() async {
    List<String> list = await DBManager().getListOfAllWords();
    for (String word in list) print(word);
  }

  @override
  void initState() {
    drawerIndex = DrawerIndex.HOME;
    screenView = MainHomePage();
    //printSearch("abalone");
    //printAllWords();
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
      } else if (drawerIndex == DrawerIndex.LeaderBoard) {
        setState(() {
          screenView = LeaderBoardPage();
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
