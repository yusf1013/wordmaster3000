import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wm3k/wm3k_design/controllers/user_controller.dart';
import 'package:wm3k/wm3k_design/screens/market_page.dart';
import 'package:wm3k/wm3k_design/screens/memorization_card_3.dart';
import 'package:wm3k/wm3k_design/screens/my_word_list.dart';
import 'package:wm3k/wm3k_design/screens/navigation_home_screen.dart';
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
        'memorizePage': (context) => MemorizationCard2(),
        'quizPage': (context) => QuizCardScreen(),
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
