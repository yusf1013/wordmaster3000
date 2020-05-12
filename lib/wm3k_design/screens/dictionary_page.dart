import 'package:wm3k/dbConnection/connector.dart';
import 'package:wm3k/wm3k_design/helper/app_bars.dart';
import 'package:wm3k/wm3k_design/themes/dictionary_text_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/components/accordian/gf_accordian.dart';
import '../themes/wm3k_app_theme.dart';
import '../helper/custom_widgets.dart';

class DictionaryHomePage extends StatefulWidget {
  @override
  _DictionaryHomePageState createState() => _DictionaryHomePageState();
}

class _DictionaryHomePageState extends State<DictionaryHomePage> {
  Widget meaningListView = MeaningListView("Noun");

  printSearch(String word) async {
    SearchedWord con = new SearchedWord();
    //Word searched= Word();
    await con.search(word);
    String wordfound = con.word;
    if (word == wordfound) {
      print(" the properties for $wordfound");

      for (Meaning pos in con.searchedWordMeaning) {
        for (SubMeaning submeaningobject in pos.sub_meaning) {
          print('${pos.partsOfSpeech}:');
          print(submeaningobject.submeaning);
          for (String example in submeaningobject.example) print(example);
        }
        for (String moreExamples in pos.moreExample) print(moreExamples);
        for (String synonyms in pos.synonyms) print(synonyms);
        for (String idioms in con.idioms) print(idioms);
        for (String phrases in con.phrases) print(phrases);

        print('\n\n');
      }

      /*for (var i = 0; i < con.property.length; i++) {
        PartsOfSpeech localproperty = con.property[i];
        String partsofspeech = con.property[i].parts_of_speech;
        print("it $partsofspeech");
        print("meaning\n\n");
        for (var j = 0; j < localproperty.meaning.length; j++) {
          Meaning localmeaning = localproperty.meaning[j];
          int meaningid = localmeaning.meaning_id;
          print("meaning id is $meaningid");

          String meaning = localmeaning.meaning;
          print(meaning);

          for (var k = 0; k < localmeaning.example.length; k++) {
            print(localmeaning.example[k]);
          }
        }

        print("synonyms");
        for (var i = 0; i < localproperty.synonyms.length; i++) {
          print(localproperty.synonyms[i]);
        }
        print("more example");
        for (var i = 0; i < localproperty.more_example.length; i++) {
          //print("more example");
          print(localproperty.more_example[i]);
        }
      }
      for (var i = 0; i < con.idioms.length; i++) {
        print(con.idioms[i]);
      }
      print("phrases");
      for (var i = 0; i < con.phrases.length; i++) {
        print(con.phrases[i]);
      }*/
    } else {
      print("Found nothing for $word");
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final String s = ModalRoute.of(context).settings.arguments;
    final String word = '${s[0].toUpperCase()}${s.substring(1)}';
    //Widget shit = SearchableText("Life is a shit");
    printSearch(word);
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
                  Padding(
                    padding: EdgeInsets.fromLTRB(25, 80, 25, 0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              word,
                              style: headWord,
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
                      onPressed: ((String pos) {
                        setState(() {
                          meaningListView = pos == "More"
                              ? MoreListView()
                              : MeaningListView(pos);
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
              GFAccordion(
                //title: 'GF Accordion',
                contentbackgroundColor: DesignCourseAppTheme.nearlyWhite,
                collapsedTitlebackgroundColor: DesignCourseAppTheme.nearlyWhite,
                expandedTitlebackgroundColor: DesignCourseAppTheme.nearlyWhite,
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
                    Navigator.popAndPushNamed(context, 'dictionaryPage',
                        arguments: str);
                  },
                ),
                collapsedIcon: Icon(Icons.search),
                expandedIcon: Icon(Icons.cancel),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Tabs extends StatefulWidget {
  final Function onPressed;
  final double width, borderWidth;
  final List<String> items;
  final Color highlightColor, borderColor, textColor;

  Tabs({
    this.onPressed,
    this.width,
    this.items = const ["Noun", "Verb", "Adjective", "More"],
    this.borderWidth = 3,
    this.highlightColor,
    this.borderColor,
    this.textColor,
  });

  @override
  _TabsState createState() => _TabsState(onPressed);
}

class _TabsState extends State<Tabs> {
  int selected = 0;
  Function onPressed;

  _TabsState(this.onPressed);

  Widget getTile(int id, String text) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selected = id;
          onPressed(text);
        });
        //print(MediaQuery.of(context).size);
      },
      child: Tab(selected == id, text, widget.highlightColor, widget.textColor),
    );
  }

  List<Widget> getWidgets() {
    List<Widget> list = [
      /*getTile(0, "Noun"),
      getTile(1, "Verb"),
      getTile(2, "Adjective"),
      getTile(3, "More"),*/
      //getTile(4, "Pronoun"),
    ];
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          fontSize: 22,
                          color: textColor,
                          fontWeight: FontWeight.bold)
                      : tabWord,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            /*FittedBox(
              fit: BoxFit.contain,
              child: Container(
                height: isSelected ? 2.5 : 0.1,
                width: isSelected ? text.length * 15.0 : 1.0,
                decoration: BoxDecoration(color: Colors.blue[900]),
              ),
            ),*/
          ],
        ),
      ),
    );
  }
}

