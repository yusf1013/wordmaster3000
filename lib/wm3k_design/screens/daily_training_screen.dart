import 'package:blur/blur.dart';
import 'package:clippy_flutter/arc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:wm3k/analysis_classes/wordList.dart';
import 'package:wm3k/wm3k_design/controllers/user_controller.dart';
import 'package:wm3k/wm3k_design/helper/buttons.dart';
import 'package:wm3k/wm3k_design/screens/memorization_card.dart';
import 'package:wm3k/wm3k_design/screens/quiz_screen.dart';
import 'package:wm3k/wm3k_design/screens/spellingCard2.dart';
import 'package:http/http.dart' as http;
import 'dart:math';
import 'package:http/http.dart' as http;

import 'my_word_list.dart';
import 'notification_card.dart';

class DailyTrainingScreen extends StatefulWidget {
  final DailyTrainingDetails dt;

  DailyTrainingScreen(this.dt);

  @override
  _DailyTrainingScreenState createState() => _DailyTrainingScreenState();
}

class _DailyTrainingScreenState extends State<DailyTrainingScreen> {
  Widget screenView;
  List<FireBaseSubMeaning> correctOnes = List();

  Center getEndCard() {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: 20),
        child: NotificationCard(
          //height: 600,
          headerText: "Quiz",
          h1Message: " Daily Training",
          h2Text: "Your final daily quiz.\n",
          bodyText:
              "Your next training session will be generated based on the result.",
          authorName: "",
          buttonText: "Continue",
          iconData: FontAwesomeIcons.questionCircle,
          onTap: () async {
            bool done = await Navigator.push(context,
                MaterialPageRoute(builder: (context) {
              return QuizCardScreen(
                widget.dt.forQuiz,
                onCorrect: (var id) {
                  correctOnes.add(id);
                },
              );
            }));

            if (done != null && done) {
              print("Hold on, hold on");
              widget.dt.testTakenDone();
              for (var v in widget.dt.forQuiz.subMeanings) {
                int mul = 0;
                if (correctOnes.contains(v)) {
                  print(v.id);
                  mul = 1;
                }
                http.get(
                    "https://us-central1-wm3k-f920b.cloudfunctions.net/increaseRating?u=${widget.dt.email}&mid=${v.id}&ind=${v.index}&mul=$mul");
              }

              var u = UserDataController();
              u.generateCLT();
              u.generateWLT();
            }

            Navigator.pop(context);

            // Navigator.pushReplacement(context,
            //     MaterialPageRoute(builder: (context) {
            //   return DailyTrainingScreen();
            // }));
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    screenView = Stack(
      children: <Widget>[
        Image(
          image: AssetImage('assets/bgs/dtbg1.jpg'),
          fit: BoxFit.cover,
          height: MediaQuery.of(context).size.height,
        ),
        getEndCard(),
      ],
    );
    return screenView;
  }
}

// class DailyTrainingScreenLoading extends StatefulWidget {
//   final DailyTrainingDetails dt;
//   final List correctOnes;
//
//   DailyTrainingScreenLoading(this.dt, this.correctOnes);
//
//   @override
//   _DailyTrainingScreenLoadingState createState() =>
//       _DailyTrainingScreenLoadingState();
// }
//
// class _DailyTrainingScreenLoadingState
//     extends State<DailyTrainingScreenLoading> {
//   Widget screen = Container(
//     color: Colors.grey,
//   );
//   bool spin = true;
//
//   void initState() {
//     init();
//     super.initState();
//   }
//
//   void init() async {
//     print("Hold on, hold on");
//     for (var v in widget.dt.forQuiz.subMeanings) {
//       int mul = 0;
//       if (widget.correctOnes.contains(v)) {
//         print(v.id);
//         mul = 1;
//       }
//       await http.get(
//           "https://us-central1-wm3k-f920b.cloudfunctions.net/increaseRating?u=${widget.dt.email}&mid=${v.id}&ind=${v.index}&mul=$mul");
//     }
//
//     var u = UserDataController();
//     await u.generateCLT();
//     await u.generateWLT();
//
//     setState(() {
//       screen = DailyTraining(widget.dt);
//       spin = false;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ModalProgressHUD(
//       inAsyncCall: spin,
//       child: screen,
//     );
//   }
// }

class DailyTraining extends StatefulWidget {
  final DailyTrainingDetails dt;

