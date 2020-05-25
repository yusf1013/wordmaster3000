import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wm3k/dbConnection/connector.dart';
import 'package:wm3k/dbConnection/dbManager.dart';
import 'package:wm3k/wm3k_design/controllers/user_controller.dart';
import 'package:wm3k/wm3k_design/screens/market_page.dart';
import 'package:wm3k/wm3k_design/screens/memorization_card.dart';
import 'package:wm3k/wm3k_design/screens/my_word_list.dart';
import 'package:wm3k/wm3k_design/screens/navigation_home_screen.dart';
import 'package:wm3k/wm3k_design/screens/notification_card.dart';
import 'package:wm3k/wm3k_design/screens/quiz_screen.dart';
import 'package:wm3k/wm3k_design/screens/welcome_screen.dart';
import 'package:wm3k/wm3k_design/themes/app_theme.dart';
import 'package:wm3k/wm3k_design/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    print("Logged in? : ${AuthController().isLoggedIn()}");
    bool loggedIn = AuthController().isLoggedIn();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness:
          Platform.isAndroid ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarDividerColor: Colors.grey,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    return MaterialApp(
      title: 'Word master 3000',
      routes: {
        'navigationHomePage': (context) => NavigationHomeScreen(),
        'authPage': (context) => LoginScreen(),
        'wordListPage': (context) => MyWordList(),
        //'memorizePage': (context) => MemorizationCard(),
        'marketplacePage': (context) => MarketPage(),
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: AppTheme.textTheme,
        //canvasColor: Colors.transparent,
      ),
      //home: loggedIn ? WelcomeScreen() : LoginScreen(),
      home: WelcomeScreen(),
      //home: MyApp(),
      //home: LoginScreen(),
      //home: QuizCardScreen(),
      //home: LeaderBoardPage(),
      //home: PageViewDemo(),
      //home: Page(),
      //home: Temp(),
      //home: InviteFriend(),
      //home: LoginScreen(),
      //home: DictionaryHomePage(),
      //home: MyWordList(),
      //home: FeedbackScreen(),
      //home: MyHomePage(),
      //home: CourseInfoScreen(),
      //home: FeedbackScreen(),
      //home: RecomendedPage(), //marketPLace
      //home: CourseInfoScreen(),
      //home: DictionaryPage(),
      //home: FitnessAppHomeScreen(),
      //home: DictionaryHomePage(),
      //home: Scaffold(body: CategoryListView(() {}, Category.trainList),
      //),
    );
  }
}

class Temp extends StatefulWidget {
  @override
  _TempState createState() => _TempState();
}

class _TempState extends State<Temp> {
  bool spin = true;

  @override
  void initState() {
    // TODO: implement initState
    load();
    super.initState();
  }

  void load() async {
    DBManager db = DBManager();
    SearchedWord word = SearchedWord();
    List<String> list = await db.getListOfAllWords();
    list[0] = "land";
    for (int i = 0; i < 100; i++) {
      await word.search(list[i]);
      print("$i. ${word.word}");
    }
    setState(() {
      spin = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: spin,
      child: Container(
        color: Colors.red,
      ),
    );
  }
}
