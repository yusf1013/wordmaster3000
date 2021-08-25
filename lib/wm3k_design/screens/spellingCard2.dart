import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:wm3k/analysis_classes/wordList.dart';
import 'package:wm3k/services/TextToSpeech.dart';
import 'package:wm3k/wm3k_design/helper/alert_box.dart';
import 'package:wm3k/wm3k_design/helper/buttons.dart';
import 'package:wm3k/wm3k_design/screens/dictionary_page.dart';
import 'package:wm3k/wm3k_design/themes/app_theme.dart';
import 'package:wm3k/wm3k_design/themes/dictionary_text_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'notification_card.dart';

CardController _controller = CardController();
int _correct = 0, _lastInd = -1;
var _textController = TextEditingController();

class SpellingCard2 extends StatefulWidget {
  final WordList wordList;

  SpellingCard2(this.wordList);

  @override
  _SpellingCard2State createState() => _SpellingCard2State();
}

class _SpellingCard2State extends State<SpellingCard2> {
  bool done = false;

  @override
  void initState() {
    _controller = CardController();
    _correct = 0;
    _lastInd = -1;
    _textController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      color: AppTheme.nearlyWhite,
      child: Stack(
        children: <Widget>[
          Image(
            image: AssetImage('assets/bgs/bg2.jpg'),
            fit: BoxFit.cover,
            height: MediaQuery.of(context).size.height,
          ),
          SafeArea(
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.transparent,
              body: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: getAppBar(context),
                  ),
                  Container(
                    width: width * 1,
                    height: height * 0.9,
                    child: TinderSwapCard(
                      orientation: AmassOrientation.LEFT,
                      totalNum: widget.wordList.subMeanings.length,
                      stackNum: 3,
                      swipeEdge: 100.0,
                      maxWidth: width - 10,
                      maxHeight: height + 50,
                      minWidth: width - 11,
                      minHeight: height * 0.9,
                      cardBuilder: (context, index) => Center(
                        child: SpellingLearnCard(
                          subMeaning: widget.wordList.subMeanings[index],
                          currentNumber: index + 1,
                          totalWords: widget.wordList.subMeanings.length,
                          height: height * 0.75,
                          width: width * 0.85,
                          cardTheme:
                              MyCardTheme(imagePath: 'assets/bgs/cardbg2.jpg'),
                        ),
                      ),
                      cardController: _controller,
                      swipeUpdateCallback:
                          (DragUpdateDetails details, Alignment align) {
                        /// Get swiping card's alignment
                        if (align.x < 0) {
                          //Card is LEFT swiping
                        } else if (align.x > 0) {
                          //Card is RIGHT swiping
                        }
                      },
                      swipeCompleteCallback:
                          (CardSwipeOrientation orientation, int index) async {
                        /// Get orientation & index of swiped card!
                        if (index == widget.wordList.subMeanings.length - 1 &&
                            index == _lastInd) {
                          await showDialog(
                            context: context,
                            builder: (context) {
                              return getEndCard();
                            },
                            // child: getEndCard(),
                          );
                          Navigator.pop(context, done);
                        }
                      },
                    ),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Center getEndCard() {
    done = true;
    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: 20),
        child: NotificationCard(
          headerText: "Spelling Master",
          h2Text:
              "Your Score: $_correct/${widget.wordList.subMeanings.length}\n",
          buttonText: "Go Back",
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  Row getAppBar(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 6),
          child: GestureDetector(
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onTap: () {
              Navigator.pop(context, done);
            },
          ),
        ),
        SizedBox(
          width: 20,
        ),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Text(
            'Spelling Master',
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
        ]),
      ],
    );
  }
}

class MyCardTheme {
  Image image;
  Color barColor;
  Color backgroundColor;

  MyCardTheme({String imagePath, Color barColor, Color backgroundColor}) {
    this.image = Image(
      image: AssetImage(imagePath),
      fit: BoxFit.cover,
    );
    this.barColor = barColor;
    this.backgroundColor = backgroundColor;
  }
}

class SpellingLearnCard extends StatefulWidget {
  final double height, width;
  final Color lightColor, darkColor;
  final MyCardTheme cardTheme;
  final int currentNumber, totalWords;
  final FireBaseSubMeaning subMeaning;

  SpellingLearnCard(
      {this.subMeaning,
      this.height,
      this.width,
      this.lightColor,
      this.cardTheme,
      this.darkColor,
      this.currentNumber = 1,
      this.totalWords = 5});