class MeaningListView extends StatelessWidget {
  final String pos;

  MeaningListView(this.pos);

  List<Widget> getChildren() {
    List<Widget> list = new List();
    list.add(singleMeaning(1));
    list.add(singleMeaning(2));
    return list;
  }

  List<Widget> getMeaningList(int n) {
    List<Widget> children = new List();
    children.add(Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          n.toString() + ".   ",
          style: dictionaryNumber,
        ),
        Expanded(
          child: SearchableText(
            "New $pos meaning of word:",
            style: dictionaryWords,
            wrapLength: 28,
          ),
        ),
      ],
    ));
    children.add(SizedBox(
      width: 5,
    ));
    children.add(Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 7),
      child: UnorderedList(
        list: [
          "The first sentence",
          "The second sentence",
          "The third sentence",
        ],
        style: dictionarySentences,
        lineSpacing: 5.0,
      ),
    ));
    children.add(GFAccordion(
      titleChild: Text(
        "More Examples",
        style: dictionarySentences,
      ),
      contentChild: UnorderedList(
        list: [
          "The first extra sentence",
          "The second extra sentence",
          "The third extra sentence",
        ],
        style: dictionarySentences,
        lineSpacing: 5.0,
      ),
    ));
    children.add(GFAccordion(
      titleChild: Text(
        "Synonyms and related words",
        style: dictionarySentences,
      ),
      contentChild: UnorderedList(
        list: [
          "The first synonym",
          "The second synonym",
          "The third synonym",
        ],
        style: dictionarySentences,
        lineSpacing: 5.0,
      ),
    ));
    children.add(GFAccordion(
      titleChild: Text(
        "Save meaning to a list",
        style: dictionarySentences,
      ),
      contentChild: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 100),
        child: ListView(
          children: <Widget>[
            SaveToListButton("Word List 1"),
            SaveToListButton("Word List 2"),
          ],
        ),
      ),
      collapsedIcon: Icon(Icons.favorite_border),
      expandedIcon: Icon(Icons.cancel),
    ));

    return children;
  }

  Widget singleMeaning(int n) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        children: getMeaningList(n),
      ),
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
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
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
  final String text;

  SaveToListButton(this.text);

  @override
  _SaveToListButtonState createState() => _SaveToListButtonState(text);
}

class _SaveToListButtonState extends State<SaveToListButton> {
  bool selected = false;
  String text;

  _SaveToListButtonState(this.text);

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
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            text,
            style: dictionarySentences,
          ),
          GestureDetector(
            child:
                selected ? Icon(Icons.favorite) : Icon(Icons.favorite_border),
            onTap: () {
              setState(() {
                selected = !selected;
              });
              if (selected)
                _showToast(context, 'Added to $text');
              else {
                Scaffold.of(context).removeCurrentSnackBar();
                print("shit");
              }
            },
          )
        ],
      ),
    );
  }
}

class MoreListView extends StatelessWidget {
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

  Widget getListItems() {
    List<Widget> list = new List();
    list.addAll([
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
    ]);
    return UnorderedList(
      listOfWid: list,
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
        contentChild: getListItems(),
      ),
      GFAccordion(
        titleChild: Text(
          "Phrasal verbs",
          style: dictionaryWords,
        ),
        contentChild: getListItems(),
      ),
    ]);
    return list;
  }
}
