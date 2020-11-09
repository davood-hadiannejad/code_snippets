import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/aob.dart';
import '../providers/aob_list.dart';

class AobItem extends StatefulWidget {
  @override
  _AobItemState createState() => _AobItemState();
}

class _AobItemState extends State<AobItem> {
  List<AOB> aob_list;

  @override
  void initState() {
    super.initState();
    Provider.of<AOBList>(context, listen: false).fetchAndSetAOBList();
  }

  @override
  Widget build(BuildContext context) {
    aob_list = Provider.of<AOBList>(context).items;
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
        rows: aob_list
            .map((aob) => DataRow(cells: [
                  DataCell(Text(aob.medium)),
                  DataCell(Text(aob.brand)),
                  DataCell(Text(aob.goal.toString())),
                  DataCell(Text(aob.offen.toString())),
                  DataCell(Text(aob.gebucht.toString())),
                  DataCell(
                      Text((aob.goal - aob.offen - aob.gebucht).toString())),
                ]))
            .toList(),
      ),
    );
  }
}
