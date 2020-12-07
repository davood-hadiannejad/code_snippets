import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../providers/aob.dart';
import '../providers/aob_list.dart';

final formatter =
    new NumberFormat.simpleCurrency(locale: 'eu', decimalDigits: 0);

class AobItem extends StatefulWidget {
  @override
  _AobItemState createState() => _AobItemState();
}

class _AobItemState extends State<AobItem> {
  List<AOB> myAobList;

  @override
  void initState() {
    super.initState();
    Provider.of<AOBList>(context, listen: false).fetchAndSetAOBList();
  }

  @override
  Widget build(BuildContext context) {
    myAobList = Provider.of<AOBList>(context).items;
    return Container(
      width: 1000,
      child: DataTable(
        columns: const <DataColumn>[
          DataColumn(
            label: Text(
              'Medium',
            ),
          ),
          DataColumn(
            label: Text(
              'Brand',
            ),
          ),
          DataColumn(
            label: Text(
              'Goal (MN3)',
            ),
          ),
          DataColumn(
            label: Text(
              'Offene Projekte (MN3 bewertet)',
            ),
          ),
          DataColumn(
            label: Text(
              'Gebuchte Projekte (MN3)',
            ),
          ),
          DataColumn(
            label: Text(
              'Differenz',
            ),
          ),
        ],
        rows: myAobList
            .map((aob) => DataRow(cells: [
                  DataCell(Text(aob.medium)),
                  DataCell(Text(aob.brand)),
                  DataCell(Text(formatter.format(aob.goal))),
                  DataCell(Text(formatter.format(aob.offen))),
                  DataCell(Text(formatter.format(aob.gebucht))),
                  DataCell(Text(
                      formatter.format(aob.goal - aob.offen - aob.gebucht))),
                ]))
            .toList(),
      ),
    );
  }
}
