import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wm3k/wm3k_design/controllers/user_controller.dart';

import 'ViewPost.dart';

class activity extends StatefulWidget {

  _activityState createState() => _activityState();
}

class _activityState extends State<activity> {

  final UserDataController userDataController = UserDataController();
  TextEditingController _controller=TextEditingController();
  AuthController _authController = AuthController();
  List<bool> isSelected;
  bool on_your_post = true;

  @override
  void initState() {
    isSelected = [true, false];
    super.initState();
  }

  AppBar getactivityAppBar(BuildContext context){
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
        'Activity',
        style: TextStyle(
          color: Colors.black,
          fontSize: 25,
        ),
      ),
    );
  }

    Widget getReceiverActivity(data){
      return Padding(
        padding: EdgeInsets.all(4),
        child: GestureDetector(
          onTap: () =>{
          Navigator.push(
            context,
              MaterialPageRoute(
                builder: (context) =>
                viewPost(post_id: data()['parent_id'].toString())),
              )
          },
          child: Card(
            elevation: 12,
            child: Container(
              //height: 230,
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text(
                      new DateFormat('yyyy-MM-dd – hh:mm a').format(data()['time'].toDate()).toString(),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text(
                        data()['author'] + 'commented on your post'
                    ),
                  ),
                ],
              ),
              //color: Colors.red,
            ),
          ),
        ),
      );
    }

  Widget getBody(){
    return new Expanded(
        child: on_your_post == true
        ? Container(
            child: StreamBuilder<QuerySnapshot>(
              //scrollDirection: Axis.horizontal,
              stream: userDataController.getActivitiesbyReceiver(_authController.getUser().email),
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
                        return getReceiverActivity(data);
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
                              new Text('No data to Show',
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
          )
            : Container(child: StreamBuilder<QuerySnapshot>(
          //scrollDirection: Axis.horizontal,
          stream: userDataController.getActivitiesbyAuthor(_authController.getUser().email),
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
                    // return getPost(context,data,id);
                    return Text('okkk');
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
                          new Text('No Activity to Show',
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
        ))
    );
  }

  Widget getPostsOfactivityedUser(context){
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
                padding: const EdgeInsets.only(top: 15.0),
                child: ToggleButtons(
                  borderColor: Colors.black,
                  fillColor: Colors.green,
                  borderWidth: 2,
                  selectedBorderColor: Colors.black,
                  selectedColor: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'On Your Feed',
                        style: TextStyle(fontSize: 19,fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Your Activity',
                        style: TextStyle(fontSize: 19,fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                  onPressed: (int index) {
                    setState(() {
                      for (int i = 0; i < isSelected.length; i++) {
                        if(i==index){
                          isSelected[i] = true;
                          if(i==0){
                            on_your_post = true;
                          }else{
                            on_your_post = false;
                          }
                        }else{
                          isSelected[i] = false;
                        }
                      }
                    });
                  },
                  isSelected: isSelected,
                ),
              ),
              getBody(),
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
      appBar: getactivityAppBar(context),
      body: getPostsOfactivityedUser(context),
    );
  }
}