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
  String receiver;
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

  Widget getTrailer(context,String email,String comment_id){
    if(_authController.getUser().email == email){
      return   IconButton(
        icon: const Icon(Icons.delete),
        tooltip: 'Delete',
        onPressed: () => showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Delete Comment'),
            content: const Text('Are You Sure , you want to delete this?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => {
                  Navigator.pop(context,'Cancel')
                },
                child: Text('NO',style: TextStyle(color: Colors.green.withOpacity(0.8)),),
              ),
              TextButton(
                onPressed: () => {
                  userDataController.deleteComment(this.post_id,comment_id),
                  Navigator.pop(context,'Ok')
                },
                child: Text('Yes',style: TextStyle(color: Colors.red.withOpacity(0.8)),),
              ),
            ],
          ),
        ),
      );
    }
    return null;
  }

  Widget getPostFromFirebase(BuildContext context) {
       return FutureBuilder<DocumentSnapshot>(
          //scrollDirection: Axis.horizontal,
          future: userDataController.getPostById(this.post_id),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var document = snapshot.data;
              this.receiver = document['user_email'];
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
                        onPressed: () async {
                          if(data['user_email'].toString() == _authController.getUser().email){
                            showDialog<String>(
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
                                ],
                              ),
                            );
                          }else{
                            await userDataController.increaseLike(this.post_id);
                            setState(() {});
                          }
                        },
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

  Widget getComments(data,String comment_id){
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
              trailing: getTrailer(context, data()['user_email'], comment_id),
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
                                    .saveComment(comment,_authController.getUser().email,this.post_id,this.receiver);
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
                          if(documents.length > 0){
                            return ListView.builder(
                              shrinkWrap: true,
                              padding: EdgeInsets.all(0),
                              itemCount: documents.length,
                              itemBuilder: (context, index) {
                                var data = documents[index].data;
                                var comment_id = documents[index].id;
                                return getComments(data,comment_id);
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
                                      Container(
                                        margin: EdgeInsets.all(20),
                                        width: 150,
                                        height: 150,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                              image: AssetImage("assets/images/nodata.jpg"),
                                              fit: BoxFit.fill
                                          ),
                                        ),
                                      ),
                                      new Text('No Comments to Show'),
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
