import 'package:wm3k/wm3k_design/themes/color/light_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/components/avatar/gf_avatar.dart';
import 'package:getflutter/components/list_tile/gf_list_tile.dart';
import 'package:getflutter/size/gf_size.dart';
import 'package:google_fonts/google_fonts.dart';

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}

class UnorderedList extends StatelessWidget {
  final List<String> list;
  final double bulletSize, lineSpacing;
  final TextStyle style;
  final List<Widget> listOfWid;

  UnorderedList(
      {this.list,
      this.bulletSize = 6.5,
      this.style,
      this.lineSpacing = 0,
      this.listOfWid});

  Widget getBullet() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7.5, horizontal: 5),
      child: Container(
        height: bulletSize,
        width: bulletSize,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(bulletSize / 2.0),
          color: Colors.black,
        ),
      ),
    );
  }

  Widget getBulletList(BuildContext context) {
    List<Widget> lines = new List();

    for (String s in list) {
      lines.add(
        Padding(
          padding: EdgeInsets.only(bottom: lineSpacing),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              getBullet(),
              Expanded(
                child: Text(
                  " $s",
                  style: style == null ? TextStyle() : style,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: lines,
    );
  }

  Widget getBulletListWithWids(BuildContext context) {
    List<Widget> lines = new List();

    for (Widget widget in listOfWid) {
      lines.add(
        Padding(
          padding: EdgeInsets.only(bottom: lineSpacing),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              getBullet(),
              widget,
            ],
          ),
        ),
      );
    }

    return Column(
      children: lines,
    );
  }

  @override
  Widget build(BuildContext context) {
    return this.list == null
        ? getBulletListWithWids(context)
        : getBulletList(context);
  }
}

class SearchableText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final int wrapLength;

  SearchableText(this.text,
      {this.style = const TextStyle(), this.wrapLength = 100});

  @override
  Widget build(BuildContext context) {
    int length = 0;
    List<String> words = text.split(" ");
    List<Widget> body = new List();
    List<Widget> rows = new List();

    for (String word in words) {
      length += word.length + 1;
      if (length <= wrapLength) {
        addToBody(body, context, word);
      } else {
        rows.add(Row(mainAxisSize: MainAxisSize.min, children: body));
        body = new List();
        addToBody(body, context, word);
        length = words.length + 1;
      }
    }
    if (body.isNotEmpty) {
      rows.add(Row(mainAxisSize: MainAxisSize.min, children: body));
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: rows,
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }

  void addToBody(List<Widget> body, BuildContext context, String word) {
    body.add(GestureDetector(
      onLongPress: () {
        Navigator.popAndPushNamed(context, 'dictionaryPage',
            arguments:
                word.endsWith(":") ? word.substring(0, word.length - 1) : word);
      },
      child: Text(
        word + " ",
        style: style,
      ),
    ));
  }
}

/*class ListItem extends StatelessWidget {
  final String title, description, imagePath, number;
  final Color backgroundColor;
  final TextStyle numberStyle = GoogleFonts.satisfy(
      textStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.w700));

  ListItem(
      {this.title = 'Title',
      this.description = 'Lorem ipsum dolor sit amet, consectetur adipiscing',
      this.imagePath,
      this.number,
      this.backgroundColor = LightColor.lightBlue});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          GFListTile(
            avatar: GFAvatar(
              size: GFSize.MEDIUM,
              backgroundImage: imagePath == null
                  ? null
                  : AssetImage('assets/design_course/clock'),
              child: (number != null && imagePath == null)
                  ? Text(
                      number,
                      style: numberStyle,
                    )
                  : null,
              backgroundColor: backgroundColor,
            ),
            titleText: title,
            subtitleText: description,
            icon: Icon(Icons.favorite),
            //padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 28),
            child: Container(
              height: 1,
              width: MediaQuery.of(context).size.width * 0.68,
              color: Colors.black12,
            ),
          ),
        ],
      ),
    );
  }
}*/

class MyListItem extends StatefulWidget {
  final String title, description, imagePath, number;
  final Color backgroundColor;
  final Function onTap;
  final bool checkType;
  final Icon icon;

  MyListItem(
      {this.title = 'Title',
      this.description = 'Total words: 50',
      this.imagePath,
      this.number,
      this.backgroundColor = LightColor.lightBlue,
      this.onTap,
      this.checkType = false,
      this.icon});

  @override
  _MyListItemState createState() => _MyListItemState(
      title,
      description,
      imagePath,
      number,
      backgroundColor,
      onTap == null ? () {} : onTap,
      checkType);
}

class _MyListItemState extends State<MyListItem> {
  final String title, description, imagePath, number;
  final Color backgroundColor;
  final TextStyle numberStyle = GoogleFonts.satisfy(
      textStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.w700));
  final Function ontap;
  final bool checkType;
  bool selected = false;

  _MyListItemState(this.title, this.description, this.imagePath, this.number,
      this.backgroundColor, this.ontap, this.checkType);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ontap(number, title);
        if (checkType) {
          setState(() {
            selected = !selected;
          });
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            GFListTile(
              avatar: GFAvatar(
                size: GFSize.SMALL,
                backgroundImage: imagePath == null
                    ? null
                    : AssetImage('assets/design_course/clock'),
                child: (number != null && imagePath == null)
                    ? Text(
                        number,
                        style: numberStyle,
                      )
                    : null,
                backgroundColor: backgroundColor,
              ),
              titleText: title,
              subtitleText: description,
              //padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              icon: checkType
                  ? Icon(
                      selected
                          ? Icons.check_circle_outline
                          : Icons.radio_button_unchecked,
                      size: 28,
                    )
                  : widget.icon,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 28),
              child: Container(
                height: 1,
                width: MediaQuery.of(context).size.width * 0.68,
                color: Colors.black12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
/*
icon: Icon(
              Icons.check_circle_outline,
              size: 28,
            ),
 */
