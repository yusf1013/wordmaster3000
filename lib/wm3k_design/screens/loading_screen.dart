import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:wm3k/analysis_classes/wordList.dart';
import 'package:wm3k/wm3k_design/screens/my_word_list.dart';

class LoadingScreen extends StatefulWidget {
  final Function getChild, asyncFunction;

  LoadingScreen({this.getChild, this.asyncFunction});

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  Widget child;
  void initState() {
    child = Container(
      color: Colors.white,
    );
    asyncFunction();
    super.initState();
  }

  void asyncFunction() async {
    var data = await widget.asyncFunction();
    print("Got the data ${data.runtimeType}");
    if (mounted)
      setState(() {
        child = widget.getChild(data);
        loading = false;
      });
  }

  bool loading = true;
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: loading,
      child: child,
    );
  }
}
