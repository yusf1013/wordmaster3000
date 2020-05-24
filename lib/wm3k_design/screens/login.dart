import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wm3k/wm3k_design/controllers/user_controller.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class LoginScreen extends StatelessWidget {
  Duration get loginTime => Duration(milliseconds: 2250);
  final AuthController userController = AuthController();

  //TODO this function checks login. Check the next functions too

  Future<String> _logIn(LoginData data) async {
    print(data.name);
    print(data.password);
    /*try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: data.name, password: data.password);
      if (result != null) return null;
    } catch (e) {
      return e.toString();
    }
    return 'Sign in failed';*/
    return (await userController.logIn(data.name, data.password)
        ? null
        : "Error loggin in!");
  }

  Future<String> _signUp(LoginData data) async {
    print(data.name);
    print(data.password);
    /*try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: data.name, password: data.password);

      return null;
    } catch (e) {
      print(e);
      return "Error signing in";
    }*/
    return (await userController.signUp(data.name, data.password))
        ? null
        : "Error signing in";
  }

  Future<String> _recoverPassword(String name) {
    print('Name: $name');
    return Future.delayed(loginTime).then((_) {
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        FlutterLogin(
          title: 'Word Master 3000',
          theme: LoginTheme(
            titleStyle: GoogleFonts.spicyRice(
              textStyle: TextStyle(color: Colors.white, fontSize: 35),
            ),
          ),
          logo: 'assets/images/wmicon.png',
          logoTag: "logo",
          onLogin: _logIn,
          onSignup: _signUp,
          onSubmitAnimationCompleted: () {
            //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => NavigationHomeScreen(),),);
            //LoginController.logIn();
            _guestLogIn(context);
          },
          onRecoverPassword: _recoverPassword,
        ),
        Positioned(
          bottom: 70,
          right: 0,
          child: GestureDetector(
            onTap: () {
              _guestLogIn(context);
            },
            child: Container(
              //height: 100,
              //width: 100,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10.0, // soften the shadow
                    spreadRadius: 4.0, //extend the shadow
                    offset: Offset(
                      5.0, // Move to right 10  horizontally
                      5.0, // Move to bottom 10 Vertically
                    ),
                  )
                ],
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    bottomLeft: Radius.circular(40)),
                //border: Border.all(width: 3, color: Colors.green, style: BorderStyle.solid),
              ),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  children: <Widget>[
                    Text(
                      "Guest login",
                      style: TextStyle(
                          inherit: false,
                          color: Colors.black87,
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(Icons.play_arrow),
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  void _guestLogIn(BuildContext context) {
    //_auth.signInAnonymously();
    Navigator.popAndPushNamed(context, 'navigationHomePage');
    //UserController().sharedShit();
  }
}
