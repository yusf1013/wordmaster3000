import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class createPost extends StatefulWidget {
  @override
  _createPostState createState() => _createPostState();
}

AppBar getCreatePostAppBar(BuildContext context){
  return AppBar(
    backgroundColor: Color(0xCFBE1781),
    leading: Builder(
      builder: (BuildContext context) {
        return IconButton(
          color: Colors.white,
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        );
      },
    ),
    title: const Text(
      "Create Post",
      style: TextStyle(
        color: Colors.white,
        fontSize: 25,
      ),
    ),
    actions: <Widget>[
      IconButton(
          icon: Icon(Icons.cancel),
          onPressed: (){
            Navigator.pop(context);
          }
      )
    ],
  );
}

class _createPostState extends State<createPost> {
  TextEditingController _controller=TextEditingController();
  String post="";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getCreatePostAppBar(context),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(12),
                child: Text(post)
            ),
            Container(
              child: TextField(
                maxLength: 200,
                decoration: InputDecoration(
                    hintText: 'Write A Post',
                ),
                controller: _controller,
              ),
              padding: EdgeInsets.all(32),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(
                  width: 15,
                ),
                RaisedButton(
                  onPressed: () {
                    setState(() {
                      post=_controller.text;
                    });
                  },
                  elevation: 10,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Preview',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                RaisedButton(
                  onPressed: () {

                  },
                  elevation: 10,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Post',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
