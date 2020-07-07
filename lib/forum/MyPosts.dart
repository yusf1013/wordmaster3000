import 'package:flutter/material.dart';
import 'package:wm3k/forum/createpost.dart';
import 'package:wm3k/forum/news_feed.dart';

class MyPosts extends StatefulWidget {
  @override
  _MyPostsState createState() => _MyPostsState();
}

class _MyPostsState extends State<MyPosts> {
  Widget PageHead,User_Detail,body;

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
                        onPressed: () { /* Your code */ },
                      ),
                      Text("Comment"),
                    ],
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Row(
                    children: <Widget>[
                      IconButton(
                        icon: new Icon(Icons.menu),
                        onPressed: () { /* Your code */ },
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

  Widget getUser_Detail(){
    return Row(
      children: <Widget>[
        SizedBox(
          width: 10,
        ),
        Padding(
          padding: EdgeInsets.all(20),
          child: CircleAvatar(
            backgroundImage: AssetImage('assets/images/userImage.png'),
            radius: 50,
          ),
        ),
       Column(
         mainAxisAlignment: MainAxisAlignment.start,
         children: <Widget>[
            SafeArea(
              child: Text(
                "Radowan Redoy",
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

  Widget getMypostsBody(){
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
              PageHead=getAppBar("My Posts", context),
              SizedBox(
                height: 20,
              ),
              User_Detail=getUser_Detail(),
              Expanded(
                child: Container(
                  child: ListView.builder(
                     //scrollDirection: Axis.horizontal,
                      itemCount: 10,
                      itemBuilder: (BuildContext context, int index){
                         return getPost();
                      }),
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