  DailyTraining(this.dt) {
    //this.dt.courseTrainingList.subMeanings = this.dt.courseTrainingList.subMeanings.sublist(0, 1); // DELETE THIS
  }

  @override
  _DailyTrainingState createState() => _DailyTrainingState();
}

class _DailyTrainingState extends State<DailyTraining> {
  void initState() {
    print("Before increasing");
    //widget.dt.increaseCTP();
    //widget.dt.increaseWLTP();
    //widget.dt.testTakenDone();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //double width = MediaQuery.of(context).size.width;
    var u = UserDataController();
    int courses = u.user.courses.length;
    int lists = 0;
    for (var x in u.user.wordLists) {
      lists = max(lists, x.subMeanings.length);
    }

    bool testEnabled = widget.dt.getTestEnabled(
        !isCourseTrainingDisabled(courses), !isListTrainingDisabled(courses));
    bool testTaken = widget.dt.testTaken;

    print("Why?? ${widget.dt.testTaken}");
    print(widget.dt.wordListTrainingProgressIndex);
    print(MediaQuery.of(context).size);
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Image(
            image: AssetImage('assets/bgs/dtbg1.jpg'),
            fit: BoxFit.cover,
            height: MediaQuery.of(context).size.height,
          ),
          Column(
            children: <Widget>[
              Expanded(
                child: Container(),
              ),
              Stack(
                children: [
                  ProgressCard(
                    height: 250,
                    index: widget.dt.courseTrainingProgressIndex,
                    onPress: (index) async {
                      int ld = widget.dt.courseTrainingList.subMeanings.length;
                      print("Course training shits - $ld");
                      // await UserDataController().initCDT(false);
                      ld = widget.dt.courseTrainingList.subMeanings.length;
                      if (ld == 0) {
                        await showDialog(
                          context: context,
                          builder: (context) {
                            var url =
                                "https://us-central1-wm3k-f920b.cloudfunctions.net/createCourseTraining?u=${AuthController().getUser().email}";
                            http.get(url).whenComplete(() =>
                                UserDataController().initCDT(true).whenComplete(
                                    () => Navigator.pop(context)));

                            return ModalProgressHUD(
                              inAsyncCall: true,
                              child: Container(),
                            );
                          },
                        );
                      }

                      if (index == 0) {
                        bool perfectlyDone = await Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return MemorizationCard(widget.dt.courseTrainingList);
                        }));
                        print("Ebar ki problem???");
                        print("$perfectlyDone");
                        if (perfectlyDone != null && perfectlyDone) {
                          widget.dt.increaseCTP();
                          print(widget.dt.courseTrainingProgressIndex);
                          print("jesh");
                          return 1;
                        }
                      } else if (index == 1) {
                        bool quizDone = await Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return QuizCardScreen(widget.dt.courseTrainingList);
                        }));
                        print("Q: $quizDone");
                        if (quizDone != null && quizDone) {
                          widget.dt.increaseCTP();
                          return 1;
                        }
                      } else if (index == 2) {
                        bool done = await Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return SpellingCard2(widget.dt.courseTrainingList);
                        }));
                        setState(() {});
                        if (done != null && done) {
                          widget.dt.increaseCTP();
                          return 1;
                        }
                      }

                      return 0;
                    },
                  ),
                  isCourseTrainingDisabled(courses)
                      ? Positioned(
                          bottom: 15,
                          top: 15,
                          left: 15,
                          right: 15,
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              color: Colors.grey[300].withOpacity(0.85),
                            ),
                            child: Center(
                                child: Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Text(
                                "Enroll in a course to unlock",
                                style: TextStyle(
                                    fontSize: 33,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.black),
                                textAlign: TextAlign.center,
                              ),
                            )),
                          ),
                        )
                      : Container(),
                ],
              ),
              Stack(
                children: [
                  ProgressCard(
                    index: widget.dt.wordListTrainingProgressIndex,
                    height: 250,
                    name: "Word Lists",
                    onPress: (index) async {
                      int ld =
                          widget.dt.wordListTrainingList.subMeanings.length;
                      print("Wordlist training shits - $ld");
                      // await UserDataController().initWDT(false);
                      ld = widget.dt.wordListTrainingList.subMeanings.length;
                      if (ld == 0) {
                        await showDialog(
                          context: context,
                          builder: (context) {
                            http
                                .get(
                                    "https://us-central1-wm3k-f920b.cloudfunctions.net/createWLTraining?u=${AuthController().getUser().email}")
                                .whenComplete(() => UserDataController()
                                    .initWDT(true)
                                    .whenComplete(
                                        () => Navigator.pop(context)));

                            return ModalProgressHUD(
                              inAsyncCall: true,
                              child: Container(),
                            );
                          },
                        );
                        // await http.get(
                        //     "https://us-central1-wm3k-f920b.cloudfunctions.net/createWLTraining?u=${AuthController().getUser().email}");
                        // await UserDataController().initWDT(true);
                      }

                      if (index == 0) {
                        bool perfectlyDone = await Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return MemorizationCard(
                              widget.dt.wordListTrainingList);
                        }));
                        if (perfectlyDone != null && perfectlyDone) {
                          widget.dt.increaseWLTP();
                          return 1;
                        }
                      } else if (index == 1) {
                        bool quizDone = await Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return QuizCardScreen(widget.dt.wordListTrainingList);
                        }));
                        print("Q: $quizDone");
                        if (quizDone != null && quizDone) {
                          widget.dt.increaseWLTP();
                          return 1;
                        }
                      } else if (index == 2) {
                        bool done = await Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return SpellingCard2(widget.dt.wordListTrainingList);
                        }));
                        setState(() {});
                        if (done != null && done) {
                          widget.dt.increaseWLTP();
                          return 1;
                        }
                      }
                      return 0;
                    },
                  ),
                  isListTrainingDisabled(lists)
                      ? Positioned(
                          bottom: 15,
                          top: 15,
                          left: 15,
                          right: 15,
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              color: Colors.grey[300].withOpacity(0.85),
                            ),
                            child: Center(
                                child: Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Text(
                                "Create word-list & add words to unlock",
                                style: TextStyle(
                                    fontSize: 33,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.black),
                                textAlign: TextAlign.center,
                              ),
                            )),
                          ),
                        )
                      : Container(),
                ],
              ),
              GradientButton(
                height: 45,
                text: testTaken ? "Test Completed (View)" : "Final Daily Test",
                textSize: 18,
                startColor: testTaken
                    ? Colors.green[600]
                    : (testEnabled ? Color(0xff374ABE) : Colors.grey),
                endColor: testTaken
                    ? Colors.green[400]
                    : (testEnabled ? Color(0xff64B6FF) : Colors.grey),
                onPressed: testEnabled
                    ? () async {
                        await Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return DailyTrainingScreen(widget.dt);
                        }));
                        setState(() {});
                      }
                    : testTaken
                        ? () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return MyWordList(
                                wordList: widget.dt.forQuiz,
                                searchBar: false,
                                backButton: true,
                                deletable: false,
                              );
                            }));
                          }
                        : null,
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }

  bool isListTrainingDisabled(int lists) {
    return lists == 0 && widget.dt.wordListTrainingList.subMeanings.length == 0;
  }

  bool isCourseTrainingDisabled(int courses) {
    return courses == 0 && widget.dt.courseTrainingList.subMeanings.length == 0;
  }
}

