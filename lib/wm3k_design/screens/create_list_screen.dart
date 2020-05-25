import 'package:card_settings/widgets/action_fields/card_settings_button.dart';
import 'package:card_settings/widgets/card_settings_panel.dart';
import 'package:card_settings/widgets/information_fields/card_settings_header.dart';
import 'package:card_settings/widgets/text_fields/card_settings_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:card_settings/card_settings.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:wm3k/wm3k_design/controllers/user_controller.dart';
import 'package:intl/intl.dart';

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
              if (value == null || value.isEmpty) return 'Title is required.';
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
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
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
      ),
    );
  }
}