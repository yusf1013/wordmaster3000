import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wm3k/wm3k_design/controllers/user_controller.dart';

class viewPost extends StatefulWidget {

  String post_id;
  viewPost({Key key,@required this.post_id}) : super(key : key);
  @override
  _viewPostState createState() => _viewPostState(post_id);
}

class _viewPostState extends State<viewPost> {

  String post_id;
  String comment;
  _viewPostState(this.post_id);
  final UserDataController userDataController = UserDataController();
  TextEditingController _controller=TextEditingController();
  AuthController _authController = AuthController();

  AppBar getViewPostAppBar(BuildContext context){
    return AppBar(
      backgroundColor: Colors.white,
      leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
            color: Colors.black,
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          );
        },
      ),
      title: Text(
          'Comments',
        style: TextStyle(
          color: Colors.black,
          fontSize: 25,
        ),
      ),
    );
  }

  Widget getPostFromFirebase(BuildContext context) {
       return FutureBuilder<DocumentSnapshot>(
          //scrollDirection: Axis.horizontal,
          future: userDataController.getPostById(this.post_id),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var document = snapshot.data;
              return getPost(document);
            }
            return CircularProgressIndicator();
          },
        );
  }

  Widget getPost(data){
    print(data['user_email']);
    return Card(
      child: Container(
        //height: 230,
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text(
                data['user_email'],
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Text(new DateFormat('yyyy-MM-dd – hh:mm a').format(data['time'].toDate()).toString()),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
              child: Text(
                  data['post']
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
                      IconButton(
                        icon: new Icon(
                          Icons.volunteer_activism_rounded,
                          color: Colors.pink,),
                        onPressed: () { /* Your code */ },
                      ),
                      Text(data['like'].toString()),
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

  Widget getComments(data){
    return Card(
      elevation: 5,
      child: Container(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            ListTile(
              title: Text(
                data()['user_email'],
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Text(new DateFormat('yyyy-MM-dd – hh:mm a').format(data()['time'].toDate()).toString()),
            ),
            Padding(
              padding: EdgeInsets.all(2),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  child: Padding(
                    padding: EdgeInsets.only(left: 20) ,
                    child: Text(
                      data()['comment'],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  Widget getPostBody(context){
    return Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            right: 0,
            bottom: 0,
            left: 0,
            child: Column(
              children: <Widget>[
                getPostFromFirebase(context),
                Padding(
                  padding: EdgeInsets.only(top: 5,left: 10,right: 10),
                  child: Container(
                    child: TextField(
                      maxLength: 100,
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Comment',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        icon: IconButton(
                          icon: Icon(Icons.send),
                          onPressed: (){
                            setState(() {
                              comment=_controller.text;
                            });
                            if ((comment != null ))
                              try {
                                UserDataController()
                                    .saveComment(comment,_authController.getUser().email,this.post_id);
                                  comment=null;
                                  _controller.clear();

                              } catch (e) {
                                print('Error creating list $e');
                              }
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: StreamBuilder<QuerySnapshot>(
                      //scrollDirection: Axis.horizontal,
                      stream: userDataController.getCommentOfPosts(this.post_id),
                      builder: (context, asyncSnapshot) {
                        if (asyncSnapshot.hasData) {
                          var documents = asyncSnapshot.data.documents;
                          return ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.all(0),
                            itemCount: documents.length,
                            itemBuilder: (context, index) {
                              var data = documents[index].data;
                              var id = documents[index].id;
                              return getComments(data);
                            },
                          );
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
    return Scaffold(
      //resizeToAvoidBottomPadding: false,
      appBar: getViewPostAppBar(context),
      body: getPostBody(context),
    );
  }
}

/*
*
* */
