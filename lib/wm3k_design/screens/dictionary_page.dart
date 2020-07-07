import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:wm3k/analysis_classes/wordList.dart';
import 'package:wm3k/dbConnection/connector.dart';
import 'package:wm3k/dbConnection/dbManager.dart';
import 'package:wm3k/wm3k_design/controllers/user_controller.dart';
import 'package:wm3k/wm3k_design/helper/app_bars.dart';
import 'package:wm3k/wm3k_design/helper/buttons.dart';
import 'package:wm3k/wm3k_design/themes/dictionary_text_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/components/accordian/gf_accordian.dart';
import '../themes/wm3k_app_theme.dart';
import '../helper/custom_widgets.dart';
import 'package:sticky_headers/sticky_headers.dart';

List<WordList> _wordLists;
UserDataController _userDataController = UserDataController();
SearchedWord _word;

class DictionaryHomepage extends StatefulWidget {
  final String word;

  DictionaryHomepage(this.word);

  @override
  _DictionaryHomepageState createState() => _DictionaryHomepageState();
}

class _DictionaryHomepageState extends State<DictionaryHomepage> {
  bool isSpinning = true;
  Widget theWidget;
  initState() {
    theWidget = Container(
      color: Colors.white,
    );
    loadWord();
    super.initState();
  }

  void loadWordLists() {
    print("start");
    _wordLists = _userDataController.getAllWordLists();
    print("end");
    //Start removing shit from here
  }

  void loadWord() async {
    print("Awaiting load word");
    loadWordLists();
    print("Done load word");

    _word = SearchedWord();
    print("Awaiting search word");

    await _word.search(widget.word);
    print("done search word");

    /*DBManager d = DBManager();
    List<String> tempList = List();
    for (int x = 0; x < 10; x++) {
      var r = Random();
      int start = r.nextInt(100000);
      for (int i = 0; i < 10; i++)
        tempList.add(await d.getOnlyFirstSubMeaning(start + i * 10));
    }
    print("DONE DONE mor");
    print(tempList);
    Firestore.instance
        .collection("tempCollection")
        .document("grabageOptions")
        .updateData({'words': tempList});*/

    if (mounted)
      setState(() {
        isSpinning = false;
        theWidget = DictionaryHomePageWidget(
            _word, MeaningListView(_word, _word.posList[0]));
      });
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isSpinning,
      child: theWidget,
    );
  }
}

class DictionaryHomePageWidget extends StatelessWidget {
  //Widget meaningListView = MeaningListView("Noun");
  final Widget meaningListView;
  final int selected;
  final SearchedWord connector;
  DictionaryHomePageWidget(this.connector, this.meaningListView,
      {this.selected = 0});

  @override
  Widget build(BuildContext context) {
    final String s = connector.word;
    final String word = '${s[0].toUpperCase()}${s.substring(1)}';
    //Widget shit = SearchableText("Life is a shit");
    //categoryUI = getCategoryUI(currentList);
    return Container(
      color: DesignCourseAppTheme.nearlyWhite,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Stack(
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  GFAccordion(
                    //title: 'GF Accordion',
                    contentbackgroundColor: DesignCourseAppTheme.nearlyWhite,
                    collapsedTitlebackgroundColor:
                        DesignCourseAppTheme.nearlyWhite,
                    expandedTitlebackgroundColor:
                        DesignCourseAppTheme.nearlyWhite,
                    titleChild: Row(
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
                        Expanded(
                          child: Container(),
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text('Definition'),
                            ]),
                        Expanded(
                          child: Container(),
                        ),
                      ],
                    ),
                    //content: "Shit",
                    contentChild: SearchBarUI(
                      padding: EdgeInsets.all(0),
                      widthRatio: 0.88,
                      onSubmit: (str) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DictionaryHomepage(str)));
                      },
                    ),
                    collapsedIcon: Icon(Icons.search),
                    expandedIcon: Icon(Icons.cancel),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(25, 20, 25, 0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: AutoSizeText(
                                word,
                                style: headWord,
                                maxLines: 1,
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.volume_up,
                                size: 35,
                              ),
                              onPressed: () {},
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 25,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Tabs(
                      selected: selected,
                      borderWidth: 0.5,
                      items: connector.getPartsOfSpeechList(),
                      onPressed: ((String pos, int id) {
                        print("TABS: $id");
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DictionaryHomePageWidget(
                                      connector,
                                      pos != "More"
                                          ? MeaningListView(connector, pos)
                                          : MoreListView(connector),
                                      selected: id,
                                    )));
                      }),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      //width: MediaQuery.of(context).size.width * 85,
                      height: 3,
                      color: Colors.blue[900],
                    ),
                  ),
                  meaningListView,
                  //SearchableText("Life is a shit"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/*class DictionaryHomePageWidget extends StatefulWidget {
  final SearchedWord connector;
  DictionaryHomePageWidget(this.connector);

  @override
  _DictionaryHomePageStateWidget createState() =>
      _DictionaryHomePageStateWidget();
}

