import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class viewPost extends StatefulWidget {

  String user_name;
  viewPost({Key key,@required this.user_name}) : super(key : key);
  @override
  _viewPostState createState() => _viewPostState(user_name);
}

class _viewPostState extends State<viewPost> {

  String user_name;
  _viewPostState(this.user_name);

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
          user_name,
        style: TextStyle(
          color: Colors.black,
          fontSize: 25,
        ),
      ),
    );
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
                      IconButton(
                        icon: new Icon(Icons.thumb_up),
                        onPressed: () { /* Your code */ },
                      ),
                      Text("Like"),
                    ],
                  ),
                  SizedBox(
                    width: 38,
                  ),
                  Row(
                    children: <Widget>[
                      IconButton(
                        icon: new Icon(Icons.comment),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    viewPost(user_name: "Radowan Redoy")),
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

  Widget getComments(){
    return Card(
      elevation: 5,
      child: Container(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            ListTile(
              leading: CircleAvatar(),
              title: Text(
                "Radowan Redoy",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Text("time of posting"),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                  "You should check out word master 3000 for your prbolem"
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

  Widget getPostBody(){
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          getPost(),
          Padding(
            padding: EdgeInsets.only(top: 5,left: 10,right: 10),
            child: Container(
              child: TextField(
                maxLength: 50,
                decoration: InputDecoration(
                  hintText: 'Comment',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  icon: IconButton(
                    icon: Icon(Icons.send),
                    onPressed: (){

                    },
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            //child: Text("Hello"),
            child: ListView.builder(
              //scrollDirection: Axis.horizontal,
                itemCount: 10,
                itemBuilder: (BuildContext context, int index){
                  return getComments();
                }),
          ),
        ],
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomPadding: false,
      appBar: getViewPostAppBar(context),
      body: getPostBody(),
    );
  }
}

/*
*
* */
