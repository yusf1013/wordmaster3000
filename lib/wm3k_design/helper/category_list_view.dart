import 'package:wm3k/wm3k_design/screens/main_home_screen.dart';
import 'package:wm3k/wm3k_design/screens/toDelete/more.dart';
import 'package:wm3k/wm3k_design/themes/color/light_color.dart';
import 'package:wm3k/wm3k_design/themes/wm3k_app_theme.dart';
import 'package:wm3k/wm3k_design/models/category.dart';
import 'package:card_settings/card_settings.dart';
import 'package:card_settings/widgets/card_settings_panel.dart';
import 'package:card_settings/widgets/information_fields/card_settings_header.dart';
import 'package:card_settings/widgets/numeric_fields/card_settings_double.dart';
import 'package:card_settings/widgets/text_fields/card_settings_paragraph.dart';
import 'package:card_settings/widgets/text_fields/card_settings_text.dart';
import 'package:flutter/material.dart';
import 'package:animated_dialog_box/animated_dialog_box.dart';

import 'custom_widgets.dart';

class CategoryListView extends StatefulWidget {
  /*CategoryListView({Key key, this.callBack, this.currentList})
      : super(key: key);*/
  final Function callBack;
  final List<Category> currentList;
  final CategoryType type;

  CategoryListView({this.callBack, this.currentList, this.type});

  @override
  _CategoryListViewState createState() => _CategoryListViewState(currentList);
}

class _CategoryListViewState extends State<CategoryListView>
    with TickerProviderStateMixin {
  AnimationController animationController;
  List<Category> currentList;

  _CategoryListViewState(List<Category> cat) {
    currentList = cat;
  }

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1750), vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 16),
      child: Container(
        height: 134,
        width: double.infinity,
        child: FutureBuilder<bool>(
          future: getData(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox();
            } else {
              return ListView.builder(
                padding: const EdgeInsets.only(
                    top: 0, bottom: 0, right: 16, left: 16),
                itemCount: currentList.length + 1,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  final int count =
                      currentList.length > 10 ? 10 : currentList.length;
                  final Animation<double> animation =
                      Tween<double>(begin: 0.1, end: 1.0).animate(
                          CurvedAnimation(
                              parent: animationController,
                              curve: Interval((1 / count) * index, 1.0,
                                  curve: Curves.fastOutSlowIn)));
                  animationController.forward();

                  if (index < currentList.length)
                    return CategoryView(
                      category: currentList[index],
                      animation: animation,
                      animationController: animationController,
                      callback: () {
                        widget.callBack(currentList[index].title);
                      },
                    );
                  else
                    return Padding(
                      padding: EdgeInsets.only(left: 50),
                      child: RawMaterialButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                contentPadding: EdgeInsets.all(0),
                                titlePadding: EdgeInsets.all(0),
                                content: CardSettings(
                                  padding: 0,
                                  shrinkWrap: true,
                                  children: <Widget>[
                                    CardSettingsHeader(
                                        label:
                                            widget.type == CategoryType.myWords
                                                ? 'New word list'
                                                : 'New course'),
                                    CardSettingsText(
                                      labelWidth: 100,
                                      hintText: 'Enter title of the list',
                                      autofocus: true,
                                      label: 'Title',
                                      initialValue: "",
                                      validator: (value) {
                                        if (value == null || value.isEmpty)
                                          return 'Title is required.';
                                        return '';
                                      },
                                      onSaved: (value) {},
                                    ),
                                    CardSettingsText(
                                      maxLengthEnforced: false,
                                      maxLength: 250,
                                      labelWidth: 100,
                                      hintText:
                                          widget.type == CategoryType.myWords
                                              ? 'For ex: SAT words'
                                              : 'For ex: SAT course',
                                      label: 'Desciption',
                                      initialValue: "",
                                      validator: (value) {
                                        if (value == null || value.isEmpty)
                                          return 'Title is required.';
                                        return '';
                                      },
                                      onSaved: (value) {},
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 10),
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: CardSettingsButton(
                                              onPressed: () {},
                                              label: 'Create',
                                              backgroundColor:
                                                  Colors.lightBlueAccent,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: CardSettingsButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              backgroundColor: Colors.redAccent,
                                              label: 'Cancel',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: new Icon(
                          Icons.add,
                          color: Colors.blue,
                          size: 50.0,
                        ),
                        shape: new CircleBorder(),
                        elevation: 2.0,
                        fillColor: Colors.white,
                        //padding: const EdgeInsets.all(1.0),
                      ),
                    );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

class CategoryView extends StatelessWidget {
  const CategoryView(
      {Key key,
      this.category,
      this.animationController,
      this.animation,
      this.callback})
      : super(key: key);

  final VoidCallback callback;
  final Category category;
  final AnimationController animationController;
  final Animation<dynamic> animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: animation,
          child: Transform(
            transform: Matrix4.translationValues(
                100 * (1.0 - animation.value), 0.0, 0.0),
            child: InkWell(
              splashColor: Colors.transparent,
              onTap: () {
                callback();
              },
              child: SizedBox(
                width: 280,
                child: Stack(
                  children: <Widget>[
                    Container(
                      //color: Colors.red,
                      child: Row(
                        children: <Widget>[
                          const SizedBox(
                            width: 48,
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: HexColor('#F8FAFB'),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(16.0)),
                              ),
                              child: Row(
                                children: <Widget>[
                                  const SizedBox(
                                    width: 48 + 24.0,
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: Column(
                                        children: <Widget>[
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 16),
                                            child: Text(
                                              category.title,
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                                letterSpacing: 0.27,
                                                color: DesignCourseAppTheme
                                                    .darkerText,
                                              ),
                                            ),
                                          ),
                                          const Expanded(
                                            child: SizedBox(),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 16, bottom: 8),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                  '${category.wordCount} words',
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w200,
                                                    fontSize: 12,
                                                    letterSpacing: 0.27,
                                                    color: DesignCourseAppTheme
                                                        .grey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 16, right: 16),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Row(
                                                  children: <Widget>[
                                                    Icon(
                                                      Icons.schedule,
                                                      size: 20,
                                                      color: Colors.lightBlue,
                                                    ),
                                                    SizedBox(
                                                      width: 3,
                                                      height: 30,
                                                    ),
                                                    Text(
                                                      '${category.time} MIN ${category.text}',
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 16,
                                                        letterSpacing: 0.27,
                                                        color:
                                                            DesignCourseAppTheme
                                                                .nearlyBlue,
                                                      ),
                                                    ),
                                                  ],
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      //color: Colors.red,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 24, bottom: 24, left: 16),
                        child: Row(
                          children: <Widget>[
                            ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(16.0)),
                              child: AspectRatio(
                                  aspectRatio: 1.0,
                                  child: Image.asset(category.imagePath)),
                            )
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        decoration: BoxDecoration(
                          color: DesignCourseAppTheme.nearlyBlue,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(14.0)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Icon(
                            Icons.play_arrow,
                            color: DesignCourseAppTheme.nearlyWhite,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
