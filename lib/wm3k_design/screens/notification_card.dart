import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/components/button/gf_button.dart';
import 'package:getflutter/getflutter.dart';

class NotificationCard extends StatelessWidget {
  final double height, width;
  final String headerText, h2Text, bodyText, authorName, buttonText;
  final Function onTap;

  NotificationCard({
    this.height = 510,
    this.width = 300,
    this.headerText = "Memorization",
    this.h2Text = "You have memorized 9/10 words!",
    this.bodyText =
        "\"You don't have to be great to start, but you have to start to be great.\"",
    this.authorName = "- Zig Ziglar",
    this.buttonText = "Proceed to round 2",
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
          maxHeight: height,
          maxWidth: width,
          minHeight: height,
          minWidth: width),
      child: Stack(
        children: <Widget>[
          Positioned(
              bottom: 0,
              //bottom: height / 2.0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.yellow[700],
                  borderRadius: new BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                ),
                height: height,
                width: width,
              )),
          /*Positioned(
              top: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: new BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                    bottomLeft: Radius.elliptical(100, 60),
                    bottomRight: Radius.elliptical(150, 60),
                  ),
                ),
                height: height / 1.5,
                width: width,
              )),*/
          Positioned(
              top: 0,
              child: ClipRRect(
                borderRadius: new BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
                child: ClipOval(
                  clipper: CustomRect(),
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                      ),
                      height: height / 1.6,
                      width: width,
                    ),
                  ),
                ),
              )),
          Positioned(
              bottom: 0,
              //bottom: height / 2.0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
                height: height,
                width: width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: height * 0.035),
                      child: Text(
                        headerText,
                        style: TextStyle(
                          inherit: false,
                          color: Colors.yellow[700],
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: height * 0.03),
                      child: Text(
                        "Well Done!",
                        style: TextStyle(
                          inherit: false,
                          color: Colors.white,
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: height * 0.025),
                      child: Icon(
                        Icons.check_circle,
                        size: 100,
                        color: Colors.green[700],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(top: height * 0.025),
                            child: Center(
                              child: Text(
                                h2Text,
                                style: TextStyle(
                                  inherit: false,
                                  color: Colors.white,
                                  fontSize: 27,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: height * 0.075, left: 30, right: 30),
                      child: Text(
                        bodyText,
                        style: TextStyle(
                          inherit: false,
                          color: Colors.black87,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 30),
                          child: Text(
                            authorName,
                            style: TextStyle(
                              inherit: false,
                              color: Colors.black87,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 25),
                      child: GFButton(
                        elevation: 5,
                        buttonBoxShadow: true,
                        boxShadow: BoxShadow(
                          color: Colors.black54,
                          blurRadius:
                              5.0, // has the effect of softening the shadow
                          spreadRadius:
                              0.0, // has the effect of extending the shadow
                          offset: Offset(
                            3.5, // horizontal, move right 10
                            3.5, // vertical, move down 10
                          ),
                        ),
                        onPressed: onTap,
                        shape: GFButtonShape.pills,
                        text: buttonText,
                        size: 45,
                        textStyle: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                        color: Colors.black87,
                      ),
                    )
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

class CustomRect extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    Rect rect = Rect.fromLTRB(
        -size.width * 0.3, -50.0, size.width * 1.275, size.height);
    return rect;
  }

  @override
  bool shouldReclip(CustomRect oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}
