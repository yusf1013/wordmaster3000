import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wm3k/analysis_classes/wordList.dart';
import 'package:wm3k/dbConnection/connector.dart';
import 'package:wm3k/wm3k_design/controllers/quiz_controller.dart';
import 'package:wm3k/wm3k_design/models/assets_data_provider.dart';
import 'package:wm3k/wm3k_design/models/category.dart';
import 'package:http/http.dart' as http;

auth.FirebaseAuth _auth;
FirebaseFirestore _fireStore;

class AuthController {
  static auth.User _user;
  static SharedPreferences _sharedPreferences;
  bool _loaded = false;

  AuthController() {
    _loadEssentials();
  }

  void _loadEssentials() async {
    print("How many times is this shit called?? :( ");
    _auth = auth.FirebaseAuth.instance;
    _fireStore = FirebaseFirestore.instance;
    // _user ??= _auth.currentUser;
    _user = _auth.currentUser;
    print("user: ");
    print(_user);
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
      var result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      _writeCredentials(email, password);
      List<String> l = List();
      _fireStore.collection("users").doc(email).set({
        "courseCreated": l,
        "courseEnrolled": l,
        "DailyTrainingDetails": {
          "courseTrainingProgressIndex": 0,
          "wordListTrainingProgressIndex": 0,
          "testTaken": false
        },
        "score": 0,
      });

      _loadEssentials();
      var v = UserDataController();
      v._initializeUser();
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
    // String email = "";
    // String pass = "";
    print("Loggin in auto $email $pass");
    return await logIn(email, pass);
  }

