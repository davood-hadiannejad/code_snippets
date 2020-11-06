import 'package:flutter/material.dart';

class BrandSelect extends StatefulWidget {
  BrandSelect({Key key}) : super(key: key);

  @override
  _BrandSelectState createState() => _BrandSelectState();
}

class _BrandSelectState extends State<BrandSelect> {
  List<String> dropdownList = [
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
            value: null,
            hint: Text('Filter Brand...'),
            //icon: Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 16,
            onChanged: (String newValue) {
              setState(() {
                dropdownList.remove(newValue);
                filterList.add(newValue);
              });

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
