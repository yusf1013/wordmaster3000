import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:wm3k/analysis_classes/wordList.dart';
import 'package:wm3k/dbConnection/dbManager.dart';
import 'package:wm3k/wm3k_design/controllers/dictionary_database_controller.dart';
import 'package:wm3k/wm3k_design/controllers/user_controller.dart';
import 'package:wm3k/wm3k_design/helper/app_bars.dart';
import 'package:wm3k/wm3k_design/screens/dictionary_page.dart';
import 'package:wm3k/wm3k_design/screens/my_word_list.dart';
import 'package:flutter/material.dart';
import 'package:wm3k/wm3k_design/helper/category_list_view.dart';
import 'package:wm3k/wm3k_design/screens/select_wordlist_screen.dart';
import 'package:wm3k/wm3k_design/screens/spellingCard2.dart';
import 'package:wm3k/wm3k_design/screens/spelling_card.dart';
import 'package:wm3k/wm3k_design/helper/games_list_view.dart';
import '../themes/wm3k_app_theme.dart';
import '../models/category.dart';
import 'create_and_share_list_screen.dart';

class MainHomePage extends StatefulWidget {
  @override
  _MainHomePageState createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {
  CategoryType categoryType = CategoryType.train;
  List<Category> currentList = Category.wordList;
  Widget catListView;
  UserDataController _userDataController = UserDataController();

  @override
  void initState() {
    super.initState();
    //categoryUI = getCategoryUI(currentList);

    getStartLearningView(categoryType);
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
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            DictionaryHomepage(wordString)));
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
                      getStartLearningUI(currentList),
                      //categoryUI,
                      Flexible(
                        child: getGamesTabsUI(),
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

  Widget getStartLearningUI(List<Category> currentList) {
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

  Widget getGamesTabsUI() {
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

  void moveToCoursePage(String id) {
    WordList list = _userDataController.getCourse(id);
    print("Word list id: $id, is null: ${list == null}");
    Navigator.push<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => MyWordList(
          wordList: list,
          searchBar: false,
          backButton: true,
          deletable: false,
        ),
      ),
    );
  }

  void moveTo() {
    Navigator.push<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => SpellingBeeWelcomePage(
          searchBar: false,
          backButton: true,
        ),
      ),
    );
  }

  void moveToWordPage(String id) {
    WordList list = _userDataController.getWordList(id);
    print("Word list id: $id, is null: ${list == null}");
    Navigator.push<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => MyWordList(
          wordList: list,
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
                getStartLearningView(categoryTypeData);
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

  void getStartLearningView(CategoryType categoryTypeData) {
    Widget newWig;
    if (categoryTypeData == CategoryType.train) {
      newWig = ProgressCard();
    } else if (categoryTypeData == CategoryType.myWords) {
      currentList = Category.wordList;
      newWig = LearningTabListView(
        callBack: (id) {
          moveToWordPage(id);
          //print(id);
        },
        onDelete: _userDataController.deleteWordList,
        stream: _userDataController.getStreamOfWordLists(),
        getCurrentList: _userDataController.getCategoryListForWordList,
        addButtonAction: () async {
          bool success = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return CreateWordListView();
            },
          );
          if (success)
            Scaffold.of(context)
              ..removeCurrentSnackBar()
              ..showSnackBar(SnackBar(
                content: Text("Success!"),
                backgroundColor: Colors.green,
              ));
        },
      );
    } else {
      currentList = Category.courseList;
      newWig = LearningTabListView(
        callBack: (id) {
          moveToCoursePage(id);
        },
        onDelete: (id) {
          _userDataController.unEnrollCourse(id);
          print("Flutter is SHIT");
          /*setState(() {
            catListView = ModalProgressHUD(
              inAsyncCall: true,
              color: Colors.black,
              child: SizedBox(
                height: 166,
              ),
            );
          });*/

          Future.delayed(const Duration(milliseconds: 1000), () {
            getStartLearningView(categoryTypeData);
          });
        },
        stream: _userDataController.getCourses(),
        getCurrentList: _userDataController.getCategoryListForCourses,
        addButtonAction: () {
          Navigator.pushNamed(context, 'marketplacePage');
        },
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