  Future<bool> logIn(String email, String pass) async {
    if (email != null && pass != null) {
      try {
        var result = await _auth.signInWithEmailAndPassword(
            email: email, password: pass);
        print("Auth result is: ${result.toString()}");
        if (result == null) return false;
        _writeCredentials(email, pass);
        await _loadEssentials();
        var v = UserDataController();
        // await v.initDT();
        v._initializeUser(); // Why did I comment this out?
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

  auth.User getUser() {
    return _user;
  }

  static auth.User getCurrentUser() => _user;
}

class UserDataController {
  auth.User _currentUser;
  _User user;
  static final UserDataController _singleton = UserDataController._internal();

  factory UserDataController() {
    return _singleton;
  }

  UserDataController._internal() {
    _initializeUser();
  }

  void _initializeUser() {
    print("IN INIT USER");
    _currentUser = AuthController.getCurrentUser();
    user = _User();
    user.initDailyTrainingDetails(
        getStreamOfCTLists(), getStreamOfWLTLists(), _currentUser.email);
    user.initWordListStream(getStreamOfWordLists());
    user.leaderboard();
    user.initWrongOptions();
    user.initCourseEnrolled(getCourses());
    user.initCourseCreated(getStreamFromUserDoc());
  }

  List<String> getLeaders() {
    return user.usernames;
  }

  void initDT() async {
    await user.initDailyTrainingDetails(
        getStreamOfCTLists(), getStreamOfWLTLists(), _currentUser.email);
    await sleep1();
  }

  Future<void> initWDT(bool loadForQuiz) async {
    await user.dailyTraining.initWordListTrainingList(getStreamOfWLTLists(),
        loadForQuiz: loadForQuiz);
    // await sleepOneSecond();
  }

  Future<void> initCDT(bool loadForQuiz) async {
    await user.dailyTraining
        .initCourseTrainingList(getStreamOfCTLists(), loadForQuiz: loadForQuiz);
    // await sleepOneSecond();
  }

  Future sleep1() {
    return new Future.delayed(const Duration(milliseconds: 250), () => "1");
  }

  Future sleepOneSecond() {
    return new Future.delayed(const Duration(milliseconds: 1000), () => "1");
  }

  AssetNameProvider assetNameProvider = AssetNameProvider();

  Map getOptions(String ans) {
    return QuizController(user.wrongOptions).getOptions(ans);
  }

  Future<QuerySnapshot> getStreamOfCTLists() {
    return _fireStore
        .collection('users')
        .doc('${_currentUser.email}')
        .collection('courseTraining')
        .get();
  }

  Future<QuerySnapshot> getStreamOfWLTLists() {
    return _fireStore
        .collection('users')
        .doc('${_currentUser.email}')
        .collection('trainingItems')
        .get();
  }

  Stream<QuerySnapshot> getStreamOfWordLists() {
    print("IN SNAPSHOT ${_currentUser.email}");
    return _fireStore
        .collection('users')
        .doc('${_currentUser.email}')
        .collection('wordLists')
        .orderBy('id')
        .snapshots();
  }

  Stream<DocumentSnapshot> getStreamFromUserDoc() {
    return _fireStore
        .collection('users')
        .doc('${_currentUser.email}')
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

  Stream<QuerySnapshot> getPosts() {
    return _fireStore
        .collection('posts')
        .orderBy('time', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getCommentOfPosts(id) {
    return _fireStore
        .collection('posts')
        .doc(id)
        .collection('comments')
        .orderBy('time', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getPostsByemail(email) {
    print("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&");
    print(email);
    return _fireStore
        .collection('posts')
        .where('user_email', isEqualTo: email)
        .orderBy('time', descending: true)
        .snapshots();
  }

  WordList getCourse(String id) {
    for (WordList wl in user.courses) if (wl.id == id) return wl;
    return null;
  }

  Future<DocumentSnapshot> getPostById(id) async {
    print('yaaaaaaaaaa huuuuuuuuuuuuuuuuuuu');
    DocumentReference ref = await _fireStore.collection('posts').doc(id);
    DocumentSnapshot document = await ref.get();

    print(document);
    return document;
  }

  Future<WordList> getCourseFromID(String id) async {
    print("In get Course $id");
    DocumentSnapshot document =
        await _fireStore.collection("courses").doc(id).get();
    print(document.data()['name']);
    if (document != null)
      return await user.getWordListFromDoc(document, collection: 'courseWords');
    else
      return null;
  }

  void deleteWordList(String id) {
    _fireStore
        .collection('users/${_currentUser.email}/wordLists/$id/words')
        .get()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
      }
    });

    _fireStore
        .collection('users')
        .doc('${_currentUser.email}')
        .collection('wordLists')
        .doc(id)
        .delete();
  }

  void deletePost(id) {
    _fireStore.collection('posts').doc(id).delete();
  }

  void deleteComment(post_id, comment_id) {
    _fireStore
        .collection('posts')
        .doc(post_id)
        .collection('comments')
        .doc(comment_id)
        .delete();
  }

  void unEnrollCourse(String id) async {
    _fireStore
        .collection('users/${_currentUser.email}/courses/$id/courseWords')
        .get()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
      }
    });

    var docRef = _fireStore
        .collection('users')
        .doc(_currentUser.email + "/courses/$id")
        .delete();
    /*var doc = await docRef.get();
    List l = doc.data()['coursesEnrolled'];
    l.remove(id);
    docRef.update({'coursesEnrolled': l});*/
  }

  void deleteWordFromList(String listID, String wordID, int index) async {
    DocumentReference ref = await _fireStore
        .collection('users')
        .doc('${_currentUser.email}')
        .collection('wordLists')
        .doc(listID);
    DocumentSnapshot document = await ref.get();

    ref.collection("words").doc("$wordID,$index").delete();

    int length = document.data()['length'] - 1;
    ref.update({'length': length});
  }

  void increaseLike(String post_id) async {
    DocumentReference ref = await _fireStore.collection('posts').doc(post_id);
    DocumentSnapshot document = await ref.get();

    int like = document.data()['like'] + 1;
    ref.update({'like': like});
  }

  Stream<QuerySnapshot> getCourses() {
    /*return _fireStore
        .collection('users')
        .doc('${_currentUser.email}')
        .snapshots();*/
    return _fireStore
        .collection('users')
        .doc('${_currentUser.email}')
        .collection("courses")
        .snapshots();
  }

  void unPublishCourse(String id) async {
    var docRef = _fireStore.collection('users').doc(_currentUser.email);
    var doc = await docRef.get();
    List l = doc.data()['coursesCreated'];
    l.remove(id);
    docRef.update({'coursesCreated': l});
    _fireStore.collection('courses').doc(id).update({'published': false});
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
          title: document.data()['name'],
          wordCount: document.data()['length'],
          time: document.data()['length'] * 2,
          text: '',
          id: document.data()['id'].toString()));
      recent = false;
    }
    return list;
  }

  List<Category> getCategoryListForCourses(data) {
    print("data type 2: ${data.runtimeType}");

    List<Category> list = new List();
    for (DocumentSnapshot document in user.courseDocList) {
      print("vojo ${document.data()['name']}, ${document.data()['words']}");
      list.add(Category(
          imagePath: assetNameProvider.getCourseImage(),
          title: document.data()['name'],
          wordCount: document.data()['length'],
          time: document.data()['length'] * 2,
          text: '/Day',
          id: document.data()['id']));
    }
    return list;
  }

  void generateWLT() async {
    String url =
        "https://us-central1-wm3k-f920b.cloudfunctions.net/createWLTraining?u=${_currentUser.email}";
    await http.get(url);
  }

  void generateCLT() async {
    String url =
        "https://us-central1-wm3k-f920b.cloudfunctions.net/createCourseTraining?u=${_currentUser.email}";
    await http.get(url);
  }

  void addWordToList(
      String id, String word, Meaning meaning, bool selected, int index,
      {String collection = 'wordLists'}) async {
    DocumentReference ref = await _fireStore
        .collection('users')
        .doc('${_currentUser.email}')
        .collection(collection)
        .doc(id);
    DocumentSnapshot document = await ref.get();

    if (selected) {
      ref
          .collection('words')
          .doc(meaning.id.toString() + "," + index.toString())
          .setData({
        'meaningID': meaning.id.toString(),
        'subMeaning': meaning.subMeaning[index].subMeaning,
        'subMeaningIndex': index,
        'word': word,
        'examples': meaning.subMeaning[index].examples,
        'rating': 1000,
        'author': _currentUser.email,
      });
      int length = document.data()['length'] + 1;
      print("After adding, length should be: $length");
      ref.update({'length': length});
    } else {
      ref
          .collection('words')
          .doc(meaning.id.toString() + "," + index.toString())
          .delete();
      int length = document.data()['length'] - 1;
      ref.update({'length': length});
    }
  }

  Future<int> createWordList(String name, String description,
      {String collection = 'wordLists'}) async {
    QuerySnapshot list = await _fireStore
        .collection('users')
        .doc('${_currentUser.email}')
        .collection(collection)
        .getDocuments();

    int id = _getID(list);

    _fireStore
        .collection('users')
        .doc('${_currentUser.email}')
        .collection(collection)
        .doc(id.toString())
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
        .doc('${_currentUser.email}')
        .collection(collection)
        .doc(id.toString());*/
    //d.collection('words').add({'ad': 1});
    return id;
  }

  Future<int> createPost(String post, email) async {
    _fireStore.collection('posts').doc().setData({
      'user_email': email,
      'post': post,
      'like': 0,
      'time': new DateTime.now(),
    });
  }

  Future<int> saveComment(String comment, email, parent_id) async {
    _fireStore
        .collection('posts')
        .doc(parent_id)
        .collection('comments')
        .doc()
        .setData({
      'user_email': email,
      'comment': comment,
      'parent_id': parent_id,
      'time': new DateTime.now(),
    });
  }

  Future<bool> enrollInCourse(String id) async {
    print("Enroll in course!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!: $id");

    try {
      var url =
          "http://us-central1-wm3k-f920b.cloudfunctions.net/enrollInCourse?u=${_currentUser.email}&cid=$id";
      //var url = "https://us-central1-wm3k-f920b.cloudfunctions.net/createCourseDeath?user=hunter@gmail.com&id=hunter@gmail.com,0,405758008";
      print(url);
      var res = await http.get(url);
      print(res.statusCode);

      int x = (await _fireStore.collection('courses').doc(id).get())
          .data()["downloads"];
      await _fireStore
          .collection('courses')
          .doc(id)
          .update({"downloads": x + 1});
    } catch (e) {
      print(e);
      return false;
    }
    return true;
    /*
    shit shit
     */
  }

  bool hasCourse(String id) {
    for (WordList wl in user.courses) {
      if (wl.id == id) {
        return true;
      }
    }

    return false;
  }

  DailyTrainingDetails getDailyTrainingDetails() {
    return user.dailyTraining;
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
          'https://us-central1-wm3k-f920b.cloudfunctions.net/createCourse?id=${wordList.id}&user=${_currentUser.email}&code=$code&title=$name&desc=$desc&length=${wordList.subMeanings.length}';

      Response res = await http.get(url);
      print(res);

      if (res.statusCode == 200) {
        return true;
      } else
        return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  void deleteCourse(String id) async {
    var dref = _fireStore.collection('users').doc(_currentUser.email);
    var doc = await dref.get();
    List list = doc.data()['coursesEnrolled'];
    list.remove(id);
    dref.update({"coursesEnrolled": list});
  }

  int _getID(QuerySnapshot list) =>
      list == null || list.documents == null ? 0 : list.documents.length;
}

