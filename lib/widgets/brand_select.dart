import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/brand_list.dart';


class BrandSelect extends StatefulWidget {
  BrandSelect({Key key}) : super(key: key);

  @override
  _BrandSelectState createState() => _BrandSelectState();
}

class _BrandSelectState extends State<BrandSelect> {
  List<String> dropdownList = [];
  List<String> filterList = [];

  @override
  void initState() {
    Provider.of<BrandList>(context, listen: false).fetchAndSetBrandList();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    dropdownList = (Provider.of<BrandList>(context).items.isNotEmpty) ? Provider.of<BrandList>(context).items.map((e) => e.name).toList() : [];
    super.didChangeDependencies();
  }

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
            onChanged: (String brand) {
              setState(() {
                filterList.add(brand);
                dropdownList.remove(brand);
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
