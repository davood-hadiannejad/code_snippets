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
      // TODO Filter with URL
      Provider.of<Detail>(context, listen: false).filterBrands(filterList);
    } else if (widget.filterType == 'Kunde') {
      print('Kunden Filter');
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
            onChanged: (String item) {
              setState(() {
                filterList.add(item);
                dropdownList.remove(item);
                updateList();
              });

            },
            items: dropdownList.map<DropdownMenuItem<String>>((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Container(width: 175,child: Text(item)),
              );
            }).toList(),
          ),
        ),
        Container(
          width: 200,
          child: Column(
            children: filterList.map((String item) {
              return InputChip(
                onDeleted: () {
                  setState(() {
                    dropdownList.add(item);
                    filterList.remove(item);
                    updateList();
                  });
                },
                deleteIconColor: Colors.black54,
                label: Text(item),
              );
            }).toList(),
          ),
        )
      ],
    );
  }
}
