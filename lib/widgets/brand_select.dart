import 'package:flutter/material.dart';

class BrandSelect extends StatefulWidget {
  BrandSelect({Key key}) : super(key: key);

  @override
  _BrandSelectState createState() => _BrandSelectState();
}

class _BrandSelectState extends State<BrandSelect> {
  String dropdownValue;
  List<String> dropdownList = [
    'Filter Brand...',
    'Nickelodeon',
    'MTV',
    'NTV',
  ];
  List<String> filterList = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 200,
          child: DropdownButton<String>(
            value: 'Filter Brand...',
            //icon: Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 16,
            onChanged: (String newValue) {
              if (newValue == 'Filter Brand...') {
                return;
              } else {
                setState(() {
                  dropdownList.remove(newValue);
                  filterList.add(newValue);
                });
              }
            },
            items: dropdownList.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
        Column(
          children: filterList.map((String value) {
            return InputChip(
              onDeleted: () {
                setState(() {
                  dropdownList.add(value);
                  filterList.remove(value);
                });
              },
              deleteIconColor: Colors.black54,
              label: Text(value),
            );
          }).toList(),
        )
      ],
    );
  }
}
