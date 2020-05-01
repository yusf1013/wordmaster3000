import 'package:wm3k/dbConnection/connector.dart';
import 'package:wm3k/dbConnection/dbManager.dart';
import 'package:wm3k/wm3k_design/controllers/dictionary_database_controller.dart';
import 'package:wm3k/wm3k_design/helper/app_bars.dart';
import 'package:wm3k/wm3k_design/screens/my_word_list.dart';
import 'package:flutter/material.dart';
import 'package:wm3k/wm3k_design/helper/category_list_view.dart';
import 'package:wm3k/wm3k_design/screens/spelling_card.dart';
import 'package:wm3k/wm3k_design/screens/toDelete/course_info_screen.dart';
import 'package:wm3k/wm3k_design/helper/games_list_view.dart';
import '../themes/wm3k_app_theme.dart';
import '../models/category.dart';

class MainHomePage extends StatefulWidget {
  const MainHomePage({Key key}) : super(key: key);

  @override
  _MainHomePageState createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage>
    with TickerProviderStateMixin {
  AnimationController animationController;
  bool multiple = true;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 0));
    return true;
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DesignCourseHomeScreen();
  }
}

class DesignCourseHomeScreen extends StatefulWidget {
  @override
  _DesignCourseHomeScreenState createState() => _DesignCourseHomeScreenState();
}

class _DesignCourseHomeScreenState extends State<DesignCourseHomeScreen> {
  CategoryType categoryType = CategoryType.train;
  List<Category> currentList = Category.wordList;
  Widget catListView;

  @override
  void initState() {
    super.initState();
    //categoryUI = getCategoryUI(currentList);
    /*catListView = CategoryListView(
      () {
        moveTo();
      },
      currentList,
    );*/
    getView(categoryType);
  }

  @override
  Widget build(BuildContext context) {
    //categoryUI = getCategoryUI(currentList);
    return Container(
      color: DesignCourseAppTheme.nearlyWhite,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).padding.top,
            ),
            //getAppBarUI(),
            MyAppBar(),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: <Widget>[
                      //getSearchBarUI(context),
                      FutureBuilder(
                        future: DBManager().getListOfAllWords(),
                        builder: (buildContext, snapShot) {
                          if (snapShot.hasData) {
                            DBController.setAllList(snapShot.data);
                            return SearchBarUI(
                              onSubmit: (wordString) async {
                                print("dsfa");
                                Connector con = new Connector();
                                await con.search(wordString);
                                print('The word is ${con.word}');
                                Navigator.pushNamed(context, 'dictionaryPage',
                                    arguments: con);
                              },
                            );
                          } else {
                            print('No data done done shit');
                            return SizedBox(
                              height: 20,
                              width: 20,
                            );
                          }
                        },
                      ),
                      getCategoryUI(currentList),
                      //categoryUI,
                      Flexible(
                        child: getPopularCourseUI(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getCategoryUI(List<Category> currentList) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 18, right: 16),
          child: Text(
            'Start Learning',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 22,
              letterSpacing: 0.27,
              color: DesignCourseAppTheme.darkerText,
            ),
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Row(
            children: <Widget>[
              getButtonUI(
                  CategoryType.train, categoryType == CategoryType.train),
              const SizedBox(
                width: 16,
              ),
              getButtonUI(
                  CategoryType.myWords, categoryType == CategoryType.myWords),
              const SizedBox(
                width: 16,
              ),
              getButtonUI(
                  CategoryType.courses, categoryType == CategoryType.courses),
            ],
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        /*CategoryListView(
          () {
            moveTo();
          },
          currentList,
        ),*/
        catListView,
      ],
    );
  }

  Widget getPopularCourseUI() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 18, right: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Love Games?',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 22,
              letterSpacing: 0.27,
              color: DesignCourseAppTheme.darkerText,
            ),
          ),
          Flexible(
            child: GamesListView(
              callBack: () {
                moveTo();
              },
            ),
          )
        ],
      ),
    );
  }

  void moveTo() {
    Navigator.push<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => SpellingCard(),
      ),
    );
  }

  void moveToWordPage(String title) {
    Navigator.push<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => MyWordList(
          title: title,
          searchBar: false,
          backButton: true,
        ),
      ),
    );
  }

  Widget getButtonUI(CategoryType categoryTypeData, bool isSelected) {
    String txt = '';
    if (CategoryType.train == categoryTypeData) {
      txt = 'Training';
    } else if (CategoryType.myWords == categoryTypeData) {
      txt = 'My Words';
    } else if (CategoryType.courses == categoryTypeData) {
      txt = 'Courses';
    }
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
            color: isSelected
                ? DesignCourseAppTheme.nearlyBlue
                : DesignCourseAppTheme.nearlyWhite,
            borderRadius: const BorderRadius.all(Radius.circular(24.0)),
            border: Border.all(color: DesignCourseAppTheme.nearlyBlue)),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            splashColor: Colors.white24,
            borderRadius: const BorderRadius.all(Radius.circular(24.0)),
            onTap: () {
              categoryType = categoryTypeData;
              setState(() {
                catListView = SizedBox(
                  height: 166,
                );
              });

              Future.delayed(const Duration(milliseconds: 100), () {
                getView(categoryTypeData);
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 12, bottom: 12, left: 12, right: 12),
              child: Center(
                child: Text(
                  txt,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    letterSpacing: 0.27,
                    color: isSelected
                        ? DesignCourseAppTheme.nearlyWhite
                        : DesignCourseAppTheme.nearlyBlue,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void getView(CategoryType categoryTypeData) {
    Widget newWig;
    if (categoryTypeData == CategoryType.train) {
      newWig = ProgressCard();
    } else if (categoryTypeData == CategoryType.myWords) {
      currentList = Category.wordList;
      newWig = CategoryListView(
        callBack: (title) {
          moveToWordPage(title);
        },
        currentList: currentList,
        type: categoryTypeData,
      );
    } else {
      currentList = Category.courseList;
      newWig = CategoryListView(
        callBack: () {
          moveTo();
        },
        currentList: currentList,
        type: categoryTypeData,
      );
    }

    setState(() {
      catListView = newWig;
    });
  }

  Widget getAppBarUI() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 18, right: 18),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 40,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Welcome to',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            letterSpacing: 0.2,
                            color: DesignCourseAppTheme.grey,
                          ),
                        ),
                        Text(
                          'Word Master 3000',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            letterSpacing: 0.27,
                            color: DesignCourseAppTheme.darkerText,
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
          Container(
            width: 70,
            height: 60,
            child: Hero(
                tag: 'assets/images/wmicon.png',
                child: Image.asset('assets/images/wmicon.png')),
          )
        ],
      ),
    );
  }
}

enum CategoryType {
  train,
  myWords,
  courses,
}
