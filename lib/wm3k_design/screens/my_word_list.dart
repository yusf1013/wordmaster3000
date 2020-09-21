import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:toast/toast.dart';
import 'package:wm3k/analysis_classes/wordList.dart';
import 'package:wm3k/wm3k_design/helper/app_bars.dart';
import 'package:wm3k/wm3k_design/helper/custom_widgets.dart';
import 'package:wm3k/wm3k_design/screens/create_and_share_list_screen.dart';
import 'package:wm3k/wm3k_design/screens/memorization_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wm3k/wm3k_design/screens/quiz_screen.dart';
import 'package:wm3k/wm3k_design/themes/color/light_color.dart';

import 'dictionary_page.dart';

class MyWordList extends StatelessWidget {
  final promptText;
  final bool searchBar, backButton;
  final Widget header;
  final Color backgroundColor, dotColor, separatorColor;
  final WordList wordList;
  final BottomNavigationBar bottomNavigationBar;
  final bool deletable;

  MyWordList(
      {this.promptText = 'Search for a list',
      this.searchBar = true,
      this.backButton = false,
      this.header,
      this.backgroundColor,
      this.wordList,
      this.bottomNavigationBar,
      this.deletable = true,
      this.dotColor,
      this.separatorColor});

  BottomNavigationBarItem _bottomIcons(IconData icon, String title) {
    return BottomNavigationBarItem(
      //  backgroundColor: Colors.blue,
      icon: Icon(icon),
      title: Text(
        title,
        style: TextStyle(color: Colors.black),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    WordList thisList = wordList == null
        ? WordList("Title", "Description", [], "-1")
        : wordList;
    return Stack(
      children: <Widget>[
        Container(
          color: Colors.red[50],
          child: Image(
            //image: AssetImage('assets/bgs/listbg (7).png'),
            image: AssetImage('assets/bgs/screenbg5.png'),
            fit: BoxFit.fill,
            color: Color.fromRGBO(255, 255, 255, 0.5),
            colorBlendMode: BlendMode.modulate,
            height: MediaQuery.of(context).size.height + 20,
          ),
        ),
        Scaffold(
          bottomNavigationBar: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(25),
                      topLeft: Radius.circular(25)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black38, spreadRadius: 0, blurRadius: 10),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25.0),
                    topRight: Radius.circular(25.0),
                  ),
                  child: bottomNavigationBar == null
                      ? BottomNavigationBar(
                          showSelectedLabels: true,
                          showUnselectedLabels: true,
                          selectedItemColor: LightColor.darkOrange,
                          //unselectedItemColor: Colors.grey.shade300,
                          //backgroundColor: Colors.lightBlue[100],
                          type: BottomNavigationBarType.fixed,
                          currentIndex: 0,
                          items: [
                            _bottomIcons(Icons.done_all, "View"),
                            _bottomIcons(Icons.info_outline, "Memorize"),
                            _bottomIcons(Icons.help_outline, "Quiz"),
                            _bottomIcons(Icons.share, "Publish")
                          ],
                          onTap: (index) async {
                            if (index == 1)
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          MemorizationCard(wordList)));
                            else if (index == 2)
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          QuizCardScreen(wordList)));
                            else if (index == 3) {
                              bool done = await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return ShareWordListView(wordList);
                                },
                              );
                              String text = "";
                              if (done)
                                text = "Course successfully added!";
                              else
                                text = "Course add failed!";

                              Toast.show(text, context,
                                  duration: Toast.LENGTH_LONG,
                                  gravity: Toast.BOTTOM);
                            }
                          },
                        )
                      : bottomNavigationBar,
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      height: 20,
                      //width: 200,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
          backgroundColor:
              backgroundColor == null ? Colors.transparent : backgroundColor,
          body: WordListWidget(
            wordList: thisList,
            promptText: promptText,
            searchBar: searchBar,
            backButton: backButton,
            header: header,
            backgroundColor: backgroundColor,
            deletable: deletable,
            dotColor: dotColor,
            separatorColor: separatorColor,
          ),
        ),
      ],
    );
  }
}

class WordListWidget extends StatefulWidget {
  final String promptText;
  final bool searchBar, backButton;
  final Widget header;
  final Color backgroundColor, dotColor, separatorColor;
  final WordList wordList;
  final deletable;

  WordListWidget(
      {this.promptText = 'Search for a list',
      this.searchBar = true,
      this.backButton = false,
      this.header,
      this.backgroundColor,
      this.wordList,
      this.deletable = true,
      this.dotColor,
      this.separatorColor});
  @override
  _WordListWidgetState createState() => _WordListWidgetState();
}

class _WordListWidgetState extends State<WordListWidget> {
  String promptText;
  bool searchBar, backButton;
  Widget header;
  Color backgroundColor;
  WordList wordList;

