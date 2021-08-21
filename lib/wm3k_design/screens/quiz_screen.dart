import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:wm3k/analysis_classes/wordList.dart';
import 'package:wm3k/wm3k_design/controllers/user_controller.dart';
import 'package:wm3k/wm3k_design/helper/buttons.dart';
import 'package:wm3k/wm3k_design/screens/dictionary_page.dart';
import 'package:wm3k/wm3k_design/screens/notification_card.dart';
import 'package:wm3k/wm3k_design/themes/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

CardController _cardController;
bool _answered = false;
int _selected = -1, _correct = 0, _lastInd = -1;

class QuizCardScreen extends StatefulWidget {
  final WordList _wordList;
  final Function onCorrect, onIncorrect;

  QuizCardScreen(this._wordList, {this.onCorrect, this.onIncorrect});

  @override
  _QuizCardScreenState createState() => _QuizCardScreenState();
}

class _QuizCardScreenState extends State<QuizCardScreen> {
  WordList _wordList;
  Map options;
  UserDataController userDataController = UserDataController();
  List<Map> gm = List();
  bool finished = false;

  @override
  void initState() {
    _cardController = CardController();
    _answered = false;
    _selected = -1;
    _correct = 0;
    _lastInd = -1;

    _wordList = widget._wordList.getShuffledWordList();
    for (int i = 0; i < widget._wordList.subMeanings.length; i++)
      gm.add(
          userDataController.getOptions(_wordList.subMeanings[i].subMeaning));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int totalCards = _wordList.subMeanings.length;

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
                      totalNum: _wordList.subMeanings.length,
                      stackNum: 2,
                      swipeEdge: 100,
                      maxWidth: width - 10,
                      maxHeight: height + 50,
                      minWidth: width - 11,
                      minHeight: height * 0.9,
                      cardBuilder: (context, index) {
                        return Center(
                          child: QuizLearnCard(
                            onCorrect: widget.onCorrect,
                            onIncorrect: widget.onCorrect,
                            subMeaning: _wordList.subMeanings[index],
                            options: gm[index],
                            height: height * 0.81,
                            width: width * 0.85,
                            cardTheme: MyCardTheme(
                                imagePath: 'assets/bgs/cardbg6.jpg'),
                            cardNumber: index + 1,
                            totalCards: _wordList.subMeanings.length,
                          ),
                        );
                      },
                      cardController: _cardController,
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
                        bool tapped;

                        print("Last Index: $_lastInd");
                        if (index == _wordList.subMeanings.length - 1 &&
                            index == _lastInd) {
                          tapped = await showDialog(
                            builder: (context) {
                              return getEndCard();
                            },
                            // child: getEndCard(),
                            context: context,
                          );
                          if (tapped == null || tapped == false)
                            Navigator.pop(context, finished);
                          else if (tapped) {}
                        }

                        /// Get orientation & index of swiped card!
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
    finished = true;
    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: 20),
        child: NotificationCard(
          headerText: "QUIZ",
          h2Text: "Your Score: $_correct/${_wordList.subMeanings.length}\n",
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
              Navigator.pop(context);
            },
          ),
        ),
        SizedBox(
          width: 20,
        ),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Text(
            'Quiz',
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

class QuizLearnCard extends StatefulWidget {
  final double height, width;
  final Color lightColor, darkColor;
  final MyCardTheme cardTheme;
  final FireBaseSubMeaning subMeaning;
  final int cardNumber, totalCards;
  final Map options;
  final Function onCorrect, onIncorrect;

  QuizLearnCard({
    this.height,
    this.width,
    this.lightColor,
    this.cardTheme,
    this.darkColor,
    @required this.subMeaning,
    this.cardNumber,
    this.totalCards,
    @required this.options,
    this.onCorrect,
    this.onIncorrect,
  });

  @override
  _QuizLearnCardState createState() => _QuizLearnCardState();
}

class _QuizLearnCardState extends State<QuizLearnCard> {
  initState() {
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
                              '${widget.cardNumber} / ${widget.totalCards} Completed',
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
                          height: height * 0.25,
                          width: width,
                          child: widget.cardTheme.image,
                        ),
                        Positioned(
                          top: 0,
                          bottom: 0,
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
                                      Dot(5, color: Colors.white),
                                      Expanded(
                                        child: AutoSizeText(
                                          "Meaning of \"${widget.subMeaning.word}\"?",
                                          maxLines: 1,
                                          style: GoogleFonts.breeSerif(
                                            textStyle: TextStyle(
                                              fontSize: 25,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 25.0, top: 10, right: 5),
                                          child: AutoSizeText(
                                            "Eg: ${widget.subMeaning.getFirstExample()}",
                                            maxLines: 2,
                                            style: GoogleFonts.courgette(
                                              textStyle: TextStyle(
                                                  fontSize: 22,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
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
                            height: height * 0,
                            width: 10,
                          ),
                          Tabs(
                            onPressed: () {},
                            width: 100,
                            items: ['Options'],
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
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: height * 0.47,
                        ),
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: getMeaning(),
                          ),
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
                      height: height * 0.1,
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
                            width: 150,
                            onPressed: () async {
                              print("Pressing this button");
                              if (widget.options['answer'] == _selected) {
                                _correct++;
                                //extra
                                print("Correct");
                                if (widget.onCorrect != null)
                                  widget.onCorrect(widget.subMeaning);
                              }
                              print("Incorrect");
                              _answered = false;
                              _selected = -1;
                              _lastInd = widget.cardNumber - 1;
                              _cardController.triggerRight();
                            },
                            startColor: Color(0xFF192221),
                            endColor: Color(0xFFFF34AB),
                            text: "Continue",
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
    return getCard(widget.height, widget.width);
  }

  Widget getMeaning() {
    return MeaningView(widget.options);
  }
}

/*class QuizLearnCard extends StatelessWidget {
  final double height, width;
  final Color lightColor, darkColor;
  final MyCardTheme cardTheme;
  final FireBaseSubMeaning subMeaning;
  final int cardNumber, totalCards;
  final Map options;

  QuizLearnCard({
    this.height,
    this.width,
    this.lightColor,
    this.cardTheme,
    this.darkColor,
    @required this.subMeaning,
    this.cardNumber,
    this.totalCards,
    @required this.options,
  });

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
                          text: '${cardNumber} / ${totalCards} Completed',
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
                          height: height * 0.25,
                          width: width,
                          child: cardTheme.image,
                        ),
                        Positioned(
                          top: 0,
                          bottom: 0,
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
                                      Dot(5, color: Colors.white),
                                      AutoSizeText(
                                        "Meaning of \"${subMeaning.word}\"?",
                                        maxLines: 1,
                                        style: GoogleFonts.breeSerif(
                                          textStyle: TextStyle(
                                            fontSize: 28,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 25.0, top: 10),
                                    child: AutoSizeText(
                                      "Eg: ${subMeaning.getFirstExample()}",
                                      maxLines: 2,
                                      style: GoogleFonts.courgette(
                                        textStyle: TextStyle(
                                            fontSize: 22,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
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
                            height: height * 0,
                            width: 10,
                          ),
                          Tabs(
                            onPressed: () {},
                            width: 100,
                            items: ['Options'],
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
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: height * 0.47,
                        ),
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: getMeaning(),
                          ),
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
                      height: height * 0.1,
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
                            width: 150,
                            onPressed: () {
                              _cardController.triggerRight();
                            },
                            //startColor: Color(0xFFE0154D),
                            //endColor: Color(0xFFFF34AB),
                            startColor: Color(0xFF192221),
                            endColor: Color(0xFFFF34AB),
                            text: "Next Question",
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
    return getCard(height, width);
  }

  Widget getMeaning() {
    print("in get meaning ${options}");
    return MeaningView(options);
  }
}*/

class MeaningView extends StatefulWidget {
  final Map options;

  MeaningView(
    this.options,
  );

  @override
  _MeaningViewState createState() => _MeaningViewState();
}

class _MeaningViewState extends State<MeaningView> {
  //int selected = -1;
  Map options;
  bool wantInit = true;

  initState() {
    init();
    super.initState();
  }

  void init() {
    // print('die');
    options = widget.options;
    //_selected = -1;
    //answered = false;
  }

  Widget getMeaningView() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0, top: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          getOptions(0, options['options'][0]),
          getOptions(1, options['options'][1]),
          getOptions(2, options['options'][2]),
          getOptions(3, options['options'][3]),
        ],
      ),
    );
  }

  Widget getOptions(int id, String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, bottom: 5, right: 15.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: GradientOption(
              correct: id == options['answer'],
              selected: _selected == id,
              width: 254,
              height: 45,
              startColor: Color(0xFFE9E8E6),
              endColor: Colors.white,
              correctColor: Colors.green,
              incorrectColor: Colors.red,
              //startSelectColor: Color(0xFF428EEC),
              //endSelectColor: Color(0xFF5BBFF4),
              //startColor: Color(0xFF192221),
              //endColor: Color(0xFF0887C0),
              onTap: () {
                setState(() {
                  wantInit = false;
                  if (_answered) return;
                  if (_selected == id)
                    _selected = -1;
                  else
                    _selected = id;
                  _answered = true;
                });
              },
              text: text,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (wantInit) init();
    wantInit = true;
    return getMeaningView();
  }
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

class GradientOption extends StatelessWidget {
  final Color startColor, endColor, correctColor, incorrectColor;
  final double height, width;
  final String text;
  final bool selected, correct;
  final Function onTap;

  GradientOption(
      {this.startColor = const Color(0xff374ABE),
      this.endColor = const Color(0xff64B6FF),
      this.height,
      this.text = 'Login',
      this.width,
      this.correctColor,
      this.incorrectColor,
      this.selected,
      this.onTap,
      this.correct});

  @override
  Widget build(BuildContext context) {
    return Container(
      //height: height,
      width: width,
      child: RaisedButton(
        onPressed: onTap,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
        padding: EdgeInsets.all(0.0),
        child: Ink(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: selected
                    ? (correct
                        ? [correctColor, correctColor]
                        : [incorrectColor, incorrectColor])
                    : ((_answered && correct)
                        ? [correctColor, correctColor]
                        : [startColor, endColor]),
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(30.0)),
          child: Container(
            constraints: BoxConstraints(
                maxWidth: 300.0, minHeight: height == null ? 20 : height),
            alignment: Alignment.center,
            child: Row(
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Icon(selected
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked)),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    child: Text(
                      text,
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.black),
                    ),
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
