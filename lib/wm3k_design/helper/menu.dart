import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MenuForWidgets extends StatefulWidget {
  final Widget child;
  final Widget menu;

  MenuForWidgets({this.child, this.menu});

  @override
  _MenuForWidgetsState createState() => _MenuForWidgetsState();
}

class _MenuForWidgetsState extends State<MenuForWidgets> {
  bool showMenu = false;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        widget.child,
        Container(
          color: Colors.red,
          height: 100,
          width: 100,
        ),
      ],
    );
  }
}
