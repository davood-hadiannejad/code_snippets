import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:intl/intl.dart';

import '../screens/customer_forecast_screen.dart';
import '../screens/project_forecast_screen.dart';
import '../providers/summary.dart';
import '../screens/detail_screen.dart';
import './dashboard_chart.dart';

final formatter =
    new NumberFormat.simpleCurrency(locale: 'eu', decimalDigits: 0);
final formatterPercent =
    new NumberFormat.decimalPercentPattern(locale: 'de', decimalDigits: 0);
final currentYear = '2020';
final lastYear = '2019';

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
                    style: Theme.of(context).textTheme.headline5,
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
                          'Veränderung',
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
                              child: Text(
                            formatter.format(summaryItem.goal['goal']),
                          )),
                        ),
                        TableCell(
                            child: Center(
                                child: Text(
                          formatter
                              .format(summaryItem.goal['goal_letztes_jahr']),
                        ))),
                        TableCell(
                            child: Center(
                                child: Text((((summaryItem.goal['goal'] /
                                                    summaryItem.goal[
                                                        'goal_letztes_jahr']) -
                                                1) >
                                            0
                                        ? '+'
                                        : '') +
                                    formatterPercent.format((summaryItem
                                                .goal['goal'] /
                                            summaryItem
                                                .goal['goal_letztes_jahr']) -
                                        1)))),
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
                            child: Center(
                                child: Text(formatter
                                    .format(summaryItem.stichtag['ist']))),
                          ),
                          TableCell(
                              child: Center(
                                  child: Text(
                            formatter.format(
                                summaryItem.stichtag['ist_letztes_jahr']),
                          ))),
                          TableCell(
                              child: Center(
                                  child: Text(((summaryItem.stichtag['ist'] /
                                                      summaryItem.stichtag[
                                                          'ist_letztes_jahr'] -
                                                  1) >
                                              0
                                          ? '+'
                                          : '') +
                                      formatterPercent.format(
                                          (summaryItem.stichtag['ist'] /
                                                  summaryItem.stichtag[
                                                      'ist_letztes_jahr']) -
                                              1)))),
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
                                  'Δ Goal',
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
                            child: Center(
                                child: Text((((summaryItem.stichtag['ist'] /
                                                    summaryItem.goal['goal']) -
                                                1) >
                                            0
                                        ? '+'
                                        : '') +
                                    formatterPercent.format(
                                        (summaryItem.stichtag['ist'] /
                                                summaryItem.goal['goal']) -
                                            1))),
                          ),
                          TableCell(
                              child: Center(
                                  child: Text((((summaryItem.stichtag[
                                                          'ist_letztes_jahr'] /
                                                      summaryItem.goal[
                                                          'goal_letztes_jahr']) -
                                                  1) >
                                              0
                                          ? '+'
                                          : '') +
                                      formatterPercent.format((summaryItem
                                                      .stichtag[
                                                  'ist_letztes_jahr'] /
                                              summaryItem
                                                  .goal['goal_letztes_jahr']) -
                                          1)))),
                          TableCell(child: Center(child: Text(''))),
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
                            child: Center(
                                child: Text(
                              formatter.format(summaryItem.forecast['kunde'] +
                                  summaryItem.forecast['projekt']),
                            )),
                          ),
                          TableCell(
                              child: Center(
                                  child: Text(
                            formatter
                                .format(summaryItem.forecast['letztes_jahr']),
                          ))),
                          TableCell(
                              child: Center(
                                  child: Text(((((summaryItem.forecast[
                                                              'kunde'] +
                                                          summaryItem.forecast[
                                                              'projekt']) /
                                                      summaryItem.forecast[
                                                          'letztes_jahr']) -
                                                  1) >
                                              0
                                          ? '+'
                                          : '') +
                                      formatterPercent.format(((summaryItem
                                                      .forecast['kunde'] +
                                                  summaryItem
                                                      .forecast['projekt']) /
                                              summaryItem
                                                  .forecast['letztes_jahr']) -
                                          1)))),
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
                            child: Center(
                                child: Text(
                              formatter.format(summaryItem.forecast['kunde'] +
                                  summaryItem.forecast['projekt'] +
                                  summaryItem.stichtag['ist']),
                            )),
                          ),
                          TableCell(
                              child: Center(
                                  child: Text(
                            formatter.format(
                                summaryItem.forecast['letztes_jahr'] +
                                    summaryItem.stichtag['ist_letztes_jahr']),
                          ))),
                          TableCell(
                              child: Center(
                                  child: Text((((summaryItem.forecast['kunde'] + summaryItem.forecast['projekt'] + summaryItem.stichtag['ist']) /
                                                      (summaryItem.forecast['letztes_jahr'] +
                                                          summaryItem.stichtag[
                                                              'ist_letztes_jahr']) -
                                                  1) >
                                              0
                                          ? '+'
                                          : '') +
                                      formatterPercent.format((summaryItem
                                                      .forecast['kunde'] +
                                                  summaryItem
                                                      .forecast['projekt'] +
                                                  summaryItem.stichtag['ist']) /
                                              (summaryItem.forecast['letztes_jahr'] +
                                                  summaryItem
                                                      .stichtag['ist_letztes_jahr']) -
                                          1)))),
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
                          Text(formatter.format(summaryItem.forecast['kunde'])),
                        ],
                      ),
                      SizedBox(height: 5,),
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
                          Text(formatter
                              .format(summaryItem.forecast['projekt'])),
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
                  style: Theme.of(context).textTheme.headline6,
                ),
                Container(
                    width: 300,
                    height: 300,
                    child: DashboardChart.withData(summaryItem)),
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
                    'Global Rate',
                    style: Theme.of(context).textTheme.headline6,
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
                            child: Center(
                                child: Text('$currentYear IST ',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                          )),
                          TableCell(
                            child: Center(
                                child: (summaryItem.gobalrate['rate'] != null)
                                    ? Text(formatterPercent.format(
                                        summaryItem.gobalrate['rate'] / 100))
                                    : Text('N/A')),
                          ),
                        ]),
                        TableRow(
                          children: [
                            TableCell(
                                child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                  child: Text('$currentYear Forecast',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))),
                            )),
                            TableCell(
                              child: Center(
                                  child: (summaryItem.gobalrate['forecast'] !=
                                          null)
                                      ? Text(formatterPercent.format(
                                          summaryItem.gobalrate['forecast'] /
                                              100))
                                      : Text('N/A')),
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
                                '$currentYear Gesamt',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )),
                            )),
                            TableCell(
                              child: Center(
                                  child:
                                      (summaryItem.gobalrate['gesamt'] != null)
                                          ? Text(formatterPercent.format(
                                              summaryItem.gobalrate['gesamt'] /
                                                  100))
                                          : Text('N/A')),
                            )
                          ],
                        ),
                        TableRow(
                          children: [
                            TableCell(
                                child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                  child: Text(
                                '$lastYear Gesamt',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                            )),
                            TableCell(
                              child: Center(
                                  child: (summaryItem
                                              .gobalrate['rate_letztes_jahr'] !=
                                          null)
                                      ? Text(formatterPercent.format(summaryItem
                                              .gobalrate['rate_letztes_jahr'] /
                                          100))
                                      : Text('N/A')),
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