class _User {
  static final _User _singleton = _User._internal();
  //QuerySnapshot wordLists;
  List<WordList> wordLists, courses;
  DailyTrainingDetails dailyTraining;
  List<DocumentSnapshot> courseDocList;

  List<String> coursesCreated = List();
  List<String> wrongOptions = List();
  List<String> usernames = List();

  factory _User() {
    return _singleton;
  }

  _User._internal();

  void initWrongOptions() async {
    var v = await _fireStore
        .collection("tempCollection")
        .doc("grabageOptions")
        .get();
    List l = v.data()['words'];
    for (String item in l) {
      wrongOptions.add(item);
    }
  }

  void initDailyTrainingDetails(Future<QuerySnapshot> clt,
      Future<QuerySnapshot> wlt, String email) async {
    dailyTraining = DailyTrainingDetails();
    dailyTraining.initCourseTrainingList(clt);
    dailyTraining.initWordListTrainingList(wlt);
    dailyTraining.initSmallDetails(email);
  }

  void initCourseEnrolled(Stream<QuerySnapshot> stream) async {
    /*//delete this
    var v = await _fireStore
        .collectionGroup("words")
        .where("author == hunter@gmail.com")
        .get();

    print("Never use flutter");
    for (var x in v.docs) print(x.data());*/

    courses = List();
    courseDocList = List();
    stream.listen((data) async {
      courses.clear();
      courseDocList.clear();
      for (DocumentSnapshot doc in data.documents) {
        courseDocList.add(doc);
        courses.add(await getWordListFromDoc(doc, collection: 'courseWords'));
      }
    }, onDone: () {}, onError: (error) {});
  }

