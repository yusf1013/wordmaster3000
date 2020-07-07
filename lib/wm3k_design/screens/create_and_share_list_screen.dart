import 'package:card_settings/widgets/action_fields/card_settings_button.dart';
import 'package:card_settings/widgets/card_settings_panel.dart';
import 'package:card_settings/widgets/information_fields/card_settings_header.dart';
import 'package:card_settings/widgets/text_fields/card_settings_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:wm3k/analysis_classes/wordList.dart';
import 'package:wm3k/wm3k_design/controllers/user_controller.dart';

class CreateWordListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String name, description;
    return AlertDialog(
      contentPadding: EdgeInsets.all(0),
      titlePadding: EdgeInsets.all(0),
      content: CardSettings(
        padding: 0,
        shrinkWrap: true,
        children: <CardSettingsSection>[
          CardSettingsSection(
            children: <Widget>[
              CardSettingsHeader(label: 'New word list'),
              CardSettingsText(
                maxLength: 100,
                autocorrect: true,
                autovalidate: true,
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
                onChanged: (value) {
                  name = value;
                },
              ),
              CardSettingsText(
                maxLengthEnforced: false,
                maxLength: 250,
                labelWidth: 100,
                hintText: 'For ex: SAT words',
                label: 'Desciption',
                initialValue: "",
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Description is required.';
                  return '';
                },
                autovalidate: true,
                autocorrect: true,
                onChanged: (value) {
                  description = value;
                },
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: CardSettingsButton(
                        onPressed: () {
                          if ((name != null && name.isNotEmpty) &&
                              (description != null && description.isNotEmpty))
                            try {
                              //FocusScope.of(context).unfocus();
                              print('$name, $description');
                              UserDataController()
                                  .createWordList(name, description);
                              Navigator.pop(context, true);
                            } catch (e) {
                              print('Error creating list $e');
                            }
                          //UserDataController().createWordList(name, description);
                        },
                        label: 'Create',
                        backgroundColor: Colors.lightBlueAccent,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: CardSettingsButton(
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                        backgroundColor: Colors.redAccent,
                        label: 'Cancel',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class ShareWordListView extends StatefulWidget {
  final WordList wordList;

  ShareWordListView(this.wordList);
  @override
  _ShareWordListViewState createState() => _ShareWordListViewState();
}

class _ShareWordListViewState extends State<ShareWordListView> {
  bool showSpinner = false;
  @override
  Widget build(BuildContext context) {
    String name = widget.wordList.name,
        description = widget.wordList.description;
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: AlertDialog(
        contentPadding: EdgeInsets.all(0),
        titlePadding: EdgeInsets.all(0),
        content: CardSettings(
          padding: 0,
          shrinkWrap: true,
          children: <CardSettingsSection>[
            CardSettingsSection(
              children: <Widget>[
                CardSettingsHeader(label: 'Course Details'),
                CardSettingsText(
                  maxLength: 100,
                  autocorrect: true,
                  autovalidate: true,
                  labelWidth: 100,
                  //hintText: 'Enter title of the list',
                  autofocus: true,
                  label: 'Title',
                  initialValue: widget.wordList.name,
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Title is required.';
                    return '';
                  },
                  onChanged: (value) {
                    name = value;
                  },
                ),
                CardSettingsText(
                  maxLengthEnforced: false,
                  maxLength: 250,
                  labelWidth: 100,
                  //hintText: 'For ex: SAT words',
                  label: 'Desciption',
                  initialValue: widget.wordList.description,
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Description is required.';
                    return '';
                  },
                  autovalidate: true,
                  autocorrect: true,
                  onChanged: (value) {
                    description = value;
                  },
                ),
                CardSettingsHeader(label: 'Share To Market'),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Column(
                    children: <Widget>[
                      CardSettingsButton(
                        onPressed: () async {
                          if ((name != null && name.isNotEmpty) &&
                              (description != null && description.isNotEmpty))
                            //FocusScope.of(context).unfocus();
                            print('$name, $description');
                          setState(() {
                            showSpinner = true;
                          });
                          bool done = await UserDataController()
                              .createCourse(widget.wordList, name, description);
                          setState(() {
                            showSpinner = false;
                          });
                          Navigator.pop(context, done);
                          //UserDataController().createWordList(name, description);
                        },
                        label: 'Share',
                        backgroundColor: Colors.lightBlueAccent,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      CardSettingsButton(
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                        backgroundColor: Colors.redAccent,
                        label: 'Cancel',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/*class ShareWordListView extends StatelessWidget {
  final String title, desc;
  final int id;

  ShareWordListView(this.title, this.desc, this.id);

  @override
  Widget build(BuildContext context) {
    String name = title, description = desc;
    return AlertDialog(
      contentPadding: EdgeInsets.all(0),
      titlePadding: EdgeInsets.all(0),
      content: CardSettings(
        padding: 0,
        shrinkWrap: true,
        children: <CardSettingsSection>[
          CardSettingsSection(
            children: <Widget>[
              CardSettingsHeader(label: 'Course Details'),
              CardSettingsText(
                maxLength: 100,
                autocorrect: true,
                autovalidate: true,
                labelWidth: 100,
                //hintText: 'Enter title of the list',
                autofocus: true,
                label: 'Title',
                initialValue: title,
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Title is required.';
                  return '';
                },
                onChanged: (value) {
                  name = value;
                },
              ),
              CardSettingsText(
                maxLengthEnforced: false,
                maxLength: 250,
                labelWidth: 100,
                //hintText: 'For ex: SAT words',
                label: 'Desciption',
                initialValue: desc,
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Description is required.';
                  return '';
                },
                autovalidate: true,
                autocorrect: true,
                onChanged: (value) {
                  description = value;
                },
              ),
              CardSettingsHeader(label: 'Share To Market'),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Column(
                  children: <Widget>[
                    CardSettingsButton(
                      onPressed: () async {
                        if ((name != null && name.isNotEmpty) &&
                            (description != null && description.isNotEmpty))
                          //FocusScope.of(context).unfocus();
                          print('$name, $description');
                        bool done = await UserDataController().createCourse(id);
                        Navigator.pop(context, done);

                        //UserDataController().createWordList(name, description);
                      },
                      label: 'Share',
                      backgroundColor: Colors.lightBlueAccent,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    CardSettingsButton(
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      backgroundColor: Colors.redAccent,
                      label: 'Cancel',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}*/
