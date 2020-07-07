import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:wm3k/analysis_classes/wordList.dart';
import 'package:wm3k/wm3k_design/helper/buttons.dart';
import 'package:wm3k/wm3k_design/screens/dictionary_page.dart';
import 'package:wm3k/wm3k_design/themes/app_theme.dart';
import 'package:wm3k/wm3k_design/themes/dictionary_text_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'notification_card.dart';

class MemorizationCard extends StatefulWidget {
  final WordList wordList;

  MemorizationCard(this.wordList);

  @override
  _MemorizationCardState createState() => _MemorizationCardState();
}

class _MemorizationCardState extends State<MemorizationCard> {
  int _correct = 0;
  double swipeEdge = 6, lastSwipeAlign;
  List<int> _incorrectList = List();

  @override
  void initState() {
    for (int i = 0; i < widget.wordList.subMeanings.length; i++)
      _incorrectList.add(i);
    // TODO: implement initState
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
                      swipeEdge: swipeEdge,
                      maxWidth: width - 10,
                      maxHeight: height + 50,
                      minWidth: width - 11,
                      minHeight: height * 0.9,
                      cardBuilder: (context, index) {
                        //return getEndCard();
                        //if (index < widget.wordList.subMeanings.length)
                        return getLearnCard(index, height, width);
                        /*else
                          return getEndCard();*/
                      },
                      cardController: CardController(),
                      swipeUpdateCallback:
                          (DragUpdateDetails details, Alignment align) {
                        /// Get swiping card's alignment
                        if (align.x < 0) {
                          //Card is LEFT swiping
                        } else if (align.x > 0) {
                          //Card is RIGHT swiping
                        }
                        lastSwipeAlign = align.x;
                        if (lastSwipeAlign < 0) lastSwipeAlign *= -1;
                      },
                      swipeCompleteCallback:
                          (CardSwipeOrientation orientation, int index) async {
                        bool tapped;
                        print(lastSwipeAlign);
                        if (index == widget.wordList.subMeanings.length - 1 &&
                            lastSwipeAlign > swipeEdge) {
                          tapped = await showDialog(
                            child: getEndCard(),
                            context: context,
                          );
                          if (tapped == null || tapped == false)
                            Navigator.pop(context);
                          else if (tapped) {
                            List<FireBaseSubMeaning> tempList = List();
                            for (int i in _incorrectList)
                              tempList.add(widget.wordList.subMeanings[i]);

                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MemorizationCard(
                                        WordList("", "", tempList, "-1"))));
                          }
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

  Center getLearnCard(int index, double height, double width) {
    return Center(
      child: LearnCard(
        tickAction: (selected, currentIndex) {
          if (!selected) _correct++;
          _incorrectList.remove(currentIndex - 1);
          setState(() {});
          return true;
        },
        crossAction: (selected, currentIndex) {
          if (selected) {
            _correct--;
          }
          return false;
        },
        currentIndex: index + 1,
        totalWords: widget.wordList.subMeanings.length,
        subMeaning: widget.wordList.subMeanings[index],
        height: height * 0.75,
        width: width * 0.85,
        cardTheme: MyCardTheme(imagePath: 'assets/bgs/cardbg1.jpg'),
      ),
    );
  }

  Center getEndCard() {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: 0),
        child: NotificationCard(
          h2Text:
              "You have memorized $_correct/${widget.wordList.subMeanings.length} words!",
          buttonText:
              _incorrectList.length == 0 ? "Go back" : "Review crossed words",
          onTap: () {
            Navigator.pop(context, _incorrectList.length != 0);
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
              Navigator.pop(context);
            },
          ),
        ),
        SizedBox(
          width: 20,
        ),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Text(
            'Memorize words',
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

class LearnCard extends StatefulWidget {
  final double height, width;
  final Color lightColor, darkColor;
  final MyCardTheme cardTheme;
  final int totalWords, currentIndex;
  final FireBaseSubMeaning subMeaning;
  final Function tickAction, crossAction;

  LearnCard(
      {this.height,
      this.width,
      this.lightColor,
      this.cardTheme,
      this.darkColor,
      this.totalWords = 5,
      this.currentIndex = 1,
      @required this.subMeaning,
      this.tickAction,
      this.crossAction});

  @override
  _LearnCardState createState() => _LearnCardState();
}

class _LearnCardState extends State<LearnCard> {
  Widget mainView;
  List<String> items;
  bool selected = false;

  //String eOrM = "M";
  bool wantSetState = false;

  @override
  initState() {
    initialize();
    super.initState();
  }

  void initialize() {
    selected = false;
    mainView = getMeaning();

    widget.subMeaning.examples.length > 2
        ? items = ['Meaning', 'Examples']
        : items = ['Meaning'];
    wantSetState = false;
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
                          startColor: Color(0xFFE0154D),
                          endColor: Color(0xFFFF34AB),
                          text:
                              '${widget.currentIndex} / ${widget.totalWords} Completed',
                        ),
                        SizedBox(
                          width: 7,
                        ),
                        Dot(6),
                        Dot(6),
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
                          top: 20,
                          bottom: 20,
                          left: 5,
                          child: Center(
                            child: Container(
                              width: width,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Dot(5, color: Colors.black),
                                      Text(
                                        "${widget.subMeaning.word}",
                                        style: GoogleFonts.breeSerif(
                                          textStyle: TextStyle(
                                            fontSize: 30,
                                            color: Colors.white,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 25.0, right: 5),
                                    child: AutoSizeText(
                                      "Eg: " +
                                          widget.subMeaning.getFirstExample(),
                                      style: GoogleFonts.courgette(
                                        textStyle: TextStyle(
                                          fontSize: 24,
                                          color: Colors.white,
                                        ),
                                      ),
                                      maxLines: 2,
                                    ),
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
                            onPressed: (String text, int id) {
                              setState(() {
                                wantSetState = true;
                                if (text == "Meaning")
                                  mainView = getMeaning();
                                //eOrM = "M";
                                else
                                  mainView = getExample();
                                //eOrM = "E";
                              });
                            },
                            width: 100,
                            items: items,
                            borderColor: Colors.black54,
                            borderWidth: 0,
                            highlightColor: Colors.red,
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
                        child: ClipOval(
                          child: Material(
                            color: selected ? Colors.white : Colors.red[300],
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  wantSetState = true;
                                  selected = widget.crossAction(
                                      selected, widget.currentIndex);
                                });
                              },
                              splashColor: Colors.red,
                              child: GestureDetector(
                                child: Icon(
                                  Icons.highlight_off,
                                  size: 40,
                                  color: Colors.red[900],
                                ),
                              ),
                            ),
                          ),
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
                      child: ClipOval(
                        child: Material(
                          color: selected ? Colors.lightGreen : Colors.white,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                wantSetState = true;
                                selected = widget.tickAction(
                                    selected, widget.currentIndex);
                              });
                            },
                            splashColor: Colors.greenAccent,
                            child: GestureDetector(
                              child: Icon(
                                Icons.check_circle_outline,
                                size: 40,
                                color: Colors.green[900],
                              ),
                            ),
                          ),
                        ),
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
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DictionaryHomepage(
                                          widget.subMeaning.word)));
                            },
                            width: 150,
                            startColor: Color(0xFFE0154D),
                            endColor: Color(0xFFFF34AB),
                            text: "Open dictionary",
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

  @override
  Widget build(BuildContext context) {
    if (!wantSetState) initialize();
    wantSetState = false;
    //initialize();
    return getCard(widget.height, widget.width);
  }

  Widget getMeaning() {
    Column column = getMeaningView(widget.subMeaning.getSubMeaning());
    for (int i = 1; i < widget.subMeaning.examples.length; i++) {
      column.children.add(getSentence(widget.subMeaning.examples[i]));
      if (i == 1) break;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 5),
      child: column,
    );
  }

  Widget getMeaningView(String headerText) {
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

  Padding getSentence(String example) {
    return Padding(
      padding: const EdgeInsets.only(left: 23.0, top: 5),
      child: Text(
        "➣ " + example,
        style: dictionarySentences,
      ),
    );
  }

  Widget getExample() {
    Column column = getMeaningView("More examples:");
    for (int i = 2; i < widget.subMeaning.examples.length && i < 5; i++) {
      column.children.add(getSentence(widget.subMeaning.examples[i]));
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 5),
      child: column,
    );
  }
}
