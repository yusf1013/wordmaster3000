import 'package:wm3k/analysis_classes/wordList.dart';
import 'package:wm3k/wm3k_design/helper/app_bars.dart';
import 'package:wm3k/wm3k_design/helper/custom_widgets.dart';
import 'package:wm3k/wm3k_design/themes/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wm3k/wm3k_design/themes/color/light_color.dart';

class MyWordList extends StatelessWidget {
  final promptText;
  final bool searchBar, backButton;
  final Widget header;
  final Color backgroundColor;
  final WordList wordList;

  MyWordList(
      {this.promptText = 'Search for a list',
      this.searchBar = true,
      this.backButton = false,
      this.header,
      this.backgroundColor,
      this.wordList});

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
    WordList thisList =
        wordList == null ? WordList("Title", "Description", [], []) : wordList;
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
                  child: BottomNavigationBar(
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
                    ],
                    onTap: (index) {
                      if (index == 1)
                        Navigator.pushNamed(context, 'memorizePage');
                      else if (index == 2)
                        Navigator.pushNamed(context, 'quizPage');
                    },
                  ),
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
          ),
        ),
      ],
    );
  }

  /*List<Widget> getListItems(BuildContext context) {
    String description = 'Meaning one';
    List<Widget> list = [
      SizedBox(height: 20),
    ];

    for (int i = 0; i < 10; i++) {
      list.add(MyListItem(
        number: (i + 1).toString(),
        checkType: false,
        onTap: (number, title) {
          Navigator.pushNamed(context, 'dictionaryPage', arguments: title);
        },
        description: description,
        icon: Icon(
          Icons.play_circle_outline,
          size: 30,
        ),
      ));
    }

    return list;
  }*/
}

/*
class MyWordListMiniature extends StatelessWidget {
  final String title, promptText;
  final bool searchBar, backButton;
  final Widget header;
  final Color backgroundColor;

  MyWordListMiniature({
    this.title = 'My Word Lists',
    this.promptText = 'Search for a list',
    this.searchBar = true,
    this.backButton = false,
    this.header,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          backgroundColor == null ? AppTheme.nearlyWhite : backgroundColor,
      body: WordListWidget(
        title: title,
        promptText: promptText,
        searchBar: searchBar,
        backButton: backButton,
        header: header,
        backgroundColor: backgroundColor,
      ),
    );
  }

  /*List<Widget> getListItems(BuildContext context) {
    String description = 'Meaning one';
    List<Widget> list = [
      SizedBox(height: 20),
    ];

    for (int i = 0; i < 10; i++) {
      list.add(MyListItem(
        title: 'shit',
        backgroundColor: Colors.red,
        number: (i + 1).toString(),
        checkType: false,
        onTap: (number, title) {
          Navigator.pushNamed(context, 'dictionaryPage', arguments: title);
        },
        description: description,
        icon: Icon(
          Icons.play_circle_outline,
          size: 30,
        ),
      ));
    }

    return list;
  }*/
}
*/

class WordListWidget extends StatelessWidget {
  final String promptText;
  final bool searchBar, backButton;
  final Widget header;
  final Color backgroundColor;
  final WordList wordList;

  WordListWidget({
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

    for (int i = 0; i < wordList.words.length; i++) {
      list.add(MyListItem(
        separatorColor: Colors.red[200],
        title: wordList.words[i],
        backgroundColor: Colors.red[700],
        number: (i + 1).toString(),
        checkType: false,
        onTap: (number, title) {
          Navigator.pushNamed(context, 'dictionaryPage', arguments: title);
        },
        description: wordList.meanings[i],
        icon: Icon(
          Icons.play_circle_outline,
          size: 30,
        ),
      ));
    }

    return list;
  }
}
