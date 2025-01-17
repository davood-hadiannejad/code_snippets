import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:search_choices/search_choices.dart';

import '../providers/aob_list.dart';
import '../providers/detail.dart';
import '../providers/customer_forecast_list.dart';
import '../providers/brand_list.dart';
import '../providers/project_list.dart';
import '../providers/commitment_list.dart';
import '../providers/verkaeufer.dart';


class SelectMenu extends StatefulWidget {
  List<String> itemList;
  String filterType;
  String providerClass;
  final String pageType;
  final String detailId;
  final Verkaeufer selectedUser;
  final String selectedYear;

  SelectMenu(this.providerClass, this.itemList, this.filterType,
      {this.pageType, this.detailId, this.selectedUser, this.selectedYear});

  @override
  _SelectMenuState createState() => _SelectMenuState();
}

class _SelectMenuState extends State<SelectMenu> {
  List<String> filterList = [];
  List<int> selectedItems = [];
  List<String> dropdownList = [];

  @override
  void initState() {
    dropdownList = widget.itemList;
    Provider.of<BrandList>(context, listen: false).fetchAndSetBrandList();
    super.initState();
  }

  void updateList() {
    if (widget.filterType == 'Brand' && widget.providerClass == 'detail') {
      Provider.of<Detail>(context, listen: false).filterByBrandList(filterList);
      Provider.of<Detail>(context, listen: false).fetchAndSetDetail(
          widget.pageType, widget.detailId,
          verkaeufer: widget.selectedUser, year: widget.selectedYear);
    } else if (widget.filterType == 'Kunde' &&
        widget.providerClass == 'detail') {
      Provider.of<Detail>(context, listen: false).filterByCustomerList(filterList);
      Provider.of<Detail>(context, listen: false).fetchAndSetDetail(
          widget.pageType, widget.detailId,
          verkaeufer: widget.selectedUser, year: widget.selectedYear);
    } else if (widget.filterType == 'Mandant' &&
        widget.providerClass == 'detail') {
      Provider.of<Detail>(context, listen: false).filterByMandantList(filterList);
      Provider.of<Detail>(context, listen: false).fetchAndSetDetail(
          widget.pageType, widget.detailId,
          verkaeufer: widget.selectedUser, year: widget.selectedYear);
    } else if (widget.filterType == 'Brand' &&
        widget.providerClass == 'customer-forecast') {
      Provider.of<CustomerForecastList>(context, listen: false)
          .filterByBrandList(filterList);
    } else if (widget.filterType == 'Brand' &&
        widget.providerClass == 'project-forecast') {
      Provider.of<ProjectList>(context, listen: false)
          .filterByBrandList(filterList);
      Provider.of<AOBList>(context, listen: false)
          .filterByBrandList(filterList);
    } else if (widget.filterType == 'Brand' &&
        widget.providerClass == 'commitment') {
      Provider.of<CommitmentList>(context, listen: false)
          .filterByBrandList(filterList);
    }
  }

  @override
  void didChangeDependencies() {
    if ((widget.filterType == 'Brand' &&
            widget.providerClass == 'customer-forecast') ||
        (widget.filterType == 'Brand' &&
            widget.providerClass == 'project-forecast') ||
        (widget.filterType == 'Brand' &&
            widget.providerClass == 'commitment')) {
      dropdownList =
          Provider.of<BrandList>(context).items.map((e) => e.name).toList();
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 300,
          child: SearchChoices.multiple(
            items: dropdownList.where((element) => element != 'Gesamt').map<DropdownMenuItem<String>>((String item) {
         return DropdownMenuItem<String>(
           value: item,
           child: Container(width: 155, child: Text(item)),
         );
       }).toList(),
            selectedItems: selectedItems,
            hint: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Filter ${widget.filterType}..."),
            ),
            searchHint: "Filter ${widget.filterType}...",
            onChanged: (List<int> values) {
              setState(() {
                selectedItems = values;
                filterList = values.map((e) => dropdownList.where((element) => element != 'Gesamt').toList()[e]).toList();
                print(filterList);
                updateList();
              });
            },
            closeButton: (selectedItems) {
              return (selectedItems.isNotEmpty
                  ? "Filter auf ${selectedItems.length == 1 ? '"' + dropdownList.where((element) => element != 'Gesamt').toList()[selectedItems.first] + '"' : '(' + selectedItems.length.toString() + ')'}"
                  : "Zurück ohne Auswahl");
            },
            doneButton: (selectedItems, done) {
              return (selectedItems.isNotEmpty
                  ? "Filter auf ${selectedItems.length == 1 ? '"' + dropdownList.where((element) => element != 'Gesamt').toList()[selectedItems.first] + '"' : '(' + selectedItems.length.toString() + ')'}"
                  : "Zurück ohne Auswahl");
            },
            isExpanded: true,
          ),
          // DropdownButton<String>(
          //   value: null,
          //   hint: Text('Filter ${widget.filterType}...'),
          //   //icon: Icon(Icons.arrow_downward),
          //   iconSize: 24,
          //   elevation: 16,
          //   onChanged: (String item) {
          //     setState(() {
          //       filterList.add(item);
          //       dropdownList.remove(item);
          //       updateList();
          //     });
          //   },
          //   items: dropdownList.where((element) => element != 'Gesamt').map<DropdownMenuItem<String>>((String item) {
          //     return DropdownMenuItem<String>(
          //       value: item,
          //       child: Container(width: 175, child: Text(item)),
          //     );
          //   }).toList(),
          // ),
        ),
        // Container(
        //   width: 200,
        //   child: Column(
        //     children: filterList.map((String item) {
        //       return InputChip(
        //         onDeleted: () {
        //           setState(() {
        //             dropdownList.add(item);
        //             filterList.remove(item);
        //             updateList();
        //           });
        //         },
        //         deleteIconColor: Colors.black54,
        //         label: Text(item),
        //       );
        //     }).toList(),
        //   ),
        // )
      ],
    );
  }
}
