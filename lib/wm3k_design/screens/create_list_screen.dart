import 'package:card_settings/widgets/action_fields/card_settings_button.dart';
import 'package:card_settings/widgets/card_settings_panel.dart';
import 'package:card_settings/widgets/information_fields/card_settings_header.dart';
import 'package:card_settings/widgets/text_fields/card_settings_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreateWordListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.all(0),
      titlePadding: EdgeInsets.all(0),
      content: CardSettings(
        padding: 0,
        shrinkWrap: true,
        children: <Widget>[
          CardSettingsHeader(label: 'New word list'),
          CardSettingsText(
            labelWidth: 100,
            hintText: 'Enter title of the list',
            autofocus: true,
            label: 'Title',
            initialValue: "",
            validator: (value) {
              if (value == null || value.isEmpty) return 'Title is required.';
              return '';
            },
            onSaved: (value) {},
          ),
          CardSettingsText(
            maxLengthEnforced: false,
            maxLength: 250,
            labelWidth: 100,
            hintText: 'For ex: SAT words',
            label: 'Desciption',
            initialValue: "",
            validator: (value) {
              if (value == null || value.isEmpty) return 'Title is required.';
              return '';
            },
            onSaved: (value) {},
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: CardSettingsButton(
                    onPressed: () {},
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
  }
}
