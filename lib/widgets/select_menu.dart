import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/detail.dart';


class SelectMenu extends StatefulWidget {
  List<String> itemList;
  String filterType;
  SelectMenu(this.itemList, this.filterType);
  @override
  _SelectMenuState createState() => _SelectMenuState();
}

class _SelectMenuState extends State<SelectMenu> {
  List<String> filterList = [];
  List<String> dropdownList = [];

  @override
  void initState() {
    dropdownList = widget.itemList;
    super.initState();
  }


  void updateList() {
    if (widget.filterType == 'Brand') {
      Provider.of<Detail>(context, listen: false).filterBrands(filterList);
    }
    print(widget.filterType);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 200,
          child: DropdownButton<String>(
            value: null,
            hint: Text('Filter ${widget.filterType}...'),
            //icon: Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 16,
            onChanged: (String brand) {
              setState(() {
                filterList.add(brand);
                dropdownList.remove(brand);
                updateList();
              });

            },
            items: dropdownList.map<DropdownMenuItem<String>>((String brand) {
              return DropdownMenuItem<String>(
                value: brand,
                child: Text(brand),
              );
            }).toList(),
          ),
        ),
        Column(
          children: filterList.map((String brand) {
            return InputChip(
              onDeleted: () {
                setState(() {
                  dropdownList.add(brand);
                  filterList.remove(brand);
                  updateList();
                });
              },
              deleteIconColor: Colors.black54,
              label: Text(brand),
            );
          }).toList(),
        )
      ],
    );
  }
}
