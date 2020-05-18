import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wm3k/analysis_classes/wordList.dart';
import 'package:wm3k/wm3k_design/models/assets_data_provider.dart';
import 'package:wm3k/wm3k_design/models/category.dart';

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
  static FirebaseUser currentUser;
  AssetNameProvider assetNameProvider = AssetNameProvider();

  UserDataController() {
    loadUser();
  }

  Future loadUser() async {
    currentUser ??= await _auth.currentUser();
  }

  Stream<QuerySnapshot> getWordLists() {
    return _fireStore
        .collection('users')
        .document('${currentUser.email}')
        .collection('wordLists')
        .orderBy('id')
        .snapshots();
  }

  Stream<QuerySnapshot> getCourses() {
    return _fireStore
        .collection('users')
        .document('${currentUser.email}')
        .collection('courses')
        .orderBy('id')
        .snapshots();
  }

  Future<WordList> getWordList(int id) async {
    var document = await _fireStore
        .collection('users')
        .document('${currentUser.email}')
        .collection('wordLists')
        .document(id.toString())
        .get();

    return WordList(document.data['name'], document.data['description'],
        document.data['words'], document.data['meanings']);
  }

  List<Category> getCategoryListForWordList(List<DocumentSnapshot> documents) {
    List<Category> list = new List();
    bool recent = true;
    for (DocumentSnapshot document in documents) {
      list.add(Category(
          imagePath: assetNameProvider.getWordListImage(recent),
          title: document.data['name'],
          wordCount: document.data['words'].length,
          time: document.data['words'].length * 2,
          text: '',
          id: document.data['id']));
      recent = false;
    }
    return list;
  }

  List<Category> getCategoryListForCourses(List<DocumentSnapshot> documents) {
    List<Category> list = new List();
    for (DocumentSnapshot document in documents) {
      list.add(Category(
          imagePath: assetNameProvider.getCourseImage(),
          title: document.data['name'],
          wordCount: document.data['words'].length,
          time: document.data['words'].length * 2,
          text: '/Day',
          id: document.data['id']));
    }
    return list;
  }

  void createWordList(String name, String description) async {
    QuerySnapshot list = await _fireStore
        .collection('users')
        .document('${currentUser.email}')
        .collection('wordLists')
        .getDocuments();

    int id = _getID(list);

    _fireStore
        .collection('users')
        .document('${currentUser.email}')
        .collection('wordLists')
        .document(id.toString())
        .setData({
      'id': id,
      'name': name,
      'description': description,
      'words': <String>[],
      'meanings': <String>[]
    });
  }

  int _getID(QuerySnapshot list) =>
      list == null || list.documents == null ? 0 : list.documents.length;
}
