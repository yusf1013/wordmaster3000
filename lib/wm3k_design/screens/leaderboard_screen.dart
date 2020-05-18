import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/components/avatar/gf_avatar.dart';
import 'package:getflutter/getflutter.dart';
import 'package:wm3k/wm3k_design/helper/app_bars.dart';
import 'package:wm3k/wm3k_design/helper/buttons.dart';

class LeaderBoardPage extends StatefulWidget {
  @override
  _LeaderBoardPageState createState() => _LeaderBoardPageState();
}

class _LeaderBoardPageState extends State<LeaderBoardPage> {
  Widget appbar, body;

  @override
  void initState() {
    // TODO: implement initState
    appbar = getAppBar("Leaderboard");
    super.initState();
  }

  Widget getLeaderBoardCard(double height, double width) {
    double avatarRadius = 50, heightRatio = 0.6, widthRatio = 0.8;

    return Column(
      children: <Widget>[
        SizedBox(
          height: 40,
        ),
        ConstrainedBox(
          constraints: BoxConstraints(
              maxHeight: height * heightRatio + avatarRadius * 2,
              maxWidth: width * widthRatio),
          child: Stack(
            children: <Widget>[
              Positioned(
                top: avatarRadius * 2 * 0.85,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.white70,
                  ),
                  height: height * heightRatio,
                  width: width * widthRatio,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: avatarRadius * 0.4,
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints(
                            maxHeight:
                                heightRatio * height - avatarRadius * 0.4),
                        child: ListView.separated(
                          itemCount: 10,
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: Dot(
                                15,
                                child: Text(index.toString()),
                                color: Colors.blue,
                              ),
                              title: Text("User with name${index + 1}"),
                              trailing: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    "Score",
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                  Text("95"),
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return Divider();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: avatarRadius * 0.6,
                right: 10,
                child: GFAvatar(
                  radius: avatarRadius * 0.9,
                  backgroundImage: AssetImage('assets/avatars/av1.png'),
                  backgroundColor: Colors.white,
                ),
              ),
              Positioned(
                top: 0,
                //right: 20 + avatarRadius * 1.5 * 0.9,
                right: widthRatio * width * 0.5 - avatarRadius,
                left: widthRatio * width * 0.5 - avatarRadius,
                child: GFAvatar(
                  radius: avatarRadius,
                  backgroundImage: AssetImage('assets/avatars/av2.png'),
                  backgroundColor: Colors.white,
                ),
              ),
              Positioned(
                top: avatarRadius * 0.4,
                //right: 25 + avatarRadius * 2.7,
                left: 10,
                child: GFAvatar(
                  radius: avatarRadius * 0.9,
                  backgroundImage: AssetImage('assets/avatars/av3.png'),
                  backgroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Row getAppBar(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: GestureDetector(
              //child: Icon(Icons.arrow_back),
              child: SizedBox(),
              onTap: () {
                Navigator.pop(context);
              },
            )),
        Text(
          title,
          style: TextStyle(fontSize: 18),
        ),
        SizedBox(
          width: 40,
          height: 20,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (getBody(context)),
    );
  }

  Widget getBody(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Stack(
      children: <Widget>[
        Image(
          image: AssetImage('assets/bgs/screenbg2.png'),
          fit: BoxFit.fill,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
        ),
        Positioned(
          top: 0,
          bottom: 0,
          left: 0,
          right: 0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 50,
              ),
              appbar,
              body = getLeaderBoardCard(height, width),
              Expanded(
                child: Container(),
              ),
              ConvexAppBar(
                gradient: LinearGradient(colors: [
                  Color(0xFFBE1451),
                  Color(0xFFB31048),
                ]),
                items: [
                  TabItem(icon: Icons.shop, title: 'Games', isIconBlend: true),
                  TabItem(icon: Icons.spellcheck, title: 'Quiz'),
                  TabItem(icon: Icons.star_border, title: 'Overall'),
                  TabItem(icon: Icons.whatshot, title: 'Daily'),
                  TabItem(icon: Icons.cached, title: 'Training'),
                ],
                initialActiveIndex: 2, //optional, default as 0
                onTap: (int i) => print('click index=$i'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
