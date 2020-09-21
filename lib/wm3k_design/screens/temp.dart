/*
import 'package:card_settings/widgets/card_settings_panel.dart';
import 'package:card_settings/widgets/information_fields/card_settings_header.dart';
import 'package:expandable_bottom_bar/expandable_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:card_settings/card_settings.dart';
import 'package:infinite_cards/infinite_cards.dart';
import 'package:sliding_card/sliding_card.dart';

class Temp extends StatefulWidget {
  @override
  _TempState createState() => _TempState();
}

class _TempState extends State<Temp> {
  InfiniteCardsController _controller;

  Widget _renderItem(BuildContext context, int n) {
    return Container(
      height: 200,
      width: 200,
      color: Colors.red,
    );
  }

  @override
  void initState() {
    super.initState();
    _controller = InfiniteCardsController(
      itemBuilder: _renderItem,
      itemCount: 5,
      animType: AnimType.SWITCH,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        InfiniteCards(
          controller: _controller,
          width: 220,
          height: 220,
          background: Colors.blue,
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              _controller.next();
            });
          },
          child: Container(
            height: 100,
            width: 100,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
*/

/*class Temp extends StatefulWidget {
  @override
  _TempState createState() => _TempState();
}

class _TempState extends State<Temp> {
  String title = "Yes hahaha";
  String author = "Cody Leet";
  String url = "http://www.codyleet.com/spheria";

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          CardSettings(
            shrinkWrap: true,
            children: <Widget>[
              CardSettingsHeader(label: 'Favorite Book'),
              CardSettingsText(
                label: 'Title',
                initialValue: title,
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Title is required.';
                  return '';
                },
                onSaved: (value) => title = value,
              ),
              CardSettingsText(
                label: 'URL',
                initialValue: url,
                validator: (value) {
                  if (!value.startsWith('http:'))
                    return 'Must be a valid website.';
                  return '';
                },
                onSaved: (value) => url = value,
              ),
            ],
          ),
        ],
      ),
    );
  }
}*/

/*import 'package:wm3k/wm3k_design/helper/app_bars.dart';
import 'package:wm3k/wm3k_design/screens/my_word_list.dart';
import 'package:expandable_bottom_bar/expandable_bottom_bar.dart';
import 'package:flutter/material.dart';

import 'dictionary_page.dart';

void main() => runApp(MaterialApp(home: Example()));

class Example extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        'dictionaryPage': (context) => DictionaryHomePage(),
        'wordListPage': (context) => MyWordList(),
      },
      home: DefaultBottomBarController(
        child: Page(),
      ),
    );
  }
}

class Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,

      //Set to true for bottom appbar overlap body content

      appBar: AppBar(
        title: Text("Panel Showcase"),
        backgroundColor: Theme.of(context).bottomAppBarColor,
      ),

      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: GestureDetector(
        // Set onVerticalDrag event to drag handlers of controller for swipe effect
        //onVerticalDragUpdate: DefaultBottomBarController.of(context).onDrag,
        //onVerticalDragEnd: DefaultBottomBarController.of(context).onDragEnd,
        child: FloatingActionButton.extended(
          label: Text("Pull up"),
          elevation: 2,
          backgroundColor: Colors.deepOrange,
          foregroundColor: Colors.white,

          //Set onPressed event to swap state of bottom bar
          onPressed: () => DefaultBottomBarController.of(context).swap(),
        ),
      ),
      bottomNavigationBar: BottomExpandableAppBar(
        expandedHeight: 550,
        horizontalMargin: 16,
        shape: AutomaticNotchedShape(
            RoundedRectangleBorder(), StadiumBorder(side: BorderSide())),
        expandedBackColor: Theme.of(context).backgroundColor,
        expandedBody: MyWordList(
          header: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: SearchBar2(
              widthRatio: 0.6,
              prompText: 'Search the dictionary',
            ),
          ),
          backgroundColor: Colors.lightBlueAccent,
        ),
        bottomAppBarBody: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child: Text(
                  "Tets",
                  textAlign: TextAlign.center,
                ),
              ),
              Spacer(
                flex: 2,
              ),
              Expanded(
                child: Text(
                  "Stet",
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}*/

