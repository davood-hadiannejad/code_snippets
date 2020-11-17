import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:intl/intl.dart';
import 'package:visoonfrontend/screens/customer_forecast_screen.dart';

import '../screens/project_forecast_screen.dart';
import '../providers/summary.dart';
import '../screens/detail_screen.dart';
import './dashboard_chart.dart';

final formatter = new NumberFormat.currency(locale: 'eu', decimalDigits: 0);
final currentYear = new DateTime.now().year.toString();
final lastYear = (DateTime.now().year - 1).toString();

class DashboardItem extends StatelessWidget {
  final Summary summaryItem;
  final String activeTab;

  DashboardItem(this.summaryItem, this.activeTab);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(12.0),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        width: double.infinity,
        child: Row(
          children: [
            Column(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 10),
                  width: 490,
                  height: 40,
                  child: AutoSizeText(
                    summaryItem.name,
                    style: Theme.of(context).textTheme.headline4,
                    maxLines: 1,
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  width: 500,
                  child: Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    defaultColumnWidth: IntrinsicColumnWidth(),
                    border: TableBorder.all(color: Colors.grey, width: 1),
                    children: [
                      TableRow(children: [
                        TableCell(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(child: Text('')),
                        )),
                        TableCell(
                          child: Center(
                              child: Text(
                            currentYear,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                        ),
                        TableCell(
                            child: Center(
                                child: Text(lastYear,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold)))),
                        TableCell(
                            child: Center(
                                child: Text(
                          'Vergleich',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ))),
                      ]),
                      TableRow(children: [
                        TableCell(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                              child: Text('Goal',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                        )),
                        TableCell(
                          child: Center(
                              child: Text(summaryItem.goal[currentYear] != null
                                  ? formatter
                                      .format(summaryItem.goal[currentYear])
                                  : '')),
                        ),
                        TableCell(
                            child: Center(
                                child: Text(summaryItem.goal[lastYear] != null
                                    ? summaryItem.goal[lastYear].toString()
                                    : ''))),
                        TableCell(child: Center(child: Text('Value'))),
                      ]),
                      TableRow(
                        children: [
                          TableCell(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                                child: Text('IST Stichtag',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                          )),
                          TableCell(
                            child: Center(child: Text('Value')),
                          ),
                          TableCell(child: Center(child: Text('Value'))),
                          TableCell(child: Center(child: Text('Value'))),
                        ],
                      ),
                      TableRow(
                        children: [
                          TableCell(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Center(
                                    child: Text(
                                  'delta Goal',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                                Center(
                                    child: Text(
                                  'Stichtag %',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                              ],
                            ),
                          )),
                          TableCell(
                            child: Center(child: Text('Value')),
                          ),
                          TableCell(child: Center(child: Text('Value'))),
                          TableCell(child: Center(child: Text('Value'))),
                        ],
                      ),
                      TableRow(
                        children: [
                          TableCell(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                                child: Text(
                              'Forecast',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                          )),
                          TableCell(
                            child: Center(child: Text('Value')),
                          ),
                          TableCell(child: Center(child: Text('Value'))),
                          TableCell(child: Center(child: Text('Value'))),
                        ],
                      ),
                      TableRow(
                        children: [
                          TableCell(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                                child: Text(
                              'IST + Forecast',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                          )),
                          TableCell(
                            child: Center(child: Text('Value')),
                          ),
                          TableCell(child: Center(child: Text('Value'))),
                          TableCell(child: Center(child: Text('Value'))),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: 400,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          FlatButton(
                            color: Theme.of(context).accentColor,
                            textColor: Colors.white,
                            minWidth: 120,
                            onPressed: () {
                              Navigator.of(context).pushNamed(
                                  CustomerForecastScreen.routeName,
                                  arguments: {
                                    'pageType': activeTab,
                                    'id': summaryItem.id,
                                  });
                            },
                            child: Text(
                              'Kundenforecast',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                          SizedBox(width: 20),
                          Text('€ 300.000'),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          FlatButton(
                            color: Theme.of(context).accentColor,
                            textColor: Colors.white,
                            minWidth: 120,
                            onPressed: () {
                              Navigator.of(context).pushNamed(
                                  ProjectForecastScreen.routeName,
                                  arguments: {
                                    'pageType': activeTab,
                                    'id': summaryItem.id,
                                  });
                            },
                            child: Text(
                              'Projektforecast',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                          SizedBox(width: 20),
                          Text('€ 100.000'),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(width: 50),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Goal',
                  style: Theme.of(context).textTheme.headline4,
                ),
                Container(
                    width: 300,
                    height: 300,
                    child: DashboardChart.withSampleData()),
                FlatButton(
                  color: Theme.of(context).accentColor,
                  textColor: Colors.white,
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed(DetailScreen.routeName, arguments: {
                      'pageType': activeTab,
                      'id': summaryItem.id,
                    });
                  },
                  child: Text(
                    'Monatsübersicht',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
            SizedBox(width: 40),
            Container(
              height: 380,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Globalrate',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: 280,
                    child: Table(
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      defaultColumnWidth: IntrinsicColumnWidth(),
                      border: TableBorder.all(color: Colors.grey, width: 1),
                      children: [
                        TableRow(children: [
                          TableCell(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(child: Text('')),
                          )),
                          TableCell(
                            child: Center(
                                child: Text(
                              'MN3 / MB3 in %',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                          ),
                        ]),
                        TableRow(children: [
                          TableCell(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                                child: Text('2020 IST ',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                          )),
                          TableCell(
                            child: Center(child: Text('Value')),
                          ),
                        ]),
                        TableRow(
                          children: [
                            TableCell(
                                child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                  child: Text('2020 Forecast',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))),
                            )),
                            TableCell(
                              child: Center(child: Text('Value')),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            TableCell(
                                child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                  child: Text(
                                '2020 Gesamt',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )),
                            )),
                            TableCell(
                              child: Center(child: Text('Value')),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            TableCell(
                                child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                  child: Text(
                                '2019 IST',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                            )),
                            TableCell(
                              child: Center(child: Text('Value')),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
