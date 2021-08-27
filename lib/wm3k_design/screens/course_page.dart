import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_awesome_alert_box/flutter_awesome_alert_box.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:toast/toast.dart';
import 'package:wm3k/analysis_classes/wordList.dart';
import 'package:wm3k/wm3k_design/controllers/user_controller.dart';
import 'package:wm3k/wm3k_design/helper/app_bars.dart';

import 'loading_screen.dart';
import 'my_word_list.dart';

class CoursePage extends StatefulWidget {
  final String id;

  CoursePage(this.id);

  @override
  _CoursePageState createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  String id;
  UserDataController userDataController = UserDataController();
  bool hasCourse, hasCreatedCourse;
  Color unSelectedIconColor = Colors.white;

  @override
  void initState() {
    id = widget.id;
    hasCourse = userDataController.hasCourse(id);
    hasCreatedCourse = userDataController.hasCreatedCourse(id);
    if (hasCourse) unSelectedIconColor = Colors.grey;
    super.initState();
  }

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: loading,
      child: LoadingScreen(
        asyncFunction: () async {
          WordList list = await userDataController.getCourseFromID(id);
          return list;
        },
        getChild: (WordList data) {
          Function _bottomIcons =
              (IconData icondata, String title, Color textColor) {
            if (textColor == null) textColor = Colors.blue[200];
            return BottomNavigationBarItem(
              icon: Icon(icondata),
              title: Text(
                title,
                style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
              ),
            );
          };
          return MyWordList(
            deletable: false,
            searchBar: false,
            backButton: true,
            wordList: data,
            separatorColor: Colors.black54,
            dotColor: Color(0xFF100c08),
            header: HeaderAppBar2(
              title: data.name,
              searchBar: false,
              backButton: true,
              headerColor: Colors.blue[200],
            ),
            bottomNavigationBar: BottomNavigationBar(
              showSelectedLabels: true,
              showUnselectedLabels: true,
              selectedItemColor: Colors.blue[200],
              unselectedItemColor: unSelectedIconColor,
              backgroundColor: Color(0xFF020001),
              type: BottomNavigationBarType.fixed,
              currentIndex: 0,
              items: getBottomNavItems(_bottomIcons, hasCourse),
              onTap: (index) async {
                if (index == 1) {
                  if (!hasCourse) {
                    setState(() {
                      loading = true;
                    });
                    bool success = await userDataController.enrollInCourse(id);
                    setState(() {
                      loading = false;
                      hasCourse = true;
                      unSelectedIconColor = Colors.grey;
                    });

                    Toast.show(
                        success
                            ? "Enrollment successful!"
                            : "Something went wrong",
                        context,
                        duration: Toast.LENGTH_LONG,
                        gravity: Toast.BOTTOM);
                  }
                } else if (index == 2) {
                  DeleteAlertBox(
                      context: context,
                      infoMessage:
                          "This course will be removed from market. Do you want to continue?",
                      onPressedYes: () {
                        userDataController.unPublishCourse(id);
                        int count = 0;
                        Navigator.of(context).popUntil((_) => count++ >= 2);

                        InfoAlertBox(
                            context: context,
                            title: "Unpublished",
                            infoMessage: "Course has been removed from market");
                      },
                      onPressedNo: () {
                        Navigator.pop(context);
                      });
                  //Navigator.
                  //print("More jao");
                  //userDataController.unPublishCourse(id);
                  //Navigator.pop(context, 1);
                }
              },
            ),
          );
        },
      ),
    );
  }

  List<BottomNavigationBarItem> getBottomNavItems(
      Function _bottomIcons, bool hasCourse) {
    List<BottomNavigationBarItem> l = [
      _bottomIcons(Icons.info_outline, "View", null),
      hasCourse
          ? _bottomIcons(Icons.offline_pin, "Enrolled", unSelectedIconColor)
          : _bottomIcons(Icons.add, "Enroll", Colors.white),
    ];
    if (hasCreatedCourse)
      l.add(_bottomIcons(Icons.delete_sweep, "Unpublish", Colors.white));
    return l;
  }
}