  @override
  void initState() {
    promptText = widget.promptText;
    searchBar = widget.searchBar;
    backButton = widget.backButton;
    header = widget.header;
    backgroundColor = widget.backgroundColor;
    wordList = widget.wordList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            SizedBox(
              height: 105,
            ),
            Expanded(
              //flex: 11,
              child: SingleChildScrollView(
                  child: Container(
                child: Column(
                  children: getListItems(context),
                ),
              )),
            ),
          ],
        ),
        header == null
            ? Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(50),
                      bottomLeft: Radius.circular(50)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black54,
                        spreadRadius: 0,
                        blurRadius: 15,
                        offset: Offset(0, 0)),
                  ],
                ),
                child: HeaderAppBar(
                  title: wordList.name,
                  promptText: promptText,
                  searchBar: searchBar,
                  backButton: backButton,
                ),
              )
            : header,
      ],
    );
  }

  List<Widget> getListItems(BuildContext context) {
    String description = 'Meaning one';
    List<Widget> list = [
      SizedBox(height: 20),
    ];

    for (int i = 0; i < wordList.subMeanings.length; i++) {
      Widget child = MyListItem(
        separatorColor: widget.separatorColor == null
            ? Colors.red[200]
            : widget.separatorColor,
        title: wordList.subMeanings[i].word,
        backgroundColor:
            widget.dotColor == null ? Colors.red[700] : widget.dotColor,
        number: (i + 1).toString(),
        checkType: false,
        onTap: (number, title) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DictionaryHomepage(title)));
        },
        description: wordList.subMeanings[i].subMeaning,
        icon: Icon(
          Icons.play_circle_outline,
          size: 30,
        ),
      );
      if (widget.deletable)
        child = Slidable(
            actionPane: SlidableDrawerActionPane(),
            actionExtentRatio: 0.25,
            child: child,
            secondaryActions: <Widget>[
              IconSlideAction(
                caption: 'Deleted',
                color: Colors.red,
                icon: Icons.delete_forever,
                onTap: () {
                  setState(() {
                    wordList.deleteWord(wordList.subMeanings[i]);
                  });
                  _showSnackBar(context, 'Deleted');
                },
              ),
            ]);
      list.add(child);
    }

    return list;
  }

  void _showSnackBar(BuildContext context, String text) {
    //Scaffold.of(context).showSnackBar(SnackBar(content: Text(text)));
    Toast.show(text, context,
        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
  }
}

/*class _WordListWidgetState extends State<WordListWidget> {
  final String promptText;
  final bool searchBar, backButton;
  final Widget header;
  final Color backgroundColor;
  final WordList wordList;

  _WordListWidgetState({
    this.promptText = 'Search for a list',
    this.searchBar = true,
    this.backButton = false,
    this.header,
    this.backgroundColor,
    this.wordList,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            SizedBox(
              height: 105,
            ),
            Expanded(
              //flex: 11,
              child: SingleChildScrollView(
                  child: Container(
                child: Column(
                  children: getListItems(context),
                ),
              )),
            ),
          ],
        ),
        header == null
            ? Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(50),
                      bottomLeft: Radius.circular(50)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black54,
                        spreadRadius: 0,
                        blurRadius: 15,
                        offset: Offset(0, 0)),
                  ],
                ),
                child: HeaderAppBar(
                  title: wordList.name,
                  promptText: promptText,
                  searchBar: searchBar,
                  backButton: backButton,
                ),
              )
            : header,
      ],
    );
  }

  List<Widget> getListItems(BuildContext context) {
    String description = 'Meaning one';
    List<Widget> list = [
      SizedBox(height: 20),
    ];

    for (int i = 0; i < wordList.subMeanings.length; i++) {
      list.add(Slidable(
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.25,
          child: MyListItem(
            separatorColor: Colors.red[200],
            title: wordList.subMeanings[i].word,
            backgroundColor: Colors.red[700],
            number: (i + 1).toString(),
            checkType: false,
            onTap: (number, title) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DictionaryHomepage(title)));
            },
            description: wordList.subMeanings[i].subMeaning,
            icon: Icon(
              Icons.play_circle_outline,
              size: 30,
            ),
          ),
          secondaryActions: <Widget>[
            IconSlideAction(
              caption: 'Deleted',
              color: Colors.red,
              icon: Icons.delete_forever,
              onTap: () {
                wordList.deleteWord(wordList.subMeanings[i]);
                setState();
                _showSnackBar(context, 'Deleted');
              },
            ),
          ]));
    }

    return list;
  }

  void _showSnackBar(BuildContext context, String text) {
    //Scaffold.of(context).showSnackBar(SnackBar(content: Text(text)));
    Toast.show(text, context,
        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
  }
}*/
