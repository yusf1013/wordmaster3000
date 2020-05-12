import 'package:wm3k/wm3k_design/helper/app_bars.dart';
import 'package:wm3k/wm3k_design/helper/quad_clipper.dart';
import 'package:wm3k/wm3k_design/themes/color/light_color.dart';
import 'package:flutter/material.dart';
import '../helper/courseModel.dart';
import '../themes/market_place_theme.dart';

class MarketPage extends StatelessWidget {
  MarketPage({Key key}) : super(key: key);

  double width;

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

  Widget _courseList() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: getCourseListChildren(),
      ),
    );
  }

  List<Widget> getCourseListChildren() {
    List<Widget> list = new List();
    for (int i = 0; i < CourseList.list.length; i++) {
      CourseModel model = CourseList.list[i];

      if (i % 3 == 0)
        list.add(_courceInfo(
            model, _decorationContainerA(Colors.redAccent, -110, -85),
            background: LightColor.seeBlue));
      else if (i % 3 == 1)
        list.add(_courceInfo(model, _decorationContainerB(),
            background: LightColor.darkOrange));
      else
        list.add(_courceInfo(CourseList.list[2], _decorationContainerC(),
            background: LightColor.lightOrange2));

      list.add(
        Divider(
          thickness: 1,
          endIndent: 20,
          indent: 20,
        ),
      );
    }
    list.removeLast();

    /*list = [
      _courceInfo(CourseList.list[0],
          _decorationContainerA(Colors.redAccent, -110, -85),
          background: LightColor.seeBlue),
      Divider(
        thickness: 1,
        endIndent: 20,
        indent: 20,
      ),
      _courceInfo(CourseList.list[1], _decorationContainerB(),
          background: LightColor.darkOrange),
      Divider(
        thickness: 1,
        endIndent: 20,
        indent: 20,
      ),
      _courceInfo(CourseList.list[2], _decorationContainerC(),
          background: LightColor.lightOrange2),
    ];*/

    return list;
  }

  Widget _card(
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

  Widget _courceInfo(CourseModel model, Widget decoration, {Color background}) {
    return Container(
        height: 170,
        width: width - 20,
        child: Row(
          children: <Widget>[
            AspectRatio(
              aspectRatio: .7,
              child: _card(primaryColor: background, backWidget: decoration),
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
                      CircleAvatar(
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
                Text(model.description,
                    style: AppTheme.h6Style.copyWith(
                        fontSize: 12, color: LightColor.extraDarkPurple)),
                SizedBox(height: 15),
                Row(
                  children: getTagChips(model),
                )
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
            _bottomIcons(Icons.shopping_cart, "Market"),
            _bottomIcons(Icons.list, "Memes"),
          ],
          onTap: (index) {
            /*Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => HomePage()));*/
          },
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: HeaderAppBar(),
            ),
            Expanded(
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
            ),
          ],
        ));
  }
}