  void initCourseCreated(Stream<DocumentSnapshot> stream) {
    stream.listen((data) async {
      coursesCreated.clear();
      List list = data.data()['coursesCreated'];
      if (list == null) list = List();
      for (String item in list) {
        coursesCreated.add(item);
      }
    }, onDone: () {}, onError: (error) {});
  }

  void initWordListStream(Stream<QuerySnapshot> stream) {
    stream.listen(
        (data) async {
          wordLists = await getAllWordLists(data);
        },
        onDone: () {},
        onError: (error) {
          print(error);
        });
  }

  void leaderboard() async {
    var stream = await _fireStore
        .collection("users")
        .orderBy("score", descending: true)
        .limit(20)
        .snapshots();

    stream.listen(
        (QuerySnapshot data) async {
          usernames.clear();
          for (DocumentSnapshot doc in data.docs) {
            String name =
                doc.id + "," + ((doc.data()["score"]).round()).toString();
            usernames.add(name);
          }
        },
        onDone: () {},
        onError: (error) {
          print(error);
        });
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

  Future<WordList> getWordListFromDoc(DocumentSnapshot document,
      {String collection = 'words'}) async {
    QuerySnapshot words =
        await document.reference.collection(collection).getDocuments();

    List<FireBaseSubMeaning> list = List();
    for (DocumentSnapshot wor in words.docs) {
      var word = wor.data();
      list.add(FireBaseSubMeaning(
          word['meaningID'],
          word['subMeaning'],
          word['word'],
          word['examples'],
          word['subMeaningIndex'],
          word['rating']));
    }
    var v = document.data()['id'];
    if (v.runtimeType == 1.runtimeType) v = v.toString();

    return WordList(
        document.data()['name'], document.data()['description'], list, v);
  }
}

class DailyTrainingDetails {
  static final DailyTrainingDetails _singleton =
      DailyTrainingDetails._internal();

  WordList courseTrainingList,
      wordListTrainingList,
      forQuiz = WordList("Summary", "", [], "");
  int courseTrainingProgressIndex = 0, wordListTrainingProgressIndex = 0;
  String email;
  bool testTaken = false;

