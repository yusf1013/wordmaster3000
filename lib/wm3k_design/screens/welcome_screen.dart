import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:wm3k/wm3k_design/controllers/user_controller.dart';
import 'package:wm3k/wm3k_design/screens/login.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  void initState() {
    tryAutoLogIn();
    super.initState();
  }

  void tryAutoLogIn() async {
    bool temp = await AuthController().tryAutoLogin();
    if (temp)
      Navigator.popAndPushNamed(context, 'navigationHomePage');
    else
      setState(() {
        _showSpinner = false;
      });
  }

  bool _showSpinner = true;
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _showSpinner,
      child: LoginScreen(),
    );
  }
}
