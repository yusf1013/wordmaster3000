import 'package:wm3k/wm3k/screens/navigation_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/loginController.dart';

//TODO remove this shit
const users = const {
  'dribbble@gmail.com': '12345',
  'hunter@gmail.com': 'hunter',
};

class LoginScreen extends StatelessWidget {
  Duration get loginTime => Duration(milliseconds: 2250);

  //TODO this function checks login. Check the next functions too
  Future<String> _authUser(LoginData data) {
    print('Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(data.name)) {
        return 'Username not exists';
      }
      if (users[data.name] != data.password) {
        return 'Password does not match';
      }
      return null;
    });
  }

  Future<String> _recoverPassword(String name) {
    print('Name: $name');
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(name)) {
        return 'Username not exists';
      }
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
          onLogin: _authUser,
          onSignup: _authUser,
          onSubmitAnimationCompleted: () {
            //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => NavigationHomeScreen(),),);
            LoginController.logIn();
            Navigator.popAndPushNamed(context, 'navigationHomePage');
          },
          onRecoverPassword: _recoverPassword,
        ),
        Positioned(
          bottom: 70,
          right: 0,
          child: GestureDetector(
            onTap: () {
              Navigator.popAndPushNamed(context, 'navigationHomePage');
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
}