class ProgressCard extends StatefulWidget {
  final double height, width;
  final int progress;
  final String name;
  final int index;
  final Function onPress;

  const ProgressCard(
      {Key key,
      this.height,
      this.width,
      this.name = "Courses",
      this.index = 0,
      this.progress,
      this.onPress})
      : super(key: key);

  @override
  _ProgressCardState createState() => _ProgressCardState();
}

class _ProgressCardState extends State<ProgressCard> {
  Color bodyColor = Color(0xFFcef1f5);
  Color edgeColor = Color(0xFF2BC8D9);
  Color doneColor = Colors.green[600];
  double spacing = 8;
  int progress, index;

  @override
  void initState() {
    index = widget.index;
    progress = index ~/ 0.03;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    progress = index ~/ 0.03;
    print("InBuild $index");
    Color doneColor = Colors.green[600];
    //progress = widget.progress;
    //index = widget.index;

    return GestureDetector(
      onTap: () async {
        if (widget.onPress != null) {
          int x = await widget.onPress(index);

          setState(() {
            index += x;
            print("Index: $index, $x");
          });
        }
      },
      child: SizedBox(
        height: widget.height,
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Container(
            decoration: BoxDecoration(
                color: bodyColor, //
                borderRadius: BorderRadius.all(Radius.circular(15))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                ClipRect(
                  clipper: CustomRect(),
                  child: Container(
                    decoration: BoxDecoration(
                        color: edgeColor,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            bottomLeft: Radius.circular(15))),
                    height: widget.height,
                    width: 20,
                  ),
                ),
                Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width - 80,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              widget.name,
                              style: TextStyle(
                                fontSize: 35,
                                fontWeight: FontWeight.w700,
                                shadows: <Shadow>[
                                  Shadow(
                                    offset: Offset(0.5, 0.5),
                                    blurRadius: 2.0,
                                    color: Color.fromARGB(100, 0, 0, 0),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Container(),
                            ),
                            CircularStepProgressIndicator(
                              totalSteps: 100,
                              currentStep: progress,
                              stepSize: 5,
                              selectedColor: Colors.grey[800],
                              unselectedColor: Colors.grey[400],
                              width: 45,
                              height: 45,
                              //selectedStepSize: 5,
                              roundedCap: (_, __) => true,
                              child: Center(
                                  child: Text(
                                progress.toString(),
                                style: TextStyle(fontWeight: FontWeight.w900),
                              )),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 12),
                      child: Chip(
                        checked: index > 0,
                        checkedColor: doneColor,
                        chipColor: edgeColor,
                        iconSize: 39,
                        width: 240,
                        id: FontAwesomeIcons.linode,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                "Memorize",
                                style: GoogleFonts.courgette(
                                    textStyle: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: spacing),
                      child: Chip(
                        checked: index > 1,
                        checkedColor: doneColor,
                        chipColor: edgeColor,
                        iconSize: 32,
                        width: 240,
                        id: FontAwesomeIcons.question,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                "Quiz",
                                style: GoogleFonts.courgette(
                                    textStyle: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: spacing + 3, bottom: 5),
                      child: Chip(
                        checked: index > 2,
                        checkedColor: doneColor,
                        chipColor: edgeColor,
                        iconSize: 32,
                        width: 240,
                        id: FontAwesomeIcons.etsy,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                "Spelling Practice",
                                style: GoogleFonts.courgette(
                                    textStyle: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 75,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(),
                          ),
                          Text(
                            index < 3
                                ? "Continue training ... "
                                : "Training completed",
                            style: GoogleFonts.dancingScript(
                                textStyle: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.w900,
                              color:
                                  index < 3 ? Colors.black : Colors.green[800],
                            )),
                          ),
                          Icon(
                            FontAwesomeIcons.arrowAltCircleRight,
                            color:
                                index < 3 ? Colors.black : Colors.transparent,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                ClipRect(
                  clipper: CustomRect(left: false),
                  child: Container(
                    decoration: BoxDecoration(
                        color: edgeColor,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(15),
                            bottomRight: Radius.circular(15))),
                    height: widget.height,
                    width: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Chip extends StatelessWidget {
  final double width, height, iconSize;
  final Color checkedColor, chipColor;
  final bool checked;
  final Widget child;
  final IconData id;

  const Chip(
      {Key key,
      this.width = 150,
      this.height = 30,
      this.iconSize = 35,
      this.checkedColor = Colors.black,
      this.chipColor = Colors.black,
      this.checked = false,
      this.child,
      this.id = Icons.check_circle_outline})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(
          //checked ? Icons.check_circle_outline : Icons.radio_button_unchecked,
          id,
          color: checked ? checkedColor : chipColor,
          size: iconSize,
        ),
        Arc(
          edge: Edge.LEFT,
          arcType: ArcType.CONVEY,
          height: 10.0,
          //clipShadows: [ClipShadow(color: shadowColor, elevation: 3)],
          child: new Container(
            decoration: BoxDecoration(
                color: checked ? checkedColor : chipColor,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(25),
                    bottomRight: Radius.circular(25))),
            width: width,
            height: height,
            child: child == null
                ? null
                : Padding(
                    padding: EdgeInsets.only(left: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        child,
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Icon(
                            Icons.done_all,
                            color: checked ? Colors.black : chipColor,
                          ),
                        )
                      ],
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}

class CustomRect extends CustomClipper<Rect> {
  final bool left;

  CustomRect({this.left = true});
  @override
  Rect getClip(Size size) {
    Rect rect;
    if (left)
      rect = Rect.fromLTRB(0.0, 0.0, size.width / 2.5, size.height);
    else
      rect = Rect.fromLTRB(size.width * 0.6, 0.0, size.width, size.height);
    return rect;
  }

  @override
  bool shouldReclip(CustomRect oldClipper) {
    return true;
  }
}
