import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final Firestore _fireStore = Firestore.instance;

class AuthController {
  static FirebaseUser _user;
  static SharedPreferences _sharedPreferences;
  bool _loaded = false;

  AuthController() {
    _loadEssentials();
  }

  void _loadEssentials() async {
    _user ??= await _auth.currentUser();
    _sharedPreferences ??= await SharedPreferences.getInstance();
    _loaded = true;
    UserDataController();
  }

  void _awaitLoad() async {
    while (!_loaded) {
      await new Future.delayed(new Duration(milliseconds: 100));
    }
  }

  bool isLoggedIn() {
    return _user != null;
  }

  void sharedShit() async {
    DocumentSnapshot doc =
        await _fireStore.collection('users').document('hunter@gmail.com').get();
    print("This is shared shit: ${doc.data['name']}");
  }

  void _writeCredentials(String email, String pass) async {
    await _awaitLoad();
    _sharedPreferences.setString('email', email);
    _sharedPreferences.setString('pass', pass);
  }

  Future<bool> singUp(String email, String password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      _writeCredentials(email, password);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> tryAutoLogin() async {
    await _awaitLoad();
    String email = _sharedPreferences.get('email');
    String pass = _sharedPreferences.get('pass');
    print("Loggin in auto $email $pass");
    return await logIn(email, pass);
  }

  Future<bool> logIn(String email, String pass) async {
    if (email != null && pass != null) {
      try {
        await _auth.signInWithEmailAndPassword(email: email, password: pass);
        return true;
      } catch (e) {}
    }
    return false;
  }
}

class UserDataController {
  FirebaseUser currentUser;

  UserDataController() {
    loadUser();
  }

  Future loadUser() async {
    currentUser ??= await _auth.currentUser();
  }
}
