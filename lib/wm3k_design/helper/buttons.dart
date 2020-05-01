import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final Color startColor, endColor;
  final double height, width;
  final String text;

  GradientButton(
      {this.startColor = const Color(0xff374ABE),
      this.endColor = const Color(0xff64B6FF),
      this.height = 40,
      this.text = 'Login',
      this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      child: RaisedButton(
        onPressed: () {},
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
        padding: EdgeInsets.all(0.0),
        child: Ink(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [startColor, endColor],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(30.0)),
          child: Container(
            constraints: BoxConstraints(maxWidth: 300.0, minHeight: height),
            alignment: Alignment.center,
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}

class Dot extends StatelessWidget {
  final double radius, borderWidth;
  final Color color;
  final Widget child;

  Dot(this.radius,
      {this.borderWidth = 0, this.color = Colors.black12, this.child});

  Padding getDot() {
    return Padding(
      padding: EdgeInsets.all(7),
      child: Container(
        height: radius * 2,
        width: radius * 2,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          color: color,
          border: borderWidth == 0 ? null : Border.all(width: borderWidth),
        ),
        child: Center(child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return getDot();
  }
}
