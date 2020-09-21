import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:toast/toast.dart';
import 'package:wm3k/analysis_classes/wordList.dart';
import 'package:wm3k/wm3k_design/controllers/user_controller.dart';
import 'package:wm3k/wm3k_design/helper/app_bars.dart';
import 'package:wm3k/wm3k_design/helper/quad_clipper.dart';
import 'package:wm3k/wm3k_design/screens/course_page.dart';
import 'package:wm3k/wm3k_design/screens/loading_screen.dart';
import 'package:wm3k/wm3k_design/screens/my_word_list.dart';
import 'package:wm3k/wm3k_design/themes/color/light_color.dart';
import 'package:flutter/material.dart';
import '../helper/courseModel.dart';
import '../themes/market_place_theme.dart';

class MarketPage extends StatefulWidget {
  MarketPage({Key key}) : super(key: key);

  @override
  _MarketPageState createState() => _MarketPageState();
}

class _MarketPageState extends State<MarketPage> {
  double width;
  bool contributionsOnly = false;
  String subHeaderText = "Market Place";

  Widget _categoryRow(String title) {
    // This thing includes the popular tags and MP text
    return Container(
      // margin: EdgeInsets.symmetric(horizontal: 20),
      height: 88,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              title,
              style: TextStyle(
                  color: LightColor.extraDarkPurple,
                  fontSize: 20,
                  fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
              width: width,
              height: 30,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: getAllTagChips(),
              )),
          SizedBox(height: 10)
        ],
      ),
    );
  }

  List<Widget> getAllTagChips() {
    List<Widget> list = new List();
    for (String item in tags) {
      list.addAll([
        SizedBox(width: 25),
        _chip(item, LightColor.getSerialColor(), height: 5)
      ]);
    }
    list.removeLast();
    return list;
  }

  Widget _chip(String text, Color textColor,
      {double height = 0, bool isPrimaryCard = false}) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: height),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        color: textColor.withAlpha(isPrimaryCard ? 200 : 50),
      ),
      child: Text(
        text,
        style: TextStyle(
            color: isPrimaryCard ? Colors.white : textColor, fontSize: 12),
      ),
    );
  }

  BottomNavigationBarItem _bottomIcons(IconData icon, String title) {
    return BottomNavigationBarItem(
        //  backgroundColor: Colors.blue,
        icon: Icon(icon),
        title: Text(
          title,
          style: TextStyle(color: Colors.black),
        ));
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedItemColor: LightColor.extraDarkPurple,
          unselectedItemColor: Colors.grey.shade300,
          type: BottomNavigationBarType.fixed,
          currentIndex: 0,
          items: [
            _bottomIcons(Icons.shopping_cart, "New Courses"),
            _bottomIcons(Icons.list, "My Contribution"),
          ],
          onTap: (index) {
            if (index == 0)
              setState(() {
                contributionsOnly = false;
                subHeaderText = "Market Place";
              });
            else if (index == 1)
              setState(() {
                contributionsOnly = true;
                subHeaderText = "My contributions";
              });
            /*Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => HomePage()));*/
          },
        ),
        body: Column(
          children: <Widget>[
            HeaderAppBar(),
            SizedBox(
              height: 20,
            ),
            _categoryRow(subHeaderText),
            Expanded(
              child: CourseListWidget(contributionsOnly),
            ),
            /*Expanded(
              flex: 5,
              child: SingleChildScrollView(
                  child: Container(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20),
                    _categoryRow("Market Place"),
                    _courseList(),
                  ],
                ),
              )),
            ),*/
          ],
        ));
  }
}

class CourseListWidget extends StatelessWidget {
  final UserDataController userDataController = UserDataController();
  final bool contributionsOnly;

  CourseListWidget(this.contributionsOnly);

