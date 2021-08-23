import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wm3k/wm3k_design/controllers/user_controller.dart';

import 'ViewPost.dart';

class search extends StatefulWidget {

  _searchState createState() => _searchState();
}

class _searchState extends State<search> {

  String serach_field;
  bool search_result = false;
  final UserDataController userDataController = UserDataController();
  TextEditingController _controller=TextEditingController();
  AuthController _authController = AuthController();

  AppBar getsearchAppBar(BuildContext context){
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
        'Search',
        style: TextStyle(
          color: Colors.black,
          fontSize: 25,
        ),
      ),
    );
  }

  Widget getPost(data,String id){
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
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
              child: Text(
                  data()['post']
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
                          if(data()['user_email'].toString() == _authController.getUser().email){
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
                            await userDataController.increaseLike(id);
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

  Widget getPostsOfSearchedUser(context){
    return Stack(
      children: <Widget>[
        Positioned(
          top: 0,
          right: 0,
          bottom: 0,
          left: 0,
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 5,left: 10,right: 10),
                child: Container(
                  child: TextField(
                    maxLength: 100,
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Search User',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      icon: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: (){
                          setState(() {
                            serach_field=_controller.text;
                          });
                          if ((serach_field != null ))
                            try {
                              serach_field=null;
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
              new Expanded(
                child: search_result == true
                    ? new ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context, i) {
                    return new Card(
                      child: new ListTile(
                        leading: new Text('data'),
                        title:new Text('data'),
                      ),
                      margin: const EdgeInsets.all(0.0),
                    );
                  },
                )
                    : new Center(
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
                      new Text('Now Data to Show'),
                    ],
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
      appBar: getsearchAppBar(context),
      body: getPostsOfSearchedUser(context),
    );
  }
}