import 'package:flutter/services.dart';
import 'package:wm3k/dbConnection/connector.dart';
import 'package:wm3k/dbConnection/dbManager.dart';
import 'package:wm3k/wm3k_design/controllers/clipBoardManager.dart';
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
import 'package:wm3k/wm3k_design/controllers/user_controller.dart';

import 'toDelete/feedback_screen.dart';

class NavigationHomeScreen extends StatefulWidget {
  @override
  _NavigationHomeScreenState createState() => _NavigationHomeScreenState();
}

class _NavigationHomeScreenState extends State<NavigationHomeScreen> {
  Widget screenView;
  DrawerIndex drawerIndex;
  AnimationController sliderAnimationController;


  printSearch(String word) async {
    SearchedWord con = new SearchedWord();
    //Word searched= Word();
    await con.search(word);
    String wordfound = con.word;
    if (word == wordfound) {
      print(" the properties for $wordfound");

      /*for (Meaning pos in con.searchedWordMeaning) {
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
      }*/
    } else {
      print("The word is $word.word");
    }
  }

  Future<void> printAllWords() async {
    List<String> list = await DBManager().getListOfAllWords();
    for (String word in list) print(word);
  }



  /*printsearch(String word) async {
    Connector con = new Connector();
    //Word searched= Word();
    await con.search(word);
    String wordfound = con.word;
    if (word == wordfound) {
      print(" the properties for $wordfound");
      for (var i = 0; i < con.property.length; i++) {
        PartsOfSpeech localproperty = con.property[i];
        int id = con.property[i].id;
        print("id is $id");
        String partsofspeech = con.property[i].parts_of_speech;
        print("it $partsofspeech");
        print("meaning");
        for (var j = 0; j < localproperty.meaning.length; j++) {
          Meaning localmeaning = localproperty.meaning[j];
          int meaningid = localmeaning.meaning_id;
          print("meaning id is $meaningid");

          String meaning = localmeaning.meaning;
          print(meaning);

          for (var k = 0; k < localmeaning.example.length; k++) {
            print(localmeaning.example[k]);
          }
        }

        print("synonyms");
        for (var i = 0; i < localproperty.synonyms.length; i++) {
          print(localproperty.synonyms[i]);
        }
        print("more example");
        for (var i = 0; i < localproperty.more_example.length; i++) {
          //print("more example");
          print(localproperty.more_example[i]);
        }
      }
      for (var i = 0; i < con.idioms.length; i++) {
        print(con.idioms[i]);
      }
      print("phrases");
      for (var i = 0; i < con.phrases.length; i++) {
        print(con.phrases[i]);
      }
    }
    // else{
    //print("The word is $searched.word");
    // }
  }*/

  static const platform = const MethodChannel('samples.flutter.dev/bubblehead');
  Future<void> _openchathead() async {
    print("chat head khular jonno call kora hoitese, bal da ki kore allah jne");
    try {
      await platform.invokeMethod('openchathead');
    } on PlatformException catch (e) {
      print("failed to open chathead");
    }
    _openchathead();
  }
  @override
  void initState() {
    drawerIndex = DrawerIndex.HOME;
    screenView = MainHomePage();
    //printSearch("abalone");
    print("we are calling bubble from here");
    _openchathead();
    //clipBoardManager clip=clipBoardManager();
    //clip.repeat();
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
