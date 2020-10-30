import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class TableItem extends StatelessWidget {
  TableItem({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: const <DataColumn>[
        DataColumn(
          label: Text(
            'Brand',
          ),
        ),
        DataColumn(
          label: Text(
            'Goal',
          ),
        ),
        DataColumn(
          label: Text(
            'IST-Stichtag',
          ),
        ),
        DataColumn(
          label: Text(
            'Kunden-Forecast',
          ),
        ),
        DataColumn(
          label: Text(
            'Projekt-Forecast',
          ),
        ),
        DataColumn(
          label: Text(
            'IST + Forecast',
          ),
        ),
        DataColumn(
          label: Text(
            'Status',
          ),
        ),
      ],
      rows: <DataRow>[
        DataRow(
          cells: <DataCell>[
            DataCell(Text('Nick')),
            DataCell(Text('19.000')),
            DataCell(Text('19.000')),
            DataCell(Text('19.000')),
            DataCell(Text('19.000')),
            DataCell(Text('22.000')),
            DataCell(Text('')),
          ],
        ),
        DataRow(
          cells: <DataCell>[
            DataCell(Text('Nick')),
            DataCell(Text('19.000')),
            DataCell(Text('19.000')),
            DataCell(Text('19.000')),
            DataCell(Text('19.000')),
            DataCell(Text('22.000')),
            DataCell(CircularPercentIndicator(
              radius: 35.0,
              percent: 0.10,
              center: Text("10%"),
              progressColor: Colors.red,
            ),)
          ],
        ),
        DataRow(
          cells: <DataCell>[
            DataCell(Text('Nick')),
            DataCell(Text('19.000')),
            DataCell(Text('19.000')),
            DataCell(Text('19.000')),
            DataCell(Text('19.000')),
            DataCell(Text('22.000')),
            DataCell(Text('')),
          ],
        ),
      ],
    );
  }
}