  factory DailyTrainingDetails() {
    return _singleton;
  }

  void increaseCTP() {
    courseTrainingProgressIndex += 1;
    _fireStore.collection("users").doc(email).update({
      "DailyTrainingDetails.courseTrainingProgressIndex":
          courseTrainingProgressIndex
    });
    // updateCloudStore();
  }

  int getProgress() {
    print(
        "Get progress started $courseTrainingProgressIndex $wordListTrainingProgressIndex");
    int x = ((courseTrainingProgressIndex + wordListTrainingProgressIndex) /
            6.0 *
            96)
        .round();
    if (testTaken) x += 4;
    return x;
  }

  void increaseWLTP() {
    wordListTrainingProgressIndex += 1;
    _fireStore.collection("users").doc(email).update({
      "DailyTrainingDetails.wordListTrainingProgressIndex":
          wordListTrainingProgressIndex
    });
  }

  void testTakenDone() {
    testTaken = true;
    _fireStore
        .collection("users")
        .doc(email)
        .update({"DailyTrainingDetails.testTaken": testTaken});
  }

  bool getTestEnabled(bool courseUnlocked, bool wlUnlocked) {
    if (testTaken) return false;

    if (courseUnlocked && wlUnlocked)
      return courseTrainingProgressIndex > 2 &&
          wordListTrainingProgressIndex > 2;

    if (courseUnlocked) return courseTrainingProgressIndex > 2;

    if (wlUnlocked) return wordListTrainingProgressIndex > 2;

    return false;
    /*bool testEnabled = courseTrainingProgressIndex > 2 &&
        wordListTrainingProgressIndex > 2 &&
        !testTaken;
    return testEnabled;*/
  }

  DailyTrainingDetails._internal();

  void initSmallDetails(String m) async {
    print("Init small details started");
    var currentUser = AuthController.getCurrentUser();
    var doc = await _fireStore.doc("users/${currentUser.email}").get();

    courseTrainingProgressIndex =
        doc.data()["DailyTrainingDetails"]["courseTrainingProgressIndex"];
    wordListTrainingProgressIndex =
        doc.data()["DailyTrainingDetails"]["wordListTrainingProgressIndex"];
    email = m;
    testTaken = doc.data()["DailyTrainingDetails"]["testTaken"];
    print("Everythig done");
  }

  Future<void> initCourseTrainingList(Future<QuerySnapshot> documents,
      {bool loadForQuiz = true}) async {
    forQuiz.subMeanings = List();
    QuerySnapshot docs = await documents;
    courseTrainingList = await getWordListFromWordsCollection(docs);

    if (loadForQuiz) {
      var x = courseTrainingList.subMeanings;
      if (x.length > 0) forQuiz.subMeanings.add(x[0]);
      for (int i = 1; i < x.length; i++) {
        if (x[i].index != x[i - 1].index || x[i].id != x[i - 1].id)
          forQuiz.subMeanings.add(x[i]);
      }
    }

    courseTrainingList = courseTrainingList.getShuffledWordList();
  }

  Future<void> initWordListTrainingList(Future<QuerySnapshot> documents,
      {bool loadForQuiz = true}) async {
    QuerySnapshot docs = await documents;
    wordListTrainingList = await getWordListFromWordsCollection(docs);

    if (loadForQuiz) {
      var x = wordListTrainingList.subMeanings;
      if (x.length > 0) forQuiz.subMeanings.add(x[0]);
      for (int i = 1; i < x.length; i++) {
        if (x[i].index != x[i - 1].index || x[i].id != x[i - 1].id)
          forQuiz.subMeanings.add(x[i]);
      }
    }
    wordListTrainingList = wordListTrainingList.getShuffledWordList();
  }

  Future<WordList> getWordListFromWordsCollection(QuerySnapshot words) async {
    List<FireBaseSubMeaning> list = List();
    for (DocumentSnapshot wor in words.docs) {
      var word = wor.data();
      list.add(FireBaseSubMeaning(
          word['meaningID'],
          word['subMeaning'],
          word['word'],
          word['examples'],
          word['subMeaningIndex'],
          word['rating']));
    }
    //var v = document.data()['id'];
    //if (v.runtimeType == 1.runtimeType) v = v.toString();

    return WordList("", "", list, "ID");
  }
}
