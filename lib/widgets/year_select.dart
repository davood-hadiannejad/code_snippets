import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/year.dart';

class YearSelect extends StatefulWidget {
  bool disable;

  YearSelect({this.disable = false});

  @override
  _YearSelectState createState() => _YearSelectState();
}

class _YearSelectState extends State<YearSelect> {
  List<String> yearList;
  String selectedYear;


  @override
  Widget build(BuildContext context) {
    yearList = Provider.of<Year>(context).yearList;
    selectedYear = Provider.of<Year>(context).selectedYear;
    return DropdownButton<String>(
      value: selectedYear,
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
      onChanged: (widget.disable)
          ? (String year) {}
          : (String year) {
              Provider.of<Year>(context, listen: false).changeYear(year);
            },
      items: (widget.disable)
          ? [DropdownMenuItem(value: selectedYear, child: Text(selectedYear))]
          : yearList.map<DropdownMenuItem<String>>((String year) {
              return DropdownMenuItem<String>(
                value: year,
                child: Text(year),
              );
            }).toList(),
    );
  }
}