/*
import 'package:flutter/material.dart';
import 'package:flutter_stack_card/flutter_stack_card.dart';
import 'package:getflutter/components/accordian/gf_accordian.dart';

import 'movie.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Stack Card',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Stack Card'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Movie> _movieData = Movie().movieData;
  var width, height;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: StackCard.builder(
          displayIndicator: false,
          //displayIndicatorBuilder: IdicatorBuilder(displayIndicatorActiveColor: Colors.blue),
          itemCount: _movieData.length,
          onSwap: (index) {
            print("Page change to $index");
          },
          itemBuilder: (context, index) {
            Movie movie = _moviedata()[index];
            return LearnCard(
              height: height * 0.75,
              width: width * 0.85,
              cardTheme: MyCardTheme(imagePath: 'assets/bgs/cardbg1.jpg'),
            );
          },
        ),
      ),
    );
  }

  Widget _itemBuilder(Movie movie) {
    return Container(
      height: 200,
      width: 200,
      color: Colors.red,
    );
  }
}
*/

/*return Container(
      child: Stack(children: <Widget>[
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              color: Colors.white),
        ),
        SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                height: height * .3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  color: Colors.lightBlue,
                ),
              ),
              Container(
                height: height * .45,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            width: 150,
                            child: Text(
                              "Alien: Covenant",
                              style: TextStyle(
                                  color: Colors.blueGrey, fontSize: 24),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              SizedBox(height: 4),
                              Text(
                                "3D",
                                style:
                                    TextStyle(fontSize: 14, color: Colors.grey),
                                textAlign: TextAlign.right,
                              ),
                              SizedBox(height: 12),
                              Text(
                                "IMDB: 6.5",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.right,
                              )
                            ],
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Text("Mystery, Sci-fi",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 16, top: 8),
                          child: Text(
                              "Bound for a remote planet on the far side of the galaxy, members (Katherine Waterston, Billy Crudup) of the colony ship Covenant discover what they think to be an uncharted paradise",
                              style: TextStyle(color: Colors.grey)),
                        ),
                      ),
                      Center(
                        child: IconButton(
                            icon: Icon(Icons.drag_handle, color: Colors.grey),
                            onPressed: () {}),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ]),
    );*/

/*
import 'package:flutter/material.dart';
import 'package:tinder_card/tinder_card.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: TinderSwapCard(
        demoProfiles: demoProfiles,
        myCallback: (decision) {},
      )),
    );
  }
}

//dummy data
final List<Profile> demoProfiles = [
  new Profile(
    photos: [
      "assets/3.jpg",
    ],
    name: "Aneesh G",
    bio: "This is the person you want",
  ),
  new Profile(
    photos: [
      "assets/5.jpeg",
    ],
    name: "Amanda Tylor",
    bio: "You better swpe left",
  ),
  new Profile(
    photos: [
      "assets/7.jpeg",
    ],
    name: "Godson Mathew",
    bio: "You better swpe left",
  ),
  new Profile(
    photos: [
      "assets/9.jpeg",
    ],
    name: "Nigga",
    bio: "You better swpe left",
  ),
];

class Profile {
  List<String> photos;
  String name;
  String bio;

  Profile({this.photos, this.name, this.bio});
}
*/

