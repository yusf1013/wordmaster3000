import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:wm3k/wm3k_design/helper/buttons.dart';
import 'package:wm3k/wm3k_design/screens/dictionary_page.dart';
import 'package:wm3k/wm3k_design/themes/app_theme.dart';
import 'package:wm3k/wm3k_design/themes/dictionary_text_theme.dart';
import 'package:wm3k/wm3k_design/themes/wm3k_app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:google_fonts/google_fonts.dart';

class MemorizationCard2 extends StatefulWidget {
  @override
  _MemorizationCard2State createState() => _MemorizationCard2State();
}

class _MemorizationCard2State extends State<MemorizationCard2> {
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
                  /*Container(
                    height: height * 0.835,
                    //height: height * 0.86,
                    width: width * 0.906,
                    child: PageView(
                      children: <Widget>[
                        Center(
                          child: LearnCard(
                            height: height * 0.75,
                            width: width * 0.85,
                            cardTheme:
                                MyCardTheme(imagePath: 'assets/bgs/cardbg.jpg'),
                          ),
                        ),
                        LearnCard(
                          height: height * 0.75,
                          width: width * 0.85,
                          cardTheme:
                              MyCardTheme(imagePath: 'assets/bgs/cardbg.jpg'),
                        ),
                        LearnCard(
                          height: height * 0.75,
                          width: width * 0.85,
                          cardTheme:
                              MyCardTheme(imagePath: 'assets/bgs/cardbg.jpg'),
                        ),
                      ],
                    ),
                  ),*/
                  /*LearnCard(
                    height: height * 0.75,
                    width: width * 0.85,
                    cardTheme: MyCardTheme(imagePath: 'assets/bgs/cardbg.jpg'),
                  ),*/
                  /*Container(
                    height: height * 0.9,
                    width: width,
                    child: ListView(
                      children: <Widget>[
                        LearnCard(
                          height: height * 0.75,
                          width: width * 0.85,
                          cardTheme:
                              MyCardTheme(imagePath: 'assets/bgs/cardbg.jpg'),
                        ),
                        LearnCard(
                          height: height * 0.75,
                          width: width * 0.85,
                          cardTheme:
                              MyCardTheme(imagePath: 'assets/bgs/cardbg.jpg'),
                        ),
                      ],
                    ),
                  ),*/
                  /*new Swiper(
                    itemBuilder: (BuildContext context, int index) {
                      return LearnCard(
                        height: height * 0.75,
                        width: width * 0.85,
                        cardTheme:
                            MyCardTheme(imagePath: 'assets/bgs/cardbg.jpg'),
                        word: 'word - $index',
                      );
                    },
                    itemCount: 3,
                    itemWidth: width * 0.92,
                    itemHeight: height * 0.75,
                    layout: SwiperLayout.TINDER,
                    containerHeight: height,
                    viewportFraction: 0.5,
                  )*/
                  Container(
                    width: width * 1,
                    height: height * 0.9,
                    child: TinderSwapCard(
                      orientation: AmassOrientation.LEFT,
                      totalNum: 6,
                      stackNum: 3,
                      swipeEdge: 4.0,
                      maxWidth: width - 10,
                      maxHeight: height + 50,
                      minWidth: width - 11,
                      minHeight: height * 0.9,
                      cardBuilder: (context, index) => Center(
                        child: LearnCard(
                          height: height * 0.75,
                          width: width * 0.85,
                          cardTheme:
                              MyCardTheme(imagePath: 'assets/bgs/cardbg.jpg'),
                        ),
                      ),
                      cardController: CardController(),
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
                          (CardSwipeOrientation orientation, int index) {
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
  final String word;

  LearnCard({
    this.height,
    this.width,
    this.lightColor,
    this.cardTheme,
    this.darkColor,
    this.word = 'word',
  });

  @override
  _LearnCardState createState() => _LearnCardState();
}

class _LearnCardState extends State<LearnCard> {
  Widget mainView;

  @override
  initState() {
    mainView = getMeaning();
    super.initState();
  }

  Widget getCard(double height, double width) {
    print(height);
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
                          text: '1 / 2 Completed',
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
                                      getDot(5, color: Colors.black),
                                      Text(
                                        "The ${widget.word}",
                                        style: GoogleFonts.breeSerif(
                                          textStyle: TextStyle(
                                            fontSize: 30,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 25.0),
                                    child: Text(
                                      "The sentence with the word",
                                      style: GoogleFonts.courgette(
                                        textStyle: TextStyle(
                                          fontSize: 26,
                                          color: Colors.white,
                                        ),
                                      ),
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
                            onPressed: (String text) {
                              setState(() {
                                if (text == "Meaning")
                                  mainView = getMeaning();
                                else
                                  mainView = getExample();
                              });
                            },
                            width: 100,
                            items: ['Meaning', 'Examples'],
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
                            child: InkWell(
                              onTap: () {},
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
                          child: InkWell(
                            onTap: () {},
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
    return getCard(widget.height, widget.width);
  }

  Widget getMeaning() {
    return Column(
      children: <Widget>[
        getMeaningView(),
      ],
    );
  }

  Widget getMeaningView() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              getDot(4, color: Colors.black),
              Text(
                "The elaborate first meaning",
                style: dictionaryWords,
              ),
            ],
          ),
          SizedBox(
            height: 3,
          ),
          getSentence(),
          getSentence(),
          getSentence(),
        ],
      ),
    );
  }

  Padding getSentence() {
    return Padding(
      padding: const EdgeInsets.only(left: 23.0, top: 5),
      child: Text(
        "Sentence number one",
        style: dictionarySentences,
      ),
    );
  }

  Widget getExample() {
    return getMeaning();
  }
}