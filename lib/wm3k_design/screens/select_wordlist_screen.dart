import 'package:wm3k/analysis_classes/wordList.dart';
import 'package:wm3k/wm3k_design/controllers/user_controller.dart';
import 'package:wm3k/wm3k_design/helper/app_bars.dart';
import 'package:wm3k/wm3k_design/helper/custom_widgets.dart';
import 'package:wm3k/wm3k_design/screens/memorization_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wm3k/wm3k_design/screens/quiz_screen.dart';
import 'package:wm3k/wm3k_design/screens/spellingCard2.dart';
import 'package:wm3k/wm3k_design/themes/color/light_color.dart';

import 'dictionary_page.dart';

class SpellingBeeWelcomePage extends StatelessWidget {
  final promptText;
  final bool searchBar, backButton;
  final Widget header;
  final Color backgroundColor;
  final WordList wordList;

  SpellingBeeWelcomePage(
      {this.promptText = 'Search for a list',
      this.searchBar = true,
      this.backButton = false,
      this.header,
      this.backgroundColor,
      this.wordList});

  @override
  Widget build(BuildContext context) {
    List<WordList> thisList = UserDataController().getAllWordLists();
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
          backgroundColor:
              backgroundColor == null ? Colors.transparent : backgroundColor,
          body: WordListWidget(
            wordLists: thisList,
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
}

class WordListWidget extends StatelessWidget {
  final String promptText;
  final bool searchBar, backButton;
  final Widget header;
  final Color backgroundColor;
  //final WordList wordList;
  final List<WordList> wordLists;

  WordListWidget({
    this.promptText = 'Select a List',
    this.searchBar = false,
    this.backButton = true,
    this.header,
    this.backgroundColor,
    this.wordLists,
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
                  title: "Select \n Word List",
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

    for (int i = 0; i < wordLists.length; i++) {
      list.add(MyListItem(
        separatorColor: Colors.red[200],
        title: wordLists[i].name,
        backgroundColor: Colors.red[700],
        number: (i + 1).toString(),
        checkType: false,
        onTap: (number, title) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SpellingCard2(wordLists[i])));
        },
        description: "${wordLists[i].subMeanings.length} Words.",
        icon: Icon(
          Icons.play_circle_outline,
          size: 30,
        ),
      ));
    }

    return list;
  }
}