  Widget _circularContainer(double height, Color color,
      {Color borderColor = Colors.transparent, double borderWidth = 2}) {
    return Container(
      height: height,
      width: height,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        border: Border.all(color: borderColor, width: borderWidth),
      ),
    );
  }

  Widget _card(double width,
      {Color primaryColor = Colors.redAccent,
      String imgPath,
      Widget backWidget}) {
    return Container(
        height: 190,
        width: width * .34,
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.all(Radius.circular(20)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  offset: Offset(0, 5),
                  blurRadius: 10,
                  color: Color(0x12000000))
            ]),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          child: backWidget,
        ));
  }

  Positioned _smallContainer(Color primaryColor, double top, double left,
      {double radius = 10}) {
    return Positioned(
        top: top,
        left: left,
        child: CircleAvatar(
          radius: radius,
          backgroundColor: primaryColor.withAlpha(255),
        ));
  }

  Widget _courceInfo(double width, CourseModel model, Widget decoration,
      {Color background}) {
    return Container(
        height: 170,
        width: width - 20,
        child: Row(
          children: <Widget>[
            AspectRatio(
              aspectRatio: .7,
              child: _card(width,
                  primaryColor: background, backWidget: decoration),
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 15),
                Container(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Expanded(
                        child: Text(model.name,
                            style: TextStyle(
                                color: LightColor.purple,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                      ),
                      /*CircleAvatar(
                        radius: 3,
                        backgroundColor: background,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(model.rating,
                          style: TextStyle(
                            color: LightColor.grey,
                            fontSize: 14,
                          )),*/
                      Icon(
                        Icons.get_app,
                        color: background,
                        size: 20,
                      ),
                      Text(model.downloads.toString(),
                          style: TextStyle(
                            color: LightColor.grey,
                            fontSize: 14,
                          )),
                      SizedBox(width: 10)
                    ],
                  ),
                ),
                Text(model.author,
                    style: AppTheme.h6Style.copyWith(
                      fontSize: 12,
                      color: LightColor.grey,
                    )),
                SizedBox(height: 15),
                Text(
                  model.description,
                  style: AppTheme.h6Style.copyWith(
                      fontSize: 12, color: LightColor.extraDarkPurple),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 10),
                Expanded(
                  child: Container(),
                ),
                Text("Total words: ${model.number}",
                    style: AppTheme.h6Style
                        .copyWith(fontSize: 12, color: LightColor.grey)),
                SizedBox(height: 7),
                Row(
                  //alignment: WrapAlignment.spaceBetween,
                  //runSpacing: 5,
                  //direction: Axis.horizontal,
                  children: getTagChips(model),
                ),
                SizedBox(height: 10),
              ],
            ))
          ],
        ));
  }

  List<Widget> getTagChips(CourseModel model) {
    List<Widget> list = new List();

    for (String tag in model.tags) {
      list.add(_chip(tag, LightColor.getRandomColor(), height: 5));
      list.add(SizedBox(width: 10));
    }
    list.removeLast();
    return list;
  }

  Widget _decorationContainerA(Color primaryColor, double top, double left) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: top,
          left: left,
          child: CircleAvatar(
            radius: 100,
            backgroundColor: LightColor.darkseeBlue,
            //backgroundColor: topColor,
          ),
        ),
        _smallContainer(LightColor.yellow, 40, 20),
        Positioned(
          top: -30,
          right: -10,
          child: _circularContainer(80, Colors.transparent,
              borderColor: Colors.white),
        ),
        Positioned(
          top: 110,
          right: -50,
          child: CircleAvatar(
            radius: 60,
            backgroundColor: LightColor.darkseeBlue,
            child:
                CircleAvatar(radius: 40, backgroundColor: LightColor.seeBlue),
          ),
        ),
      ],
    );
  }

  Widget _decorationContainerB() {
    return Stack(
      children: <Widget>[
        Positioned(
          top: -65,
          left: -65,
          child: CircleAvatar(
            radius: 70,
            backgroundColor: LightColor.lightOrange2,
            child: CircleAvatar(
                radius: 30, backgroundColor: LightColor.darkOrange),
          ),
        ),
        Positioned(
            bottom: -35,
            right: -40,
            child:
                CircleAvatar(backgroundColor: LightColor.yellow, radius: 40)),
        Positioned(
          top: 50,
          left: -40,
          child: _circularContainer(70, Colors.transparent,
              borderColor: Colors.white),
        ),
      ],
    );
  }

  Widget _decorationContainerC() {
    return Stack(
      children: <Widget>[
        Positioned(
          bottom: -65,
          left: -35,
          child: CircleAvatar(
            radius: 70,
            backgroundColor: Color(0xfffeeaea),
          ),
        ),
        Positioned(
            bottom: -30,
            right: -25,
            child: ClipRect(
                clipper: QuadClipper(),
                child: CircleAvatar(
                    backgroundColor: LightColor.yellow, radius: 40))),
        _smallContainer(
          Colors.yellow,
          35,
          70,
        ),
      ],
    );
  }

  Column getCourseListChildren(DocumentSnapshot document, double width, int i) {
    List<Widget> list = new List();
    var data = document.data;
    CourseModel model = CourseModel(
        name: data()['name'],
        description: data()['description'],
        rating: data()['rating'].toString(),
        author: data()['creator'],
        number: data()['length'],
        downloads: data()['downloads'],
        tags: ["One", "Two", "One", "Two"]);

    if (i % 3 == 0)
      list.add(_courceInfo(
          width, model, _decorationContainerA(Colors.redAccent, -110, -85),
          background: LightColor.seeBlue));
    else if (i % 3 == 1)
      list.add(_courceInfo(width, model, _decorationContainerB(),
          background: LightColor.darkOrange));
    else
      list.add(_courceInfo(width, model, _decorationContainerC(),
          background: LightColor.lightOrange2));

    list.add(
      Divider(
        thickness: 1,
        endIndent: 20,
        indent: 20,
      ),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: list,
    );
  }

  Widget _chip(String text, Color textColor,
      {double height = 0, bool isPrimaryCard = false}) {
    return Container(
      //alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: height),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        color: textColor.withAlpha(isPrimaryCard ? 200 : 50),
      ),
      child: Text(
        text,
        style: TextStyle(
            color: isPrimaryCard ? Colors.white : textColor, fontSize: 12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return StreamBuilder<QuerySnapshot>(
      stream: userDataController.getStreamOfCourses("downloads"),
      builder: (context, asyncSnapshot) {
        if (asyncSnapshot.hasData) {
          var documents = asyncSnapshot.data.documents;
          return ListView.builder(
            padding: EdgeInsets.all(0),
            itemCount: documents.length,
            itemBuilder: (context, index) {
              var data = documents[index].data;

              if (data()['published'] == false) return Container();
              if (contributionsOnly &
                  !userDataController.hasCreatedCourse(data()['id']))
                return Container();

              return GestureDetector(
                  onTap: () async {
                    var res = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CoursePage(data()["id"]),
                      ),
                    );
                    if (res != null && res == 1)
                      Toast.show("Course will be removed from market", context,
                          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  },
                  child: getCourseListChildren(documents[index], width, index));
            },
          );
        }
        return CircularProgressIndicator();
      },
    );
  }
}
