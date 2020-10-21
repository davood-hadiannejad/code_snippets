import 'package:flutter/material.dart';

class BookingWidget extends StatefulWidget {
  static const int numItems = 10;

  @override
  _BookingWidgetState createState() => _BookingWidgetState();
}

class _BookingWidgetState extends State<BookingWidget> {
  List<bool> selected =
      List<bool>.generate(BookingWidget.numItems, (index) => false);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: DataTable(
        columns: const <DataColumn>[
          DataColumn(
            label: const Text('Buchungs Nummer'),
          ),
        ],
        rows: List<DataRow>.generate(
          BookingWidget.numItems,
          (index) => DataRow(
            cells: [DataCell(Text('Buchung $index'))],
            selected: selected[index],
            onSelectChanged: (bool value) {
              setState(() {
                selected[index] = value;
              });
            },
          ),
        ),
      ),
    );
  }
}
