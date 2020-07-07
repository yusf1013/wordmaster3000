import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_awesome_alert_box/flutter_awesome_alert_box.dart';
import 'package:menu/menu.dart';
import 'package:wm3k/wm3k_design/controllers/user_controller.dart';
import 'package:wm3k/wm3k_design/themes/wm3k_app_theme.dart';
import 'package:wm3k/wm3k_design/models/category.dart';
import 'package:flutter/material.dart';

import 'custom_widgets.dart';
import 'menu.dart';

class LearningTabListView extends StatefulWidget {
  final Function callBack;
  //final List<Category> currentList;
  final UserDataController userDataController = UserDataController();
  final Stream stream;
  final Function getCurrentList, addButtonAction, onDelete;

  LearningTabListView(
      {this.callBack,
      @required this.stream,
      @required this.getCurrentList,
      @required this.addButtonAction,
      this.onDelete});

  @override
  _LearningTabListViewState createState() => _LearningTabListViewState();
}

class _LearningTabListViewState extends State<LearningTabListView>
    with TickerProviderStateMixin {
  AnimationController animationController;

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

  /*Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }*/

  Future<bool> getData() async {}

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 16),
      child: Container(
        height: 134,
        width: double.infinity,
        child: StreamBuilder(
          stream: widget.stream,
          builder: (context, asyncSnapshot) {
            if (!asyncSnapshot.hasData) {
              return SizedBox();
            } else {
              List<Category> currentList =
                  widget.getCurrentList(asyncSnapshot.data);
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
                    return Menu(
                      child: CategoryView(
                        category: currentList[index],
                        animation: animation,
                        animationController: animationController,
                        callback: () {
                          widget.callBack(currentList[index].id);
                        },
                      ),
                      items: [
                        MenuItem("Delete", () {
                          DeleteAlertBox(
                            context: context,
                            infoMessage:
                                "You won't be able to recover this list!",
                            onPressedYes: () {
                              /*UserDataController()
                                  .deleteWordList(currentList[index].id);*/
                              widget.onDelete(currentList[index].id);

                              Navigator.pop(context);
                            },
                          );
                        }),
                      ],
                      decoration: MenuDecoration(constraints: BoxConstraints()),
                      itemBuilder: (
                        MenuItem item,
                        MenuDecoration menuDecoration,
                        VoidCallback dismiss, {
                        bool isFirst,
                        bool isLast,
                      }) {
                        final BoxConstraints constraints =
                            menuDecoration.constraints ??
                                const BoxConstraints();

                        final EdgeInsetsGeometry itemPadding =
                            menuDecoration.padding ??
                                const EdgeInsets.only(
                                  top: 10.0,
                                  bottom: 10,
                                  right: 10.0,
                                );

                        Widget w = InkWell(
                          splashColor: menuDecoration.splashColor,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.delete_forever, color: Colors.red),
                                Container(
                                  padding: itemPadding,
                                  constraints: constraints,
                                  alignment: Alignment.center,
                                  child: Text(
                                    item.text,
                                    style: menuDecoration.textStyle,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            item.onTap();
                            dismiss();
                          },
                        );

                        var r = menuDecoration.radius;
                        var radius = BorderRadius.horizontal(
                          left: isFirst ? Radius.circular(r) : Radius.zero,
                          right: isLast ? Radius.circular(r) : Radius.zero,
                        );

                        w = Material(
                          color: menuDecoration.color,
                          child: w,
                        );

                        return ClipRRect(
                          child: w,
                          borderRadius: radius,
                        );
                      },
                    );
                  else
                    return Padding(
                      padding: EdgeInsets.only(left: 50),
                      child: RawMaterialButton(
                        onPressed: widget.addButtonAction,
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
                                            child: Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: Text(
                                                    category.title,
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 16,
                                                      letterSpacing: 0.27,
                                                      color:
                                                          DesignCourseAppTheme
                                                              .darkerText,
                                                    ),
                                                  ),
                                                ),
                                              ],
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
