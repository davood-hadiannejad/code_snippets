import 'package:flutter/material.dart';
import 'package:visoonfrontend/providers/summary.dart';
import 'package:visoonfrontend/screens/detail_screen.dart';

import './monthly_chart.dart';

class MandantItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.all(12.0),
        child: Container(
          padding: const EdgeInsets.all(8.0),
          width: double.infinity,
          height: double.infinity,
          child: ListView(
            children: [
              FlatButton.icon(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/');
                },
                label: Text('Zurück'),
                icon: Icon(Icons.arrow_back_ios),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Viacom',
                  style: Theme.of(context).textTheme.headline3,
                ),
              ),
              SizedBox(height: 20),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Monatlicher Umsatz',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  Container(
                      width: 1200,
                      height: 300,
                      child: MonthlyChart.withSampleData()),
                ],
              ),
              SizedBox(height: 50),
              Container(
                width: 1200,
                child: Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  defaultColumnWidth: IntrinsicColumnWidth(),
                  border: TableBorder.all(color: Colors.grey, width: 1),
                  children: [
                    TableRow(children: [
                      TableCell(
                        child: Center(
                            child: Text(
                          'Brand',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                      ),
                      TableCell(
                        child: Center(
                            child: Text(
                          'Goal',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                      ),
                      TableCell(
                          child: Center(
                              child: Text('IST Stichtag',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)))),
                      TableCell(
                          child: Center(
                              child: Text(
                        'Kunden Forecast',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ))),
                      TableCell(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                            child: Text('Projekt Forecast',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                      )),
                      TableCell(
                          child: Center(
                              child: Text(
                        'IST + Forecast',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ))),
                      TableCell(
                          child: Center(
                              child: Text(
                        'Status',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ))),
                    ]),
                    TableRow(children: [
                      TableCell(child: Center(child: Text('MTV'))),
                      TableCell(child: Center(child: Text('Value'))),
                      TableCell(child: Center(child: Text('Value'))),
                      TableCell(child: Center(child: Text('Value'))),
                      TableCell(child: Center(child: Text('Value'))),
                      TableCell(child: Center(child: Text('Value'))),
                      TableCell(child: Center(child: Text('Value'))),
                    ]),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
    );
  }
}
