import 'package:wm3k/wm3k_design/helper/app_bars.dart';
import 'package:wm3k/wm3k_design/helper/custom_widgets.dart';
import 'package:wm3k/wm3k_design/themes/app_theme.dart';
import 'package:wm3k/wm3k_design/themes/color/light_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyWordList extends StatelessWidget {
  final String title, promptText;
  final bool searchBar, backButton;
  final Widget header;
  final Color backgroundColor;

  MyWordList({
    this.title = 'My Word Lists',
    this.promptText = 'Search for a list',
    this.searchBar = true,
    this.backButton = false,
    this.header,
    this.backgroundColor,
  });

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
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedItemColor: LightColor.extraDarkPurple,
        unselectedItemColor: Colors.grey.shade300,
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
          else if (index == 2) Navigator.pushNamed(context, 'quizPage');
        },
      ),
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

  List<Widget> getListItems(BuildContext context) {
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
  }
}

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

  List<Widget> getListItems(BuildContext context) {
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
  }
}

class WordListWidget extends StatelessWidget {
  final String title, promptText;
  final bool searchBar, backButton;
  final Widget header;
  final Color backgroundColor;

  WordListWidget({
    this.title = 'My Word Lists',
    this.promptText = 'Search for a list',
    this.searchBar = true,
    this.backButton = false,
    this.header,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        header == null
            ? HeaderAppBar(
                title: title,
                promptText: promptText,
                searchBar: searchBar,
                backButton: backButton,
              )
            : header,
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
    );
  }

  List<Widget> getListItems(BuildContext context) {
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
  }
}
