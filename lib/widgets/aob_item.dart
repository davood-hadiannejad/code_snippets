import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../providers/aob.dart';
import '../providers/aob_list.dart';
import '../providers/verkaeufer_list.dart';
import '../providers/verkaeufer.dart';
import '../providers/year.dart';

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
    Verkaeufer selectedVerkaufer = Provider.of<VerkaeuferList>(context, listen: false).selectedVerkaufer;
    String selectedYear = Provider.of<Year>(context, listen: false).selectedYear;
    Provider.of<AOBList>(context, listen: false).fetchAndSetAOBList(verkaeufer: selectedVerkaufer, year: selectedYear);
  }

  @override
  Widget build(BuildContext context) {
    myAobList = Provider.of<AOBList>(context).items;
    return Container(
      width: 1000,
      child: DataTable(
        columns: <DataColumn>[
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
            label: Expanded(
              child: Text(
                'Goal (MN3)',
                textAlign: TextAlign.end,
              ),
            ),
          ),
          DataColumn(
            label: Expanded(
              child: Text(
                'Offene Projekte (MN3 bewertet)',
                textAlign: TextAlign.end,
              ),
            ),
          ),
          DataColumn(
            label: Expanded(
              child: Text(
                'Gebuchte Projekte (MN3)',
                textAlign: TextAlign.end,
              ),
            ),
          ),
          DataColumn(
            label: Expanded(
              child: Text(
                'Differenz',
                textAlign: TextAlign.end,
              ),
            ),
          ),
        ],
        rows: myAobList
            .map((aob) => DataRow(cells: [
                  DataCell(Text(aob.medium)),
                  DataCell(Text(aob.brand)),
                  DataCell(Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(formatter.format(aob.goal)),
                    ],
                  )),
                  DataCell(Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(formatter.format(aob.offen)),
                    ],
                  )),
                  DataCell(Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(formatter.format(aob.gebucht)),
                    ],
                  )),
                  DataCell(Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                          formatter.format(aob.goal - aob.offen - aob.gebucht)),
                    ],
                  )),
                ]))
            .toList(),
      ),
    );
  }
}
