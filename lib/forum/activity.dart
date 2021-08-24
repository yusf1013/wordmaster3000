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

  Widget getBody(){
    return new Expanded(
        child: on_your_post == true
        ? new Container(child: Text('On you Post')) : new Container(child: Text('Your activity'))
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
                        'On Your Post',
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