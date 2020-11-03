import 'package:flutter/material.dart';

class UserSelect extends StatefulWidget {
  UserSelect({Key key}) : super(key: key);

  @override
  _UserSelectState createState() => _UserSelectState();
}

class _UserSelectState extends State<UserSelect> {
  String dropdownValue = 'Johannes Jacob';

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      //icon: Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: Theme.of(context)
          .textTheme
          .bodyText1
          .merge(TextStyle(color: Colors.white)),
      dropdownColor: Theme.of(context).accentColor,
      underline: Container(
        height: 1,
        color: Theme.of(context).accentColor,
      ),
      onChanged: (String newValue) {
        if (this.mounted) {
          setState(() {
            dropdownValue = newValue;
          });
        }
      },
      items: <String>[
        'Gesamt',
        'Johannes Jacob',
        'Thomas Günther',
        'Frederik Wurst',
        'Lars Müller'
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