class _DictionaryHomePageStateWidget extends State<DictionaryHomePageWidget> {
  //Widget meaningListView = MeaningListView("Noun");
  Widget meaningListView;

  @override
  void initState() {
    meaningListView =
        MeaningListView(widget.connector, widget.connector.posList[0]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final String s = widget.connector.word;
    final String word = '${s[0].toUpperCase()}${s.substring(1)}';
    //Widget shit = SearchableText("Life is a shit");
    //categoryUI = getCategoryUI(currentList);
    return Container(
      color: DesignCourseAppTheme.nearlyWhite,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Stack(
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  GFAccordion(
                    //title: 'GF Accordion',
                    contentbackgroundColor: DesignCourseAppTheme.nearlyWhite,
                    collapsedTitlebackgroundColor:
                        DesignCourseAppTheme.nearlyWhite,
                    expandedTitlebackgroundColor:
                        DesignCourseAppTheme.nearlyWhite,
                    titleChild: Row(
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
                        Expanded(
                          child: Container(),
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text('Definition'),
                            ]),
                        Expanded(
                          child: Container(),
                        ),
                      ],
                    ),
                    //content: "Shit",
                    contentChild: SearchBarUI(
                      padding: EdgeInsets.all(0),
                      widthRatio: 0.88,
                      onSubmit: (str) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DictionaryHomepage(str)));
                      },
                    ),
                    collapsedIcon: Icon(Icons.search),
                    expandedIcon: Icon(Icons.cancel),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(25, 20, 25, 0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: AutoSizeText(
                                word,
                                style: headWord,
                                maxLines: 1,
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.volume_up,
                                size: 35,
                              ),
                              onPressed: () {},
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 25,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Tabs(
                      borderWidth: 0.5,
                      items: widget.connector.getPartsOfSpeechList(),
                      onPressed: ((String pos) {
                        setState(() {
                          meaningListView = pos == "More"
                              ? MoreListView(widget.connector)
                              : MeaningListView(widget.connector, pos);
                        });
                      }),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      //width: MediaQuery.of(context).size.width * 85,
                      height: 3,
                      color: Colors.blue[900],
                    ),
                  ),
                  meaningListView,
                  //SearchableText("Life is a shit"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}*/

class Tabs extends StatefulWidget {
  final Function onPressed;
  final double width, borderWidth;
  final List<String> items;
  final Color highlightColor, borderColor, textColor;
  final int selected;

  Tabs({
    this.onPressed,
    this.width,
    this.items = const ["Noun", "Verb", "Adjective", "More"],
    this.borderWidth = 3,
    this.highlightColor,
    this.borderColor,
    this.textColor,
    this.selected = 0,
  });

  @override
  _TabsState createState() => _TabsState(onPressed, selected: selected);
}

class _TabsState extends State<Tabs> {
  int selected;
  Function onPressed;

  _TabsState(this.onPressed, {this.selected = 0});

