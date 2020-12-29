import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/detail.dart';
import './monthly_chart.dart';
import './monthly_chart_detail.dart';
import '../screens/project_forecast_screen.dart';
import '../screens/detail_screen.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';

final formatter =
    new NumberFormat.simpleCurrency(locale: 'eu', decimalDigits: 0);
final formatterPercent =
    new NumberFormat.decimalPercentPattern(locale: 'de', decimalDigits: 0);

List<String> _month = [
  'm1',
  'm2',
  'm3',
  'm4',
  'm5',
  'm6',
  'm7',
  'm8',
  'm9',
  'm10',
  'm11',
  'm12'
];

class DetailItem extends StatelessWidget {
  final Detail detailData;
  final String pageType;
  final ScrollController _scrollController = ScrollController();
  final ScrollController _scrollController2 = ScrollController();

  Future<void> _showRelatedDialog(context) async {
    String futurePageType;
    String futurePageTypeTitle;

    if (pageType == 'Konzern' || pageType == 'Agentur') {
      futurePageType = 'Kunde';
      futurePageTypeTitle = 'Kundenliste';
    } else if (pageType == 'Agenturnetzwerk') {
      futurePageType = 'Agentur';
      futurePageTypeTitle = 'Agenturliste';
    }

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(futurePageTypeTitle),
          content: SingleChildScrollView(
            child: ListBody(
              children: detailData.subType
                  .map((subTypeItem) => FlatButton(
                        child: Text(subTypeItem['name']),
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context)
                              .pushNamed(DetailScreen.routeName, arguments: {
                            'pageType': futurePageType,
                            'id': subTypeItem['name_slug'].toString(),
                          });
                        },
                      ))
                  .toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Zurück'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  DetailItem(this.detailData, this.pageType);

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: [
        Card(
          margin: EdgeInsets.all(12.0),
          child: Container(
            padding: const EdgeInsets.all(8.0),
            width: double.infinity,
            height: double.infinity,
            child: DraggableScrollbar.rrect(
              alwaysVisibleScrollThumb: true,
              controller: _scrollController,
              child: ListView(
                controller: _scrollController,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FlatButton.icon(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        label: Text('Zurück'),
                        icon: Icon(Icons.arrow_back_ios),
                      ),
                      (pageType != 'Kunde')
                          ? Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 80),
                              child: RaisedButton(
                                  onPressed: () {
                                    _showRelatedDialog(context);
                                  },
                                  child: (pageType == 'Agenturnetzwerk')
                                      ? Text('Agenturliste')
                                      : Text('Kundenliste')),
                            )
                          : SizedBox(
                              width: 50,
                            ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '$pageType: ${detailData.name}',
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ),
                  SizedBox(height: 20),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Monatlicher Umsatz',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      Container(
                        width: 1200,
                        height: 300,
                        child: MonthlyChart.withData(
                          detailData.goalGesamt,
                          detailData.istStichtagGesamt,
                          detailData.kundenForecastGesamt,
                          detailData.projektForecastGesamt,
                          showProjekt: false,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 50),
                  Row(
                    children: [
                      Container(
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'aktueller Stand gebuchte Konditionen',
                                  style: Theme.of(context).textTheme.headline5,
                                ),
                                Row(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Cash-Rabatt: ',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6,
                                        ),
                                        Text(
                                          (detailData.cashRabatt != null)
                                              ? formatterPercent.format(
                                                  detailData.cashRabatt / 100)
                                              : 'N/A',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6,
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Naturalrabatt: ',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6,
                                        ),
                                        Text(
                                          (detailData.naturalRabatt != null)
                                              ? formatterPercent.format(
                                                  detailData.naturalRabatt / 100)
                                              : 'N/A',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6,
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Global Rate: ',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6,
                                        ),
                                        Text(
                                          (detailData.globalRate != null)
                                              ? formatterPercent.format(
                                                  detailData.globalRate / 100)
                                              : 'N/A',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6,
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 50),
                  Container(
                    width: 1200,
                    child: buildCustomerTable(context),
                  ),
                  Container(
                      width: 1200,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 50),
                        child: buildProjectTable(context),
                      )),
                ],
              ),
            ),
          ),
        ),
        Card(
          margin: EdgeInsets.all(12.0),
          child: Container(
            padding: const EdgeInsets.all(8.0),
            width: double.infinity,
            height: double.infinity,
            child: DraggableScrollbar.rrect(
              alwaysVisibleScrollThumb: true,
              controller: _scrollController2,
              child: ListView(
                controller: _scrollController2,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FlatButton.icon(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        label: Text('Zurück'),
                        icon: Icon(Icons.arrow_back_ios),
                      ),
                      (pageType != 'Kunde')
                          ? Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 80),
                              child: RaisedButton(
                                  onPressed: () {
                                    _showRelatedDialog(context);
                                  },
                                  child: (pageType == 'Agenturnetzwerk')
                                      ? Text('Agenturliste')
                                      : Text('Kundenliste')),
                            )
                          : SizedBox(
                              width: 50,
                            ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      detailData.name,
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ),
                  SizedBox(height: 20),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 1200,
                        height: 300,
                        child: MonthlyChartDetail.withData(
                          detailData.tv,
                          detailData.online,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 50),
                  Container(
                    width: 1200,
                    child: buildDetailTable(context),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  DataTable buildDetailTable(context) {
    return DataTable(
      columnSpacing: 0,
      columns: const <DataColumn>[
        DataColumn(
          label: Text(
            '',
          ),
        ),
        DataColumn(
          label: Text(
            '',
          ),
        ),
        DataColumn(
            label: Expanded(
          child: Text(
            'Januar',
            textAlign: TextAlign.end,
          ),
        )),
        DataColumn(
            label: Expanded(
          child: Text(
            'Februar',
            textAlign: TextAlign.end,
          ),
        )),
        DataColumn(
            label: Expanded(
          child: Text(
            'März',
            textAlign: TextAlign.end,
          ),
        )),
        DataColumn(
            label: Expanded(
          child: Text(
            'April',
            textAlign: TextAlign.end,
          ),
        )),
        DataColumn(
            label: Expanded(
          child: Text(
            'Mai',
            textAlign: TextAlign.end,
          ),
        )),
        DataColumn(
            label: Expanded(
          child: Text(
            'Juni',
            textAlign: TextAlign.end,
          ),
        )),
        DataColumn(
            label: Expanded(
          child: Text(
            'Juli',
            textAlign: TextAlign.end,
          ),
        )),
        DataColumn(
            label: Expanded(
          child: Text(
            'August',
            textAlign: TextAlign.end,
          ),
        )),
        DataColumn(
            label: Expanded(
          child: Text(
            'September',
            textAlign: TextAlign.end,
          ),
        )),
        DataColumn(
            label: Expanded(
          child: Text(
            'Oktober',
            textAlign: TextAlign.end,
          ),
        )),
        DataColumn(
            label: Expanded(
          child: Text(
            'November',
            textAlign: TextAlign.end,
          ),
        )),
        DataColumn(
            label: Expanded(
          child: Text(
            'Dezember',
            textAlign: TextAlign.end,
          ),
        )),
        DataColumn(
          label: Expanded(
            child: Text(
              'Summe Jahr',
              textAlign: TextAlign.end,
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'Global Rate',
              textAlign: TextAlign.end,
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'GR(letztes Jahr)',
              textAlign: TextAlign.end,
            ),
          ),
        ),
      ],
      rows: [
        ...detailData.tv
            .map((sales) => DataRow(
                  cells: [
                    DataCell(Text('TV')),
                    DataCell(Text(sales['name'])),
                    ..._month
                        .map((month) => DataCell(Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(formatter.format(sales[month])),
                              ],
                            )))
                        .toList(),
                    DataCell(Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(formatter.format(_month
                            .map((month) => sales[month])
                            .toList()
                            .reduce((a, b) => a + b))),
                      ],
                    )),
                    DataCell(Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text((sales['global_rate'] != null)
                            ? formatterPercent
                                .format(sales['global_rate'] / 100)
                            : 'N/A'),
                      ],
                    )),
                    DataCell(Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text((sales['global_rate_letztes_jahr'] != null)
                            ? formatterPercent
                                .format(sales['global_rate_letztes_jahr'] / 100)
                            : 'N/A'),
                      ],
                    )),
                  ],
                ))
            .toList(),
        DataRow(
            color: MaterialStateProperty.resolveWith(
                (Set<MaterialState> states) => Colors.grey[300]),
            cells: [
              DataCell(Text('TV')),
              DataCell(Text('Gesamt')),
              ..._month
                  .map((month) => DataCell(Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(formatter.format(detailData.tv
                              .map((e) => e[month])
                              .toList()
                              .reduce((a, b) => a + b))),
                        ],
                      )))
                  .toList(),
              DataCell(Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(formatter.format(_month
                      .map((month) => detailData.tv
                          .map((e) => e[month])
                          .toList()
                          .reduce((a, b) => a + b))
                      .toList()
                      .reduce((a, b) => a + b))),
                ],
              )),
              DataCell(Text('')),
              DataCell(Text('')),
            ]),
        ...detailData.online
            .map((sales) => DataRow(
                  cells: [
                    DataCell(Text('Online')),
                    DataCell(Text(sales['name'])),
                    ..._month
                        .map((month) => DataCell(Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(formatter.format(sales[month])),
                              ],
                            )))
                        .toList(),
                    DataCell(Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(formatter.format(_month
                            .map((month) => sales[month])
                            .toList()
                            .reduce((a, b) => a + b))),
                      ],
                    )),
                    DataCell(Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text((sales['global_rate'] != null)
                            ? formatterPercent
                                .format(sales['global_rate'] / 100)
                            : 'N/A'),
                      ],
                    )),
                    DataCell(Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text((sales['global_rate_letztes_jahr'] != null)
                            ? formatterPercent
                                .format(sales['global_rate_letztes_jahr'] / 100)
                            : 'N/A'),
                      ],
                    )),
                  ],
                ))
            .toList(),
        DataRow(
            color: MaterialStateProperty.resolveWith(
                (Set<MaterialState> states) => Colors.grey[300]),
            cells: [
              DataCell(Text('Online')),
              DataCell(Text('Gesamt')),
              ..._month
                  .map((month) => DataCell(Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(formatter.format(detailData.online
                              .map((e) => e[month])
                              .toList()
                              .reduce((a, b) => a + b))),
                        ],
                      )))
                  .toList(),
              DataCell(Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(formatter.format(_month
                      .map((month) => detailData.online
                          .map((e) => e[month])
                          .toList()
                          .reduce((a, b) => a + b))
                      .toList()
                      .reduce((a, b) => a + b))),
                ],
              )),
              DataCell(Text('')),
              DataCell(Text('')),
            ]),
        DataRow(
            color: MaterialStateProperty.resolveWith(
                (Set<MaterialState> states) => Colors.grey[500]),
            cells: [
              DataCell(Text('Kunde')),
              DataCell(Text('Gesamt')),
              ..._month
                  .map((month) => DataCell(Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(formatter.format(detailData.online
                                  .map((e) => e[month])
                                  .toList()
                                  .reduce((a, b) => a + b) +
                              detailData.tv
                                  .map((e) => e[month])
                                  .toList()
                                  .reduce((a, b) => a + b))),
                        ],
                      )))
                  .toList(),
              DataCell(Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(formatter.format(_month
                          .map((month) => detailData.online
                              .map((e) => e[month])
                              .toList()
                              .reduce((a, b) => a + b))
                          .toList()
                          .reduce((a, b) => a + b) +
                      _month
                          .map((month) => detailData.tv
                              .map((e) => e[month])
                              .toList()
                              .reduce((a, b) => a + b))
                          .toList()
                          .reduce((a, b) => a + b))),
                ],
              )),
              DataCell(Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text((detailData.globalRate != null)
                      ? formatterPercent.format(detailData.globalRate / 100)
                      : 'N/A'),
                ],
              )),
              DataCell(Text('')),
            ]),
      ],
    );
  }

  DataTable buildCustomerTable(context) {
    return DataTable(columnSpacing: 0, columns: const <DataColumn>[
      DataColumn(
        label: Text(
          '',
        ),
      ),
      DataColumn(
          label: Expanded(
        child: Text(
          'Januar',
          textAlign: TextAlign.end,
        ),
      )),
      DataColumn(
          label: Expanded(
        child: Text(
          'Februar',
          textAlign: TextAlign.end,
        ),
      )),
      DataColumn(
          label: Expanded(
        child: Text(
          'März',
          textAlign: TextAlign.end,
        ),
      )),
      DataColumn(
          label: Expanded(
        child: Text(
          'April',
          textAlign: TextAlign.end,
        ),
      )),
      DataColumn(
          label: Expanded(
        child: Text(
          'Mai',
          textAlign: TextAlign.end,
        ),
      )),
      DataColumn(
          label: Expanded(
        child: Text(
          'Juni',
          textAlign: TextAlign.end,
        ),
      )),
      DataColumn(
          label: Expanded(
        child: Text(
          'Juli',
          textAlign: TextAlign.end,
        ),
      )),
      DataColumn(
          label: Expanded(
        child: Text(
          'August',
          textAlign: TextAlign.end,
        ),
      )),
      DataColumn(
          label: Expanded(
        child: Text(
          'September',
          textAlign: TextAlign.end,
        ),
      )),
      DataColumn(
          label: Expanded(
        child: Text(
          'Oktober',
          textAlign: TextAlign.end,
        ),
      )),
      DataColumn(
          label: Expanded(
        child: Text(
          'November',
          textAlign: TextAlign.end,
        ),
      )),
      DataColumn(
          label: Expanded(
        child: Text(
          'Dezember',
          textAlign: TextAlign.end,
        ),
      )),
      DataColumn(
        label: Expanded(
          child: Text(
            'Summe Jahr',
            textAlign: TextAlign.end,
          ),
        ),
      ),
    ], rows: [
      DataRow(
        cells: [
          DataCell(Text('Goal')),
          ..._month
              .map((month) => DataCell(Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(formatter.format(detailData.goalGesamt[month])),
                    ],
                  )))
              .toList(),
          DataCell(Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(formatter.format(_month
                  .map((month) => detailData.goalGesamt[month])
                  .toList()
                  .reduce((a, b) => a + b))),
            ],
          ))
        ],
      ),
      DataRow(
        cells: [
          DataCell(Text('IST')),
          ..._month
              .map((month) => DataCell(Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(formatter
                          .format(detailData.istStichtagGesamt[month])),
                    ],
                  )))
              .toList(),
          DataCell(Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(formatter.format(_month
                  .map((month) => detailData.istStichtagGesamt[month])
                  .toList()
                  .reduce((a, b) => a + b))),
            ],
          ))
        ],
      ),
      DataRow(
        cells: [
          DataCell(Text('Kundenforecast')),
          ..._month
              .map((month) => DataCell(Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(formatter
                          .format(detailData.kundenForecastGesamt[month])),
                    ],
                  )))
              .toList(),
          DataCell(Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(formatter.format(_month
                  .map((month) => detailData.kundenForecastGesamt[month])
                  .toList()
                  .reduce((a, b) => a + b))),
            ],
          ))
        ],
      ),
      DataRow(
        cells: [
          DataCell(Text('IST + Forecast')),
          ..._month
              .map((month) => DataCell(Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(formatter.format(
                          detailData.kundenForecastGesamt[month] +
                              detailData.istStichtagGesamt[month])),
                    ],
                  )))
              .toList(),
          DataCell(Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(formatter.format(_month
                  .map((month) =>
                      detailData.kundenForecastGesamt[month] +
                      detailData.istStichtagGesamt[month])
                  .toList()
                  .reduce((a, b) => a + b))),
            ],
          ))
        ],
      ),
    ]);
  }

  DataTable buildProjectTable(context) {
    return DataTable(
      showCheckboxColumn: false,
      columns: <DataColumn>[
        DataColumn(
          label: Text(
            'Projekt',
          ),
        ),
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
              'MN3 bewertet',
              textAlign: TextAlign.end,
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'Bewertung',
              textAlign: TextAlign.end,
            ),
          ),
        ),
        DataColumn(
          label: Text(
            'Due Date',
          ),
        ),
        DataColumn(
          label: Text(
            'Status',
          ),
        ),
      ],
      rows: (detailData.projects != null)
          ? detailData.projects
              .map((project) => DataRow(
                    onSelectChanged: (bool) {
                      Navigator.of(context)
                          .pushNamed(ProjectForecastScreen.routeName);
                    },
                    cells: <DataCell>[
                      DataCell((project['comment'] != null &&
                              project['comment'] != '')
                          ? Tooltip(
                              message: project['comment'],
                              waitDuration: Duration(microseconds: 300),
                              child: Text(project['name']))
                          : Text(project['name'])),
                      DataCell(Text(project['medium'])),
                      DataCell(Text(project['brand'])),
                      DataCell(Container(
                        width: 110,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(formatter.format(
                                project['mn3'] * project['bewertung'] / 100)),
                          ],
                        ),
                      )),
                      DataCell(Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(project['bewertung'].toString() + '%'),
                        ],
                      )),
                      DataCell(Text(project['dueDate'])),
                      DataCell(Text(project['status'])),
                    ],
                  ))
              .toList()
          : [],
    );
  }

  Color getProgressColor(double percent) {
    if (percent >= 1.0) {
      return Colors.green;
    } else if (percent > 0.7) {
      return Colors.yellow;
    } else {
      return Colors.red;
    }
  }
}