  @override
  _SpellingLearnCardState createState() => _SpellingLearnCardState();
}

class _SpellingLearnCardState extends State<SpellingLearnCard> {
  Widget mainView;
  bool wantSetState = false;
  FlutterTts flutterTts = TextToSpeech();
  String answer = "";
  TextToSpeech speech = TextToSpeech();

  void initialize() {
    mainView = getMeaning();
  }

  // void initTTS() {
  //   flutterTts.setVolume(1);
  //   flutterTts.setSpeechRate(0.5);
  //   flutterTts.setPitch(1);
  // }

  @override
  initState() {
    answer = "";
    initialize();
    // initTTS();
    super.initState();
  }

  Widget getCard(double height, double width) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 30),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: width, maxHeight: height),
        child: Stack(
          children: <Widget>[
            Positioned(
              bottom: 0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image(
                  image: AssetImage('assets/bgs/bg3.jpg'),
                  height: height,
                  width: width,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                width: width,
                height: height,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        SizedBox(
                          height: height * 0.1,
                        ),
                        GradientButton(
                          height: height * 0.05,
                          width: width * 0.4,
                          startColor: Color(0xFF192221),
                          endColor: Color(0xFFFF34AB),
                          text:
                              '${widget.currentNumber} / ${widget.totalWords} Completed',
                        ),
                        SizedBox(
                          width: 7,
                        ),
                        getDot(6),
                        getDot(6),
                        SizedBox(
                          width: 7,
                        ),
                      ],
                    ),
                    Stack(
                      children: <Widget>[
                        Container(
                          height: height * 0.3,
                          width: width,
                          child: widget.cardTheme.image,
                        ),
                        Positioned(
                          top: 40,
                          //bottom: 40,
                          left: 5,
                          child: Center(
                            child: Container(
                              width: width,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 25.0, right: 25),
                                          child: TextField(
                                            controller: _textController,
                                            autofocus: false,
                                            style: GoogleFonts.courgette(
                                              textStyle: TextStyle(
                                                fontSize: 26,
                                                color: Colors.white,
                                              ),
                                            ),
                                            onChanged: (value) {
                                              answer = value;
                                            },
                                            decoration: InputDecoration(
                                              hintText: 'Enter spelling',
                                              hintStyle: TextStyle(
                                                  inherit: true,
                                                  color: Colors.white70),
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.white,
                                                    width: 1),
                                              ),
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.white,
                                                    width: 1.5),
                                              ),
                                              labelStyle:
                                                  TextStyle(fontSize: 20),
                                            ),
                                            cursorColor: Colors.white70,
                                          ),
                                          /*Text(
                                            "The sentence with the word",
                                            style: GoogleFonts.courgette(
                                              textStyle: TextStyle(
                                                fontSize: 26,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),*/
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 25, top: 7),
                                        child: GestureDetector(
                                          onTap: () {
                                            flutterTts
                                                .speak(widget.subMeaning.word);
                                          },
                                          child: Icon(
                                            Icons.volume_up,
                                            size: 35,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border(
                              bottom:
                                  BorderSide(width: 2, color: Colors.black))),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          SizedBox(
                            height: height * 0.077,
                            width: 10,
                          ),
                          Tabs(
                            onPressed: () {},
                            width: 100,
                            items: ['Meaning'],
                            borderColor: Colors.black54,
                            borderWidth: 0,
                            highlightColor: Color(0xFF192221),
                            textColor: Colors.black,
                          ),
                          Expanded(
                            child: Container(
                              height: 0,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Container(
                          height: height * 0.4,
                          //color: Colors.deepOrange[50],
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: mainView,
                          ),
                          //height: height * 0.454,
                          //color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black54,
                      blurRadius: 5.0, // has the effect of softening the shadow
                      spreadRadius:
                          0.0, // has the effect of extending the shadow
                      offset: Offset(
                        3.5, // horizontal, move right 10
                        3.5, // vertical, move down 10
                      ),
                    )
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20)),
                ),
                width: width,
                child: Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    SizedBox(
                      height: height * 0.146,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 30.0,
                        right: 15,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black54,
                              blurRadius:
                                  5.0, // has the effect of softening the shadow
                              spreadRadius:
                                  0.0, // has the effect of extending the shadow
                              offset: Offset(
                                3.5, // horizontal, move right 10
                                3.5, // vertical, move down 10
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black54,
                            blurRadius:
                                5.0, // has the effect of softening the shadow
                            spreadRadius:
                                0.0, // has the effect of extending the shadow
                            offset: Offset(
                              3.5, // horizontal, move right 10
                              3.5, // vertical, move down 10
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black54,
                                blurRadius:
                                    5.0, // has the effect of softening the shadow
                                spreadRadius:
                                    0.0, // has the effect of extending the shadow
                                offset: Offset(
                                  3.5, // horizontal, move right 10
                                  3.5, // vertical, move down 10
                                ),
                              )
                            ],
                          ),
                          child: GradientButton(
                            onPressed: () async {
                              FocusScope.of(context).unfocus();
                              _textController.clear();
                              _lastInd = widget.currentNumber - 1;
                              if (widget.subMeaning.word.toLowerCase() ==
                                  answer.toLowerCase()) {
                                await showSuccessDialog();
                                _correct++;
                                _controller.triggerRight();
                              } else {
                                await showFailedDialog();
                                _controller.triggerLeft();
                              }
                              answer = "";
                            },
                            width: 150,
                            //startColor: Color(0xFFE0154D),
                            //endColor: Color(0xFFFF34AB),
                            startColor: Color(0xFF192221),
                            endColor: Color(0xFFFF34AB),
                            text: "Check Answer",
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future showSuccessDialog() async {
    await SuccessBgAlertBox(
            context: context,
            title: "Correct!!",
            infoMessage: "Your answer: ${widget.subMeaning.word}",
            buttonText: "Great!",
            icon: Icons.check_circle)
        .displayDialog();
  }

  Future showFailedDialog() async {
    await SuccessBgAlertBox(
            context: context,
            title: "Try again!",
            infoMessage:
                "Your answer: $answer\nCorrect answer: ${widget.subMeaning.word.toLowerCase()} ",
            buttonText: "Okay",
            icon: Icons.cancel,
            bgColor: Colors.red)
        .displayDialog();
  }

  Padding getDot(double radius, {Color color = Colors.black12}) {
    return Padding(
      padding: EdgeInsets.all(7),
      child: Container(
        height: radius * 2,
        width: radius * 2,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          color: color,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!wantSetState) initialize();
    wantSetState = false;
    return getCard(widget.height, widget.width);
  }

  Widget getMeaning() {
    Column column = getMeaningView(
        widget.subMeaning.getSubMeaning(), widget.subMeaning.word);
    for (int i = 0; i < widget.subMeaning.examples.length && i < 2; i++) {
      column.children.add(getSentence(widget.subMeaning.examples[i], i + 1));
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 5),
      child: column,
    );
  }

  Widget getMeaningView(String headerText, String word) {
    headerText = headerText.replaceAll(word, "_____");
    Column column = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Dot(4, color: Colors.black),
            Expanded(
              child: Text(
                headerText,
                style: dictionaryWords,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 3,
        ),
      ],
    );
    /*for (int i = 1; i < widget.subMeaning.examples.length; i++)
      column.children.add(getSentence(widget.subMeaning.examples[i]));

    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 5),
      child: column,
    );*/
    return column;
  }

  Padding getSentence(String example, int n) {
    // example = example.replaceAll(word, "_____");
    return Padding(
      padding: const EdgeInsets.only(left: 23.0, top: 5),
      child: GestureDetector(
        onTap: () {
          speech.speak(example);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "➣ Example $n (Tap to play)",
              style: dictionarySentences,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(Icons.volume_down_outlined),
            ),
          ],
        ),
      ),
    );
  }
  /*Padding getSentence(String example, String word) {
    example = example.replaceAll(word, "_____");
    return Padding(
      padding: const EdgeInsets.only(left: 23.0, top: 5),
      child: Text(
        "➣ " + example,
        style: dictionarySentences,
      ),
    );
  }*/
}

class CircleButton extends StatelessWidget {
  final VoidCallback onTap;
  final Color splashColor;
  final Icon icon;

  CircleButton(
      {@required this.onTap,
      this.splashColor = Colors.white,
      @required this.icon});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Material(
        child: InkWell(
          onTap: onTap,
          splashColor: splashColor,
          child: GestureDetector(
            child: icon,
          ),
        ),
      ),
    );
  }
}