  Widget getTile(int id, String text) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selected = id;
          onPressed(text, id);
        });
        //print(MediaQuery.of(context).size);
      },
      child: Tab(selected == id, text, widget.highlightColor, widget.textColor),
    );
  }

  List<Widget> getWidgets() {
    List<Widget> list = [];
    for (int i = 0; i < widget.items.length; i++)
      list.add(getTile(i, widget.items[i]));

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  color: widget.borderColor == null
                      ? Colors.blue[900]
                      : widget.borderColor,
                  width: widget.borderWidth))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SingleChildScrollView(
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  minWidth: widget.width == null
                      ? MediaQuery.of(context).size.width - 40
                      : widget.width),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: getWidgets(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Tab extends StatelessWidget {
  final bool isSelected;
  final String text;
  final Color highlightColor, highlightTextColor;

  Tab(this.isSelected, this.text, this.highlightColor, this.highlightTextColor);

  @override
  Widget build(BuildContext context) {
    Color color = highlightColor == null ? Colors.blue[900] : highlightColor;
    Color textColor =
        highlightTextColor == null ? Colors.blue[900] : highlightTextColor;
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 8, 16, 0),
      child: Container(
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    color: isSelected ? color : Colors.transparent,
                    width: isSelected ? 2.5 : 0))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: Container(
                child: Text(
                  text,
                  style: isSelected
                      ? TextStyle(
                          fontSize: 20,
                          color: textColor,
                          fontWeight: FontWeight.bold)
                      : tabWord,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}

class MeaningListView extends StatelessWidget {
  /*final Meaning meaning;
  final String word;*/

  final SearchedWord connector;
  final String pos;

  MeaningListView(this.connector, this.pos);
  //MeaningListView(this.meaning, this.word);

  List<Widget> getChildren() {
    List<Widget> list = new List();

    for (Meaning meaning in connector.getParticularPOS(pos)) {
      list.add(addEntireOneMeaning(connector.word, meaning));
    }

    return list;
  }

  Widget addEntireOneMeaning(String word, Meaning meaning) {
    List<Widget> list = new List();
    //list.add(singleMeaning(1));
    //list.add(singleMeaning(2));
    for (int i = 0; i < meaning.subMeaning.length; i++)
      list.add(singleMeaning(i, meaning));

    list.add(Divider(
      thickness: 1.5,
    ));

    if (meaning.moreExample.length > 0)
      addExtraExamples(list, meaning.moreExample, heading: "Extra Examples");
    if (meaning.synonyms.length > 0) addSynonyms(list, meaning);
    //addSaveToListOptions(list, meaning); //MES: It was here first
    return StickyHeader(
      header: getHeader(word, meaning),
      content: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
        child: Column(
          children: list,
        ),
      ),
    );
  }

  List<Widget> getSubMeaningList(int n, Meaning meaning) {
    SubMeaning thisSubMeaning = meaning.subMeaning[n];
    bool listTooLong = thisSubMeaning.examples.length > 3;
    List<Widget> children = new List();
    //addHeader(children);
    //
    addMeaning(children, n, thisSubMeaning);
    addExamples(children, listTooLong, thisSubMeaning);
    if (listTooLong)
      addExtraExamples(children, thisSubMeaning.examples.sublist(3));
    addSaveToListOptions(children, meaning, n, meaning.id);
    //addExtraExamples(children, partsOfSpeech.moreExample);
    //addSynonyms(children);

    return children;
  }

  Widget getHeader(String word, Meaning meaning) {
    return Material(
      color: Colors.blue[100],
      elevation: 5,
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 5),
                  child: Dot(
                    5,
                    color: Colors.indigo[700],
                  ),
                ),
                Expanded(
                  child: Text(
                    "${word[0].toUpperCase() + word.substring(1)} : ${meaning.partsOfSpeech} ${meaning.meaning}",
                    style: GoogleFonts.courgette(
                        textStyle: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo[700])),
                  ),
                ),
              ],
            ),
          ),
          /*Divider(
            thickness: 1.5,
          ),*/
          Container(
            height: 3,
            color: Colors.black26,
          ),
        ],
      ),
    );
  }

  void addExamples(
      List<Widget> children, bool listTooLong, SubMeaning thisMeaning) {
    children.add(Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 7),
      child: UnorderedList(
        /*list: [
          "The first sentence",
          "The second sentence",
          "The third sentence",
        ],*/
        list: listTooLong
            ? thisMeaning.examples.sublist(0, 3)
            : thisMeaning.examples,
        style: dictionarySentences,
        lineSpacing: 5.0,
      ),
    ));
  }

  void addMeaning(List<Widget> children, int n, SubMeaning thisSubMeaning) {
    children.add(Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          (n + 1).toString() + ".   ",
          style: dictionaryNumber,
        ),
        Expanded(
          /*child: SearchableText(
            thisMeaning.meaning[0].toUpperCase() +
                thisMeaning.meaning.substring(1),
            style: dictionaryWords,
            wrapLength: 30,
          ),*/
          child: Text(
            thisSubMeaning.subMeaning[0].toUpperCase() +
                thisSubMeaning.subMeaning.substring(1),
            style: dictionaryWords,
            textAlign: TextAlign.justify,
          ),
        ),
      ],
    ));
    children.add(SizedBox(
      width: 5,
    ));
  }

  void addSaveToListOptions(
      List<Widget> children, Meaning meaning, int index, int id) {
    children.add(SaveMeaningToList(children, meaning, index, id));
  }

  void addSynonyms(List<Widget> children, Meaning meaning) {
    children.add(GFAccordion(
      titleChild: Text(
        "Synonyms and related words",
        style: dictionarySentences,
      ),
      contentChild: UnorderedList(
        list: meaning.synonyms,
        style: dictionarySentences,
        lineSpacing: 5.0,
      ),
    ));
  }

  void addExtraExamples(List<Widget> children, List<String> givenList,
      {String heading = "More Examples"}) {
    children.add(GFAccordion(
      titleChild: Text(
        heading,
        style: dictionarySentences,
      ),
      contentChild: UnorderedList(
        list: givenList,
        style: dictionarySentences,
        lineSpacing: 5.0,
      ),
    ));
  }

  Widget singleMeaning(int n, Meaning meaning) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
            bottom: 12.0,
          ),
          child: Column(
            children: getSubMeaningList(n, meaning),
          ),
        ),
        Divider(
          thickness: 1.5,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
        child: Container(
          height: 250,
          //width: 250,
          color: Colors.blue[50],
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
            child: ListView(
              children: getChildren(),
            ),
          ),
        ),
      ),
    );
  }
}