/*
import 'package:wm3k/wm3k_design/helper/memorization_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:getflutter/components/accordian/gf_accordian.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ExampleHomePage(),
    );
  }
}

class ExampleHomePage extends StatefulWidget {
  @override
  _ExampleHomePageState createState() => _ExampleHomePageState();
}

class _ExampleHomePageState extends State<ExampleHomePage>
    with TickerProviderStateMixin {
  List<String> welcomeImages = [
    "assets/welcome0.png",
    "assets/welcome1.png",
    "assets/welcome2.png",
    "assets/welcome2.png",
    "assets/welcome1.png",
    "assets/welcome1.png"
  ];

  @override
  Widget build(BuildContext context) {
    CardController controller = CardController(); //Use this to trigger swap.

    return new Scaffold(
      body: Column(
        children: <Widget>[
          new Center(
            child: Container(
              //height: MediaQuery.of(context).size.height * 0.9,
              child: new TinderSwapCard(
                orientation: AmassOrientation.BOTTOM,
                totalNum: welcomeImages.length,
                stackNum: 6,
                swipeEdge: 4.0,
                maxWidth: MediaQuery.of(context).size.width * 0.9,
                maxHeight: MediaQuery.of(context).size.width * 0.9,
                minWidth: MediaQuery.of(context).size.width * 0.8,
                minHeight: MediaQuery.of(context).size.width * 0.8,
                cardBuilder: (context, index) => LearnCard(
                  height: MediaQuery.of(context).size.height * 0.75,
                  width: MediaQuery.of(context).size.width * 0.85,
                  cardTheme: MyCardTheme(imagePath: 'assets/bgs/cardbg1.jpg'),
                ),
                cardController: controller,
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
          ),
        ],
      ),
    );
  }
}
*/
/*
import 'package:wm3k/wm3k_design/helper/app_bars.dart';
import 'package:wm3k/wm3k_design/helper/memorization_card.dart';
import 'package:wm3k/wm3k_design/screens/my_word_list.dart';
import 'package:expandable_bottom_bar/expandable_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stack_card/flutter_stack_card.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import 'dictionary_page.dart';

void main() => runApp(MaterialApp(home: PageViewDemo()));

class PageViewDemo extends StatefulWidget {
  @override
  _PageViewDemoState createState() => _PageViewDemoState();
}

class _PageViewDemoState extends State<PageViewDemo> {
  PageController _controller = PageController(
    initialPage: 0,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double width, height;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black54,
      body: Column(
        children: <Widget>[
          /*Swiper(
            itemBuilder: (BuildContext context, int index) {
              return LearnCard(
                height: height * 0.75,
                width: width * 0.93,
                cardTheme: MyCardTheme(imagePath: 'assets/bgs/cardbg1.jpg'),
              );
            },
            itemCount: 100,
            itemWidth: width * 0.98,
            itemHeight: height * 0.9,
            layout: SwiperLayout.TINDER,
          ),*/
          /*Container(
            height: height * 0.8,
            width: width * 0.91,
            child: PageView(
              children: <Widget>[
                LearnCard(
                  height: height * 0.75,
                  width: width * 0.85,
                  cardTheme: MyCardTheme(imagePath: 'assets/bgs/cardbg1.jpg'),
                ),
                LearnCard(
                  height: height * 0.75,
                  width: width * 0.85,
                  cardTheme: MyCardTheme(imagePath: 'assets/bgs/cardbg1.jpg'),
                ),
                LearnCard(
                  height: height * 0.75,
                  width: width * 0.85,
                  cardTheme: MyCardTheme(imagePath: 'assets/bgs/cardbg1.jpg'),
                ),
              ],
            ),
          ),
          Container(
            height: 100,
            width: 100,
            color: Colors.white,
          ),*/
          StackCard.builder(
              itemCount: 10,
              displayIndicator: false,
              //displayIndicatorBuilder: /* Customize the indicator */,
              onSwap: (index) {
                /* listen for swapping */
              },
              itemBuilder: (context, index) {
                return LearnCard(
                  height: height * 0.75,
                  width: width * 0.85,
                  cardTheme: MyCardTheme(imagePath: 'assets/bgs/cardbg1.jpg'),
                );
              })
        ],
      ),
    );
  }
}

class Why extends StatelessWidget {
  final String s;

  Why(this.s);

  @override
  Widget build(BuildContext context) {
    print(s);
    return Image.network(
      "http://via.placeholder.com/288x188",
      fit: BoxFit.fill,
    );
  }
}
*/
