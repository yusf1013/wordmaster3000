import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:flutter/cupertino.dart';
import 'package:wm3k/wm3k_design/helper/app_bars.dart';

class Newsfeed extends StatefulWidget {
  @override
  _NewsfeedState createState() => _NewsfeedState();
}

class _NewsfeedState extends State<Newsfeed> {

  Widget appbar, body;

  @override
  void initState() {
    // TODO: implement initState
    //appbar = getAppBar("Leaderboard");
    super.initState();
  }

  Widget getPost(){
  return Card(
    child: Container(
      //height: 230,
      child: Column(
        children: <Widget>[
          ListTile(
            leading: CircleAvatar(),
            title: Text(
              "Radowan Redoy",
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Text("time of posting"),
            trailing: Icon(Icons.more_vert),
            onTap: (){

            },
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
            child: Text(
                "How do you do? I am fine what about you? How is your day going. I am having a normal day"
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(12, 12, 12, 8),
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 15,
                ),
                Row(
                  children: <Widget>[
                    Icon(Icons.thumb_up),
                    SizedBox(
                      width: 15,
                    ),
                    Text("Like"),
                  ],
                ),
                SizedBox(
                  width: 55,
                ),
                Row(
                  children: <Widget>[
                    Icon(Icons.comment),
                    SizedBox(
                      width: 15,
                    ),
                    Text("Comment"),
                  ],
                ),
                SizedBox(
                  width: 35,
                ),
                Row(
                  children: <Widget>[
                    Icon(Icons.menu),
                    SizedBox(
                      width: 15,
                    ),
                    Text("More"),
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
        ],
      ),
      //color: Colors.red,
    ),
  );
}


  Row getAppBar(String title,BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: GestureDetector(
              child: Icon(Icons.menu),
              //child: SizedBox(),
              onTap: () {
                Navigator.pop(context);
              },
            )),
        Text(
          title,
          style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(
          width: 40,
          height: 20,
        ),
      ],
    );
  }

  Widget setBodyForForum(){
    return Expanded(
      child: Container(
        child: ListView.builder(
          //scrollDirection: Axis.horizontal,
            itemCount: 10,
            itemBuilder: (BuildContext context, int index){
              return getPost();
            }),
      ),
    );
  }


  Widget getBody(BuildContext context){
    return Stack(
      children: <Widget>[
        Image(
          image: AssetImage('assets/bgs/screenbg5.png'),
          fit: BoxFit.fill,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
        ),
        Positioned(
          top: 0,
          right: 0,
          bottom: 0,
          left: 0,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 50,
              ),
              appbar=getAppBar("Word Master 3000", context),
              SizedBox(
                height: 15,
              ),
              //body=getPost(),
              body=setBodyForForum(),
              ConvexAppBar(
                gradient: LinearGradient(colors: [
                  Color(0xBBBE1781),
                  Color(0xFFB31048),
                ]),
                items: [
                  TabItem(icon: Icons.create, title: 'create', isIconBlend: true),
                  TabItem(icon: Icons.search, title: 'search'),
                  TabItem(icon: Icons.forum,title: 'forum'),
                  TabItem(icon: Icons.person, title: 'My_Post'),
                  TabItem(icon: Icons.bookmark, title: 'Market'),
                ],
                initialActiveIndex: 2, //optional, default as 0
                onTap: (int i) {
                  print('click index=$i');
                  if(i==1){
                    setState(() {
                      print("in seach");
                      //body=HeaderAppBar();
                    });
                  }
                  else if(i==2){
                    setState(() {
                      //body=setBodyForForum();
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
       /* appBar: AppBar(
        backgroundColor: Color(0xBBBE1781),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: (){
             // Navigator.pop(context);
            },
          ),
        ],
        title: Text(
            "Word Master 3000",
            style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w500
            ),
        ),
      ),*/
        body: getBody(context),
    );
  }
}

