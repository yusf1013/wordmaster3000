import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wm3k/analysis_classes/wordList.dart';
import 'package:wm3k/dbConnection/connector.dart';
import 'package:wm3k/wm3k_design/controllers/quiz_controller.dart';
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
    _User();
  }

  void _awaitLoad() async {
    while (!_loaded) {
      await new Future.delayed(new Duration(milliseconds: 100));
    }
  }

  void _writeCredentials(String email, String pass) async {
    await _awaitLoad();
    _sharedPreferences.setString('email', email);
    _sharedPreferences.setString('pass', pass);
  }

  bool isLoggedIn() {
    return _user != null;
  }

  Future<bool> signUp(String email, String password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      _writeCredentials(email, password);

      _loadEssentials();
      UserDataController().initializeUser();
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
        AuthResult result = await _auth.signInWithEmailAndPassword(
            email: email, password: pass);
        print("Auth result is: ${result.toString()}");
        if (result == null) return false;
        _writeCredentials(email, pass);
        await _loadEssentials();
        UserDataController().initializeUser();
        return true;
      } catch (e) {
        print(e);
      }
    }
    return false;
  }

  void signOut() {
    _writeCredentials("X", "X");
    _auth.signOut();
    _user = null;
    _loaded = false;

    //UserDataController._userData = null;
  }

  static FirebaseUser getCurrentUser() => _user;
}

class UserDataController {
  FirebaseUser _currentUser;
  _User user;
  static final UserDataController _singleton = UserDataController._internal();

  factory UserDataController() {
    return _singleton;
  }

  UserDataController._internal() {
    initializeUser();
  }

  void initializeUser() {
    _currentUser = AuthController.getCurrentUser();
    user = _User();
    user.initWordListStream(getStreamOfWordLists());
    user.initWrongOptions();
  }

  AssetNameProvider assetNameProvider = AssetNameProvider();

  Map getOptions(String ans) {
    return QuizController(user.wrongOptions).getOptions(ans);
  }

  Stream<QuerySnapshot> getStreamOfWordLists() {
    return _fireStore
        .collection('users')
        .document('${_currentUser.email}')
        .collection('wordLists')
        .orderBy('id')
        .snapshots();
  }

  Stream<QuerySnapshot> getCourses() {
    return _fireStore
        .collection('users')
        .document('${_currentUser.email}')
        .collection('courses')
        .orderBy('id')
        .snapshots();
  }

  WordList getWordList(int id) {
    /*var document = await _fireStore
        .collection('users')
        .document('${_currentUser.email}')
        .collection('wordLists')
        .document(id.toString())
        .get();

    return await getWordListFromDoc(document);*/
    return user.getWordList(id);
  }

  /*Future<WordList> getWordListFromDoc(DocumentSnapshot document) async {
    QuerySnapshot words =
        await document.reference.collection('words').getDocuments();

    List<FireBaseSubMeaning> list = List();
    for (DocumentSnapshot word in words.documents)
      list.add(FireBaseSubMeaning(word['meaningID'], word['subMeaning'],
          word['word'], word['examples'], word['subMeaningIndex']));

    return WordList(document.data['name'], document.data['description'], list,
        document.data['id']);
  }*/

  List<WordList> getAllWordLists() {
    //if(_userData.allWordLists == null)

    /*var documents = await _fireStore
        .collection('users')
        .document('${_currentUser.email}')
        .collection('wordLists')
        .getDocuments();

    List<WordList> list = new List();

    for (DocumentSnapshot document in documents.documents) {
      list.add(await getWordListFromDoc(document));
    }
    //_userData.allWordLists = list;

    //return _userData.allWordLists;
    return list;*/
    return user.wordLists;
  }

  List<Category> getCategoryListForWordList(List<DocumentSnapshot> documents) {
    List<Category> list = new List();
    bool recent = true;
    for (DocumentSnapshot document in documents) {
      list.add(Category(
          imagePath: assetNameProvider.getWordListImage(recent),
          title: document.data['name'],
          wordCount: document.data['length'],
          time: document.data['length'] * 2,
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

  void addWordToList(
      int id, String word, Meaning meaning, bool selected, int index) async {
    DocumentReference ref = await _fireStore
        .collection('users')
        .document('${_currentUser.email}')
        .collection('wordLists')
        .document(id.toString());
    DocumentSnapshot document = await ref.get();

    if (selected) {
      ref
          .collection('words')
          .document(meaning.id.toString() + "," + index.toString())
          .setData({
        'meaningID': meaning.id.toString(),
        'subMeaning': meaning.subMeaning[index].subMeaning,
        'subMeaningIndex': index,
        'word': word,
        'examples': meaning.subMeaning[index].examples
      });
      int length = document.data['length'] + 1;
      ref.updateData({'length': length});
    } else {
      ref
          .collection('words')
          .document(meaning.id.toString() + "," + index.toString())
          .delete();
      int length = document.data['length'] - 1;
      ref.updateData({'length': length});
    }
  }

  void createWordList(String name, String description) async {
    QuerySnapshot list = await _fireStore
        .collection('users')
        .document('${_currentUser.email}')
        .collection('wordLists')
        .getDocuments();

    int id = _getID(list);

    _fireStore
        .collection('users')
        .document('${_currentUser.email}')
        .collection('wordLists')
        .document(id.toString())
        .setData({
      'id': id,
      'name': name,
      'description': description,
      'length': 0,
      //'words': <String>[],
      //'meanings': <String>[]
    });
    DocumentReference d = await _fireStore
        .collection('users')
        .document('${_currentUser.email}')
        .collection('wordLists')
        .document(id.toString());
    //d.collection('words').add({'ad': 1});
  }

  int _getID(QuerySnapshot list) =>
      list == null || list.documents == null ? 0 : list.documents.length;
}

class _User {
  static final _User _singleton = _User._internal();
  //QuerySnapshot wordLists;
  List<WordList> wordLists;
  List<String> wrongOptions = List();

  factory _User() {
    return _singleton;
  }

  _User._internal();

  void initWrongOptions() async {
    var v = await _fireStore
        .collection("tempCollection")
        .document("grabageOptions")
        .get();
    List l = v.data['words'];
    for (String item in l) {
      wrongOptions.add(item);
    }
  }

  void initWordListStream(Stream<QuerySnapshot> stream) {
    stream.listen((data) async {
      wordLists = await getAllWordLists(data);
    }, onDone: () {}, onError: (error) {});
  }

  Future<List<WordList>> getAllWordLists(QuerySnapshot documents) async {
    List<WordList> list = new List();

    for (DocumentSnapshot document in documents.documents) {
      list.add(await getWordListFromDoc(document));
    }
    //_userData.allWordLists = list;

    //return _userData.allWordLists;
    return list;
  }

  WordList getWordList(int id) {
    for (WordList wordList in wordLists) if (wordList.id == id) return wordList;
    return null;
  }

  Future<WordList> getWordListFromDoc(DocumentSnapshot document) async {
    QuerySnapshot words =
        await document.reference.collection('words').getDocuments();

    List<FireBaseSubMeaning> list = List();
    for (DocumentSnapshot word in words.documents)
      list.add(FireBaseSubMeaning(word['meaningID'], word['subMeaning'],
          word['word'], word['examples'], word['subMeaningIndex']));

    return WordList(document.data['name'], document.data['description'], list,
        document.data['id']);
  }
}
