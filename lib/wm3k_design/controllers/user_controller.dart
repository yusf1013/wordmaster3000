import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wm3k/analysis_classes/wordList.dart';
import 'package:wm3k/dbConnection/connector.dart';
import 'package:wm3k/wm3k_design/controllers/quiz_controller.dart';
import 'package:wm3k/wm3k_design/models/assets_data_provider.dart';
import 'package:wm3k/wm3k_design/models/category.dart';
import 'package:http/http.dart' as http;

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
      List<String> l = List();
      _fireStore
          .collection("users")
          .document(email)
          .setData({"courseCreated": l, "courseEnrolled": l});

      _loadEssentials();
      //UserDataController().initializeUser();
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
        //UserDataController().initializeUser();
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
    _initializeUser();
  }

  void _initializeUser() {
    _currentUser = AuthController.getCurrentUser();
    user = _User();
    user.initWordListStream(getStreamOfWordLists());
    user.initWrongOptions();
    user.initCourseEnrolled(getStreamFromUserDoc());
    user.initCourseCreated(getStreamFromUserDoc());
    //user.initCourseEnrolled(_currentUser.email);
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

  Stream<DocumentSnapshot> getStreamFromUserDoc() {
    return _fireStore
        .collection('users')
        .document('${_currentUser.email}')
        .snapshots();
  }

  Stream<QuerySnapshot> getStreamOfCourses(String orderBy) {
    if (orderBy == 'time' || orderBy == 'Time' || orderBy == null)
      return _fireStore.collection('courses').snapshots();

    return _fireStore
        .collection('courses')
        .orderBy(orderBy, descending: true)
        .snapshots();
  }

  WordList getCourse(String id) {
    for (WordList wl in user.courses) if (wl.id == id) return wl;
    return null;
  }

  Future<WordList> getCourseFromID(String id) async {
    print("In get Course $id");
    DocumentSnapshot document =
        await _fireStore.collection("courses").document(id).get();
    print(document.data['name']);
    if (document != null)
      return await user.getWordListFromDoc(document);
    else
      return null;
  }

  void deleteWordList(String id) {
    _fireStore
        .collection('users')
        .document('${_currentUser.email}')
        .collection('wordLists')
        .document(id)
        .delete();
  }

  void unEnrollCourse(String id) async {
    var docRef = _fireStore.collection('users').document(_currentUser.email);
    var doc = await docRef.get();
    List l = doc.data['coursesEnrolled'];
    l.remove(id);
    docRef.updateData({'coursesEnrolled': l});
  }

  void deleteWordFromList(String listID, String wordID, int index) async {
    DocumentReference ref = await _fireStore
        .collection('users')
        .document('${_currentUser.email}')
        .collection('wordLists')
        .document(listID);
    DocumentSnapshot document = await ref.get();

    ref.collection("words").document("$wordID,$index").delete();

    int length = document.data['length'] - 1;
    ref.updateData({'length': length});
  }

  Stream<DocumentSnapshot> getCourses() {
    return _fireStore
        .collection('users')
        .document('${_currentUser.email}')
        .snapshots();
  }

  void unPublishCourse(String id) async {
    var docRef = _fireStore.collection('users').document(_currentUser.email);
    var doc = await docRef.get();
    List l = doc.data['coursesCreated'];
    l.remove(id);
    docRef.updateData({'coursesCreated': l});
    _fireStore
        .collection('courses')
        .document(id)
        .updateData({'published': false});
  }

  WordList getWordList(String id) {
    return user.getWordList(id);
  }

  List<WordList> getAllWordLists() {
    //if(_userData.allWordLists == null)

    return user.wordLists;
  }

  List<Category> getCategoryListForWordList(data) {
    //print("data type: ${data.runtimeType}");
    List<DocumentSnapshot> documents = data.documents;
    List<Category> list = new List();
    bool recent = true;
    for (DocumentSnapshot document in documents) {
      list.add(Category(
          imagePath: assetNameProvider.getWordListImage(recent),
          title: document.data['name'],
          wordCount: document.data['length'],
          time: document.data['length'] * 2,
          text: '',
          id: document.data['id'].toString()));
      recent = false;
    }
    return list;
  }

  List<Category> getCategoryListForCourses(data) {
    print("data type 2: ${data.runtimeType}");

    List<Category> list = new List();
    for (DocumentSnapshot document in user.courseDocList) {
      print("vojo ${document.data['name']}, ${document.data['words']}");
      list.add(Category(
          imagePath: assetNameProvider.getCourseImage(),
          title: document.data['name'],
          wordCount: document.data['length'],
          time: document.data['length'] * 2,
          text: '/Day',
          id: document.data['id']));
    }
    return list;
  }

  void addWordToList(
      String id, String word, Meaning meaning, bool selected, int index,
      {String collection = 'wordLists'}) async {
    DocumentReference ref = await _fireStore
        .collection('users')
        .document('${_currentUser.email}')
        .collection(collection)
        .document(id);
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
      print("After adding, length should be: $length");
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

  Future<int> createWordList(String name, String description,
      {String collection = 'wordLists'}) async {
    QuerySnapshot list = await _fireStore
        .collection('users')
        .document('${_currentUser.email}')
        .collection(collection)
        .getDocuments();

    int id = _getID(list);

    _fireStore
        .collection('users')
        .document('${_currentUser.email}')
        .collection(collection)
        .document(id.toString())
        .setData({
      'id': id,
      'name': name,
      'description': description,
      'length': 0,
      //'words': <String>[],
      //'meanings': <String>[]
    });
    /*DocumentReference d = await _fireStore
        .collection('users')
        .document('${_currentUser.email}')
        .collection(collection)
        .document(id.toString());*/
    //d.collection('words').add({'ad': 1});
    return id;
  }

  Future<bool> enrollInCourse(String id) async {
    var docRef = _fireStore.collection("users").document(_currentUser.email);
    var doc = await docRef.get();
    List l = doc.data['coursesEnrolled'];
    l.add(id);
    await docRef.updateData({"coursesEnrolled": l});
    int x = (await _fireStore
        .collection('courses')
        .document(id)
        .get())["downloads"];
    await _fireStore
        .collection('courses')
        .document(id)
        .updateData({"downloads": x + 1});
    return true;
  }

  bool hasCourse(String id) {
    for (WordList wl in user.courses) {
      if (wl.id == id) {
        return true;
      }
    }

    return false;
  }

  bool hasCreatedCourse(String id) {
    print("In has created course");
    for (String s in user.coursesCreated) {
      print("ID: $id, $s");
      if (s == id) return true;
    }

    return false;
  }

  Future<bool> createCourse(WordList wordList, String name, String desc) async {
    var rng = new Random();
    int code = rng.nextInt(1000000000);
    try {
      var url =
          'https://us-central1-wm3k-f920b.cloudfunctions.net/createCourse?id=${wordList.id}&user=${_currentUser.email}&code=$code&title=$name&desc=$desc';

      String res = await http.read(url);
      print(res);

      /*user.coursesCreated.add(wordList.name);
      await _fireStore
          .collection('users')
          .document(_currentUser.email)
          .setData({"coursesCreated": user.coursesCreated});*/
      if (res.contains("uccess")) {
        return true;
      } else
        return false;
    } catch (e) {
      print(e);
      return false;
    }

    /*var url = 'https://us-central1-wm3k-f920b.cloudfunctions.net/createCourse';
    var response = await http
        .post(url, body: {'id': '$id', 'user': '${_currentUser.email}'});
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');*/
  }

  void deleteCourse(String id) async {
    var dref = _fireStore.collection('users').document(_currentUser.email);
    var doc = await dref.get();
    List list = doc['coursesEnrolled'];
    list.remove(id);
    dref.updateData({"coursesEnrolled": list});
  }

  int _getID(QuerySnapshot list) =>
      list == null || list.documents == null ? 0 : list.documents.length;
}

class _User {
  static final _User _singleton = _User._internal();
  //QuerySnapshot wordLists;
  List<WordList> wordLists, courses;
  List<DocumentSnapshot> courseDocList;
  List<String> coursesCreated = List();
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

  void initCourseEnrolled(Stream<DocumentSnapshot> stream) {
    courses = List();
    courseDocList = List();
    stream.listen((data) async {
      print(
          "hhhhh In init course enrolled ${data.data['coursesEnrolled']}, ${courseDocList.length}");
      courses.clear();
      courseDocList.clear();
      List ids = data.data['coursesEnrolled'];
      for (String id in ids) {
        print("hhhhh Idiaaa: $id");
        DocumentSnapshot d =
            await _fireStore.collection('courses').document(id).get();
        courseDocList.add(d);
        courses.add(await getWordListFromDoc(d));
      }
    }, onDone: () {}, onError: (error) {});
  }

  void initCourseCreated(Stream<DocumentSnapshot> stream) {
    stream.listen((data) async {
      coursesCreated.clear();
      List list = data.data['coursesCreated'];
      for (String item in list) {
        coursesCreated.add(item);
      }
    }, onDone: () {}, onError: (error) {});
  }

  /*void initCourseCreated(String email) async {
     var v = await _fireStore.collection("users").document(email).get();
    List l = v.data['coursesCreated'];
    for (String item in l) {
      coursesCreated.add(item);
    }
  }*/

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

  WordList getWordList(String id) {
    print("In get word list");
    for (WordList wordList in wordLists) {
      print(wordList.id);
      if (wordList.id == id) return wordList;
    }
    print("Loop is done. Returning null");
    return null;
  }

  Future<WordList> getWordListFromDoc(DocumentSnapshot document) async {
    QuerySnapshot words =
        await document.reference.collection('words').getDocuments();

    List<FireBaseSubMeaning> list = List();
    for (DocumentSnapshot word in words.documents)
      list.add(FireBaseSubMeaning(word['meaningID'], word['subMeaning'],
          word['word'], word['examples'], word['subMeaningIndex']));

    /*int id = -1;
    if (document.data['id'].runtimeType == 1.runtimeType)
      id = document.data['id'];*/
    var v = document.data['id'];
    if (v.runtimeType == 1.runtimeType) v = v.toString();

    return WordList(
        document.data['name'], document.data['description'], list, v);
  }
}