class SaveToListButton extends StatefulWidget {
  final String text, id;
  final int subMeaningIndex, meaningID;
  final Meaning meaning;
  final bool selected;

  SaveToListButton(this.text, this.id, this.meaning, this.subMeaningIndex,
      this.selected, this.meaningID);

  @override
  _SaveToListButtonState createState() => _SaveToListButtonState(text);
}

class _SaveToListButtonState extends State<SaveToListButton> {
  bool selected;
  String text;

  _SaveToListButtonState(this.text);

  @override
  void initState() {
    // TODO: implement initState
    selected = widget.selected;
    print("In inis state $selected");
    print("Add save to list ${widget.id}");
    super.initState();
  }

  void _showToast(BuildContext context, String message) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(milliseconds: 1000),
        action: SnackBarAction(
            label: 'UNDO',
            onPressed: () {
              scaffold.hideCurrentSnackBar;
              setState(() {
                selected = false;
              });
            }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("Now this is shit ${widget.meaningID} ${widget.selected}");
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            text,
            style: dictionarySentences,
          ),
          /*GestureDetector(
            child:
                selected ? Icon(Icons.favorite) : Icon(Icons.favorite_border),
            onTap: () {
              setState(() {
                selected = !selected;
                _userDataController.addWordToList(widget.id, _word.word,
                    widget.meaning, selected, widget.subMeaningIndex);
              });
              if (selected)
                _showToast(context, 'Added to $text');
              else {
                Scaffold.of(context).removeCurrentSnackBar();
              }
            },
          )*/
          RowButton(
            selected,
            () {
              setState(() {
                selected = !selected;
                _userDataController.addWordToList(widget.id, _word.word,
                    widget.meaning, selected, widget.subMeaningIndex);
              });
              if (selected)
                _showToast(context, 'Added to $text');
              else {
                Scaffold.of(context).removeCurrentSnackBar();
              }
            },
          ),
        ],
      ),
    );
  }
}

class RowButton extends StatelessWidget {
  final bool selected;
  final Function onTap;

  RowButton(this.selected, this.onTap);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: selected ? Icon(Icons.favorite) : Icon(Icons.favorite_border),
      onTap: onTap,
    );
  }
}

class MoreListView extends StatelessWidget {
  final SearchedWord con;

  MoreListView(this.con);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
        child: Container(
          height: 250,
          //width: 250,
          color: Colors.blue[50],
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
            child: ListView(
              children: getChildren(),
            ),
          ),
        ),
      ),
    );
  }

  Widget getListItems(List<String> givenList) {
    List<Widget> list = new List();
    for (String string in givenList)
      list.add(GestureDetector(
        onTap: () {},
        child: Text(
          string,
          style: dictionaryIdiomsAndPhrases,
        ),
      ));
    /*list.addAll([
      GestureDetector(
        onTap: () {},
        child: Text(
          "Item number one",
          style: dictionaryIdiomsAndPhrases,
        ),
      ),
      GestureDetector(
        onTap: () {},
        child: Text(
          "Item number one",
          style: dictionaryIdiomsAndPhrases,
        ),
      ),
      GestureDetector(
        onTap: () {},
        child: Text(
          "Item number one",
          style: dictionaryIdiomsAndPhrases,
        ),
      ),
    ]);*/
    return UnorderedList(
      //listOfWid: list,
      list: givenList,
      style: dictionaryIdiomsAndPhrases,
      lineSpacing: 7,
    );
  }

  List<Widget> getChildren() {
    List<Widget> list = new List();
    list.addAll([
      GFAccordion(
        titleChild: Text(
          "Idioms",
          style: dictionaryWords,
        ),
        contentChild: getListItems(con.idioms),
      ),
      GFAccordion(
        titleChild: Text(
          "Phrasal verbs",
          style: dictionaryWords,
        ),
        contentChild: getListItems(con.phrases),
      ),
    ]);
    return list;
  }
}

class SaveMeaningToList extends StatelessWidget {
  final List<Widget> children;
  final Meaning meaning;
  final int index, id;

  SaveMeaningToList(this.children, this.meaning, this.index, this.id);

  @override
  Widget build(BuildContext context) {
    List<Widget> listViewChildren = List();
    for (WordList list in _wordLists)
      listViewChildren.add(SaveToListButton(list.name, list.id, meaning, index,
          list.hasWord(meaning.id.toString(), index), id));

    return GFAccordion(
      titleChild: Text(
        "Save meaning to a list",
        style: dictionarySentences,
      ),
      contentChild: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 100),
        child: ListView(
          children: listViewChildren,
        ),
      ),
      collapsedIcon: Icon(Icons.favorite_border),
      expandedIcon: Icon(Icons.cancel),
    );
  }
}
