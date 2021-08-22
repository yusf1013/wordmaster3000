import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:flutter/cupertino.dart';
import 'package:wm3k/forum/MyPosts.dart';
import 'package:wm3k/forum/ViewPost.dart';
import 'package:wm3k/forum/createpost.dart';
import 'package:wm3k/wm3k_design/controllers/user_controller.dart';
import 'package:wm3k/wm3k_design/helper/app_bars.dart';

class Newsfeed extends StatefulWidget {
  @override
  _NewsfeedState createState() => _NewsfeedState();
}

class _NewsfeedState extends State<Newsfeed> {
  Widget appbar, body;
  final UserDataController userDataController = UserDataController();
  AuthController _authController = AuthController();

  @override
  void initState() {
    // TODO: implement initState
    //appbar = getAppBar("Leaderboard");
    super.initState();
  }
  
  Widget getTrailer(String email){
    if(_authController.getUser().email == email){
      return Icon(Icons.delete);
    }
    return null;
  }

  Widget getPost(BuildContext context, data,String id) {
    return Card(
      elevation: 5,
      child: Container(
        //height: 230,
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text(
                data()['user_email'],
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Text(
                  new DateFormat('yyyy-MM-dd – hh:mm a').format(data()['time'].toDate()).toString(),
              ),
              trailing: getTrailer(data()['user_email']),
              onTap: () {},
            ),
            Padding(
            padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
              child: Text(
                  data()['post']),
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
                      IconButton(
                        icon: new Icon(
                          Icons.volunteer_activism_rounded,
                          color: Colors.pink,),
                        onPressed: () {/* Your code */},
                      ),
                      Text(data()['like'].toString()),
                    ],
                  ),
                  SizedBox(
                    width: 38,
                  ),
                  Row(
                    children: <Widget>[
                      IconButton(
                        icon: new Icon(Icons.comment,
                            color: Colors.blue),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    viewPost(post_id: id)),
                          );
                        },
                      ),
                      Text("Comment"),
                    ],
                  ),
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

  Row getAppBar(String title, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
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

  Widget setBodyForForum(BuildContext context) {
    return Expanded(
      child: Container(
        child: StreamBuilder<QuerySnapshot>(
            //scrollDirection: Axis.horizontal,
        stream: userDataController.getPosts(),
        builder: (context, asyncSnapshot) {
         if (asyncSnapshot.hasData) {
            var documents = asyncSnapshot.data.documents;
            return ListView.builder(
               padding: EdgeInsets.all(0),
               itemCount: documents.length,
               itemBuilder: (context, index) {
                  var data = documents[index].data;
                  var id = documents[index].id;
                  return getPost(context,data,id);
                },
            );
         }
         return CircularProgressIndicator();
         },
        ),
     ),
    );
  }

  Widget getBody(BuildContext context) {
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
                height: 43,
              ),
              appbar = getAppBar("Word Master 3000", context),
              SizedBox(
                height: 15,
              ),
              //body=getPost(),
              body = setBodyForForum(context),
              ConvexAppBar(
                gradient: LinearGradient(colors: [
                  Color(0xBBBE1781),
                  Color(0xFFB31048),
                ]),
                items: [
                  TabItem(
                      icon: Icons.create, title: 'create', isIconBlend: true),
                  TabItem(icon: Icons.search, title: 'search'),
                  TabItem(icon: Icons.forum, title: 'forum'),
                  TabItem(icon: Icons.person, title: 'MyPost'),
                  TabItem(icon: Icons.notifications, title: 'notify'),
                ],
                initialActiveIndex: 2, //optional, default as 0
                style: TabStyle.fixedCircle,
                onTap: (int i) {
                  print('click index=$i');
                  if (i == 0) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => createPost()),
                    );
                  } else if (i == 1) {
                    setState(() {
                      print("in seach");
                      //body=HeaderAppBar();
                    });
                  } else if (i == 3) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyPosts()),
                    );
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
      body: getBody(context),
    );
  }
}
