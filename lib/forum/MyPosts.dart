import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wm3k/forum/createpost.dart';
import 'package:wm3k/forum/news_feed.dart';
import 'package:wm3k/wm3k_design/controllers/user_controller.dart';

import 'ViewPost.dart';

class MyPosts extends StatefulWidget {
  @override
  _MyPostsState createState() => _MyPostsState();
}

class _MyPostsState extends State<MyPosts> {
  AuthController _authController = AuthController();
  final UserDataController userDataController = UserDataController();


  Widget PageHead, User_Detail, body;

  Widget getPost(context,data,String id) {
    return Card(
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
              subtitle: Text(new DateFormat('yyyy-MM-dd – hh:mm a').format(data()['time'].toDate()).toString()),
              trailing:  IconButton(
                icon: const Icon(Icons.delete),
                tooltip: 'Delete',
                onPressed: () => showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Delete Post'),
                    content: const Text('Are You Sure , you want to delete this?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'Cancel'),
                        child: Text('NO',style: TextStyle(color: Colors.green.withOpacity(0.8)),),
                      ),
                      TextButton(
                          onPressed: () => {
                            userDataController.deletePost(id),
                            Navigator.pop(context, 'Ok')
                          },
                        child: Text('Yes',style: TextStyle(color: Colors.red.withOpacity(0.8)),),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
              child: Text(
                data()['post']
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
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
                        onPressed: () { showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            content: const Text('You can not like your own post'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => {
                                  Navigator.pop(context,'Cancel')
                                },
                                child: Text('Ok',style: TextStyle(color: Colors.green.withOpacity(0.8)),),
                              ),
                            ],),
                          );
                        },
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
                        icon: new Icon(Icons.comment,color: Colors.blue),
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
              height: 5,
            ),
          ],
        ),
        //color: Colors.red,
      ),
    );
  }

  Row getAppBar(String title, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: GestureDetector(
              child: Icon(Icons.arrow_back),
              //child: SizedBox(),
              onTap: () {
                Navigator.pop(context);
              },
            )),
        Text(
          title,
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontStyle: FontStyle.italic,
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

  Widget getUser_Detail() {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 50,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SafeArea(
              child: Text(
                _authController.getUser().email,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            /*RaisedButton(
             onPressed: () {},
             child: const Text('Post Alert', style: TextStyle(fontSize: 20)),
           ),*/
            RaisedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => createPost()),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Create Post',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(
                    Icons.create,
                    color: Colors.black,
                  )
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget getMypostsBody() {
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
          left: 0,
          bottom: 0,
          right: 0,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 50,
              ),
              PageHead = getAppBar("My Posts", context),
              SizedBox(
                height: 20,
              ),
              User_Detail = getUser_Detail(),
              Expanded(
                child: Container(
                  child: StreamBuilder<QuerySnapshot>(
                    //scrollDirection: Axis.horizontal,
                    stream: userDataController.getPostsByemail(_authController.getUser().email),
                    builder: (context, asyncSnapshot) {
                      if (asyncSnapshot.hasData) {
                        var documents = asyncSnapshot.data.documents;
                        if(documents.length > 0){
                          return ListView.builder(
                            padding: EdgeInsets.all(0),
                            itemCount: documents.length,
                            itemBuilder: (context, index) {
                              var data = documents[index].data;
                              var id = documents[index].id;
                              return getPost(context,data,id);
                            },
                          );
                        }else{
                          return new ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.all(0),
                            itemCount: 1,
                            itemBuilder: (context, index) {
                              return new Center(
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 100,
                                    ),
                                    Container(
                                      margin: EdgeInsets.all(20),
                                      width: 200,
                                      height: 200,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            image: AssetImage("assets/images/nodata.jpg"),
                                            fit: BoxFit.fill
                                        ),
                                      ),
                                    ),
                                    new Text('No Posts to Show',
                                      style: TextStyle(
                                          color: Colors.black.withOpacity(0.6),
                                          fontSize: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        }
                      }
                      return CircularProgressIndicator();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return getMypostsBody();
  }
}
