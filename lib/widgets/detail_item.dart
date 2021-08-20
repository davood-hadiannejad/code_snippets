import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

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

List<String> monthItems = [
  'Jan',
  'Feb',
  'Mär',
  'Apr',
  'Mai',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Okt',
  'Nov',
  'Dez'
];

class DetailItem extends StatefulWidget {
  final Detail detailData;
  final String pageType;

  DetailItem(this.detailData, this.pageType);

  @override
  _DetailItemState createState() => _DetailItemState();
}

class _DetailItemState extends State<DetailItem> {
  final ScrollController _scrollController = ScrollController();

  final ScrollController _scrollController2 = ScrollController();
  List<bool> isSelected = [true, false];

  Future<void> _showRelatedDialog(context) async {
    String futurePageType;
    String futurePageTypeTitle;

    if (widget.pageType == 'Konzern' || widget.pageType == 'Agentur') {
      futurePageType = 'Kunde';
      futurePageTypeTitle = 'Kundenliste';
    } else if (widget.pageType == 'Agenturnetzwerk') {
      futurePageType = 'Agentur';
      futurePageTypeTitle = 'Agenturliste';
    } else if (widget.pageType == 'Kunde') {
      futurePageType = 'Konzern';
      futurePageTypeTitle = 'Konzernliste';
    }

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(futurePageTypeTitle),
          content: SingleChildScrollView(
            child: ListBody(
              children: widget.detailData.subType
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

  String _returnFirstMonth(Map<String, dynamic> projects) {
    String firstMonth = '';
    String firstMonthKey;
    for (String key in _month) {
      if (projects[key] != 0 && projects[key] != null) {
        firstMonthKey = key;
        break;
      }
    }
    if (firstMonthKey != null) {
      firstMonth = monthItems[_month.indexOf(firstMonthKey)];
    }
    return firstMonth;
  }

  String _returnLastMonth(Map<String, dynamic> projects) {
    String lastMonth = '';
    String lastMonthKey;
    for (String key in _month.reversed) {
      if (projects[key] != 0 && projects[key] != null) {
        lastMonthKey = key;
        break;
      }
    }
    if (lastMonthKey != null) {
      lastMonth = monthItems[_month.indexOf(lastMonthKey)];
    }
    return lastMonth;
  }

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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 80),
                        child: RaisedButton(
                            onPressed: () {
                              _showRelatedDialog(context);
                            },
                            child: (widget.pageType == 'Agenturnetzwerk')
                                ? Text('Agenturliste')
                                : (widget.pageType == 'Kunde')
                                    ? Text('Konzern')
                                    : Text('Kundenliste')),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${widget.pageType}: ${widget.detailData.name}',
                      style: Theme.of(context).textTheme.headline5,
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
                          widget.detailData.goalGesamt,
                          widget.detailData.istStichtagGesamt,
                          widget.detailData.kundenForecastGesamt,
                          widget.detailData.projektForecastGesamt,
                          onlyIst: (isSelected[0]) ? true : false,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 50),
                  Container(
                    width: 1200,
                    child: SizedBox(
                      height: 100,
                    ),
                  ),
                  ToggleButtons(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Monatsansicht'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Gesamtansicht'),
                      ),
                    ],
                    onPressed: (int index) {
                      setState(() {
                        if (isSelected[index]) {
                          isSelected = [true, true];
                          isSelected[index] = false;
                        } else {
                          isSelected = [false, false];
                          isSelected[index] = true;
                        }
                      });
                    },
                    isSelected: isSelected,
                  ),
                  (isSelected[0])
                      ? Container(width: 1200, child: buildBrandTable(context))
                      : Container(
                          width: 1200, child: buildBrandGesamtTable(context)),
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 80),
                        child: RaisedButton(
                            onPressed: () {
                              _showRelatedDialog(context);
                            },
                            child: (widget.pageType == 'Agenturnetzwerk')
                                ? Text('Agenturliste')
                                : (widget.pageType == 'Kunde')
                                    ? Text('Konzern')
                                    : Text('Kundenliste')),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${widget.pageType}: ${widget.detailData.name}',
                      style: Theme.of(context).textTheme.headline5,
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
                          widget.detailData.goalGesamt,
                          widget.detailData.istStichtagGesamt,
                          widget.detailData.kundenForecastGesamt,
                          widget.detailData.projektForecastGesamt,
                          showProjekt: true,
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
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Cash-Rabatt: ',
                                        ),
                                        Text(
                                          (widget.detailData.cashRabatt != null)
                                              ? formatterPercent.format(
                                                  widget.detailData.cashRabatt /
                                                      100)
                                              : 'N/A',
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
                                        ),
                                        Text(
                                          (widget.detailData.naturalRabatt !=
                                                  null)
                                              ? formatterPercent.format(widget
                                                      .detailData
                                                      .naturalRabatt /
                                                  100)
                                              : 'N/A',
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
                                        ),
                                        Text(
                                          (widget.detailData.globalRate != null)
                                              ? formatterPercent.format(
                                                  widget.detailData.globalRate /
                                                      100)
                                              : 'N/A',
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 80),
                        child: RaisedButton(
                            onPressed: () {
                              _showRelatedDialog(context);
                            },
                            child: (widget.pageType == 'Agenturnetzwerk')
                                ? Text('Agenturliste')
                                : (widget.pageType == 'Kunde')
                                    ? Text('Konzern')
                                    : Text('Kundenliste')),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${widget.pageType}: ${widget.detailData.name}',
                      style: Theme.of(context).textTheme.headline5,
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
                          widget.detailData.tv,
                          widget.detailData.online,
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
              'GR(VJ)',
              textAlign: TextAlign.end,
            ),
          ),
        ),
      ],
      rows: [
        ...widget.detailData.tv
            .map((sales) => DataRow(
                  color: (sales['name'] == 'Gesamt')
                      ? MaterialStateProperty.resolveWith(
                          (Set<MaterialState> states) => Colors.grey[300])
                      : null,
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
//        DataRow(
//            color: MaterialStateProperty.resolveWith(
//                (Set<MaterialState> states) => Colors.grey[300]),
//            cells: [
//              DataCell(Text('TV')),
//              DataCell(Text('Gesamt')),
//              ..._month
//                  .map((month) => DataCell(Row(
//                        mainAxisAlignment: MainAxisAlignment.end,
//                        children: [
//                          Text(formatter.format(detailData.tv
//                              .map((e) => e[month])
//                              .toList()
//                              .reduce((a, b) => a + b))),
//                        ],
//                      )))
//                  .toList(),
//              DataCell(Row(
//                mainAxisAlignment: MainAxisAlignment.end,
//                children: [
//                  Text(formatter.format(_month
//                      .map((month) => detailData.tv
//                          .map((e) => e[month])
//                          .toList()
//                          .reduce((a, b) => a + b))
//                      .toList()
//                      .reduce((a, b) => a + b))),
//                ],
//              )),
//              DataCell(Text('')),
//              DataCell(Text('')),
//            ]),
        ...widget.detailData.online
            .map((sales) => DataRow(
                  color: (sales['name'] == 'Gesamt')
                      ? MaterialStateProperty.resolveWith(
                          (Set<MaterialState> states) => Colors.grey[300])
                      : null,
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
//        DataRow(
//            color: MaterialStateProperty.resolveWith(
//                (Set<MaterialState> states) => Colors.grey[300]),
//            cells: [
//              DataCell(Text('Online')),
//              DataCell(Text('Gesamt')),
//              ..._month
//                  .map((month) => DataCell(Row(
//                        mainAxisAlignment: MainAxisAlignment.end,
//                        children: [
//                          Text(formatter.format(detailData.online
//                              .map((e) => e[month])
//                              .toList()
//                              .reduce((a, b) => a + b))),
//                        ],
//                      )))
//                  .toList(),
//              DataCell(Row(
//                mainAxisAlignment: MainAxisAlignment.end,
//                children: [
//                  Text(formatter.format(_month
//                      .map((month) => detailData.online
//                          .map((e) => e[month])
//                          .toList()
//                          .reduce((a, b) => a + b))
//                      .toList()
//                      .reduce((a, b) => a + b))),
//                ],
//              )),
//              DataCell(Text('')),
//              DataCell(Text('')),
//            ]),
        DataRow(
            color: MaterialStateProperty.resolveWith(
                (Set<MaterialState> states) => Colors.grey[500]),
            cells: [
              DataCell(Text(widget.detailData.name)),
              DataCell(Text('Gesamt')),
              ..._month
                  .map((month) => DataCell(Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(formatter.format(widget.detailData.online
                                  .map((e) =>
                                      (e['name'] != 'Gesamt') ? e[month] : 0)
                                  .toList()
                                  .reduce((a, b) => a + b) +
                              widget.detailData.tv
                                  .map((e) =>
                                      (e['name'] != 'Gesamt') ? e[month] : 0)
                                  .toList()
                                  .reduce((a, b) => a + b))),
                        ],
                      )))
                  .toList(),
              DataCell(Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(formatter.format(_month
                          .map((month) => widget.detailData.online
                              .map(
                                  (e) => (e['name'] != 'Gesamt') ? e[month] : 0)
                              .toList()
                              .reduce((a, b) => a + b))
                          .toList()
                          .reduce((a, b) => a + b) +
                      _month
                          .map((month) => widget.detailData.tv
                              .map(
                                  (e) => (e['name'] != 'Gesamt') ? e[month] : 0)
                              .toList()
                              .reduce((a, b) => a + b))
                          .toList()
                          .reduce((a, b) => a + b))),
                ],
              )),
              DataCell(Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text((widget.detailData.globalRate != null)
                      ? formatterPercent
                          .format(widget.detailData.globalRate / 100)
                      : 'N/A'),
                ],
              )),
              DataCell(Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text((widget.detailData.globalRateLastYear != null)
                      ? formatterPercent
                          .format(widget.detailData.globalRateLastYear / 100)
                      : 'N/A'),
                ],
              )),
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
                      Text(formatter
                          .format(widget.detailData.goalGesamt[month])),
                    ],
                  )))
              .toList(),
          DataCell(Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(formatter.format(_month
                  .map((month) => widget.detailData.goalGesamt[month])
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
                          .format(widget.detailData.istStichtagGesamt[month])),
                    ],
                  )))
              .toList(),
          DataCell(Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(formatter.format(_month
                  .map((month) => widget.detailData.istStichtagGesamt[month])
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
                      Text(formatter.format(
                          widget.detailData.kundenForecastGesamt[month])),
                    ],
                  )))
              .toList(),
          DataCell(Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(formatter.format(_month
                  .map((month) => widget.detailData.kundenForecastGesamt[month])
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
                          widget.detailData.kundenForecastGesamt[month] +
                              widget.detailData.istStichtagGesamt[month])),
                    ],
                  )))
              .toList(),
          DataCell(Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(formatter.format(_month
                  .map((month) =>
                      widget.detailData.kundenForecastGesamt[month] +
                      widget.detailData.istStichtagGesamt[month])
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
              'Zeitraum',
              textAlign: TextAlign.center,
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
      rows: (widget.detailData.projects != null)
          ? widget.detailData.projects
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
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(formatter.format(
                                project['mn3'] * project['bewertung'] / 100)),
                          ],
                        ),
                      )),
                      DataCell(Container(
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text((_returnFirstMonth(project) ==
                                _returnLastMonth(project))
                                ? _returnFirstMonth(project)
                                : _returnFirstMonth(project) +
                                ' - ' +
                                _returnLastMonth(project)),
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

  DataTable buildBrandTable(context) {
    return DataTable(
        columnSpacing: 0,
        showCheckboxColumn: false,
        columns: const <DataColumn>[
          DataColumn(
            label: Text(
              'Brand',
            ),
          ),
          DataColumn(
            label: Text(
              'Mandant',
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
                'GR (VJ)',
                textAlign: TextAlign.end,
              ),
            ),
          ),
        ],
        rows: [
          ...widget.detailData.brands
              .map((brand) => DataRow(
                    onSelectChanged: (bool) {
                      Navigator.of(context)
                          .pushNamed(DetailScreen.routeName, arguments: {
                        'pageType': 'Brand',
                        'id': brand['brand_slug'].toString(),
                      });
                    },
                    color: (brand['brand'] == 'Gesamt')
                        ? MaterialStateProperty.resolveWith(
                            (Set<MaterialState> states) => Colors.grey[300])
                        : null,
                    cells: [
                      DataCell(Text(brand['brand'])),
                      DataCell(Text(brand['mandant'])),
                      ..._month
                          .map((month) => DataCell(Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(formatter.format(brand[month])),
                                ],
                              )))
                          .toList(),
                      DataCell(Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(formatter.format(_month
                              .map((month) => brand[month])
                              .toList()
                              .reduce((a, b) => a + b))),
                        ],
                      )),
                      DataCell(Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text((brand['rate'] != null)
                              ? formatterPercent
                              .format(brand['rate'] / 100)
                              : 'N/A'),
                        ],
                      )),
                      DataCell(Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text((brand['rate_letztes_jahr'] != null)
                              ? formatterPercent
                              .format(brand['rate_letztes_jahr'] / 100)
                              : 'N/A')
                        ],
                      )),
                    ],
                  ))
              .toList(),
          DataRow(
              color: MaterialStateProperty.resolveWith(
                  (Set<MaterialState> states) => Colors.grey[500]),
              cells: [
                DataCell(Text(widget.detailData.name)),
                DataCell(Text('Gesamt')),
                ..._month
                    .map((month) => DataCell(Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(formatter.format(widget.detailData.brands.map(
                                (brand) => (brand['name'] != 'Gesamt')
                                    ? brand[month]
                                    : 0).reduce((a, b) => a + b))),
                          ],
                        )))
                    .toList(),
                DataCell(Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(formatter.format(_month
                        .map((month) => widget.detailData.brands
                            .map((brand) =>
                                (brand['name'] != 'Gesamt') ? brand[month] : 0)
                            .toList()
                            .reduce((a, b) => a + b))
                        .toList()
                        .reduce((a, b) => a + b)))
                  ],
                )),
                DataCell(Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text((widget.detailData.globalRate != null)
                        ? formatterPercent
                            .format(widget.detailData.globalRate / 100)
                        : 'N/A'),
                  ],
                )),
                DataCell(Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text((widget.detailData.globalRateLastYear != null)
                        ? formatterPercent
                            .format(widget.detailData.globalRateLastYear / 100)
                        : 'N/A'),
                  ],
                )),
              ]),
        ]);
  }

  DataTable buildBrandGesamtTable(context) {
    return DataTable(
      showCheckboxColumn: false,
      columns: const <DataColumn>[
        DataColumn(
          label: Text(
            'Brand',
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'Goal',
              textAlign: TextAlign.end,
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'IST-Stichtag',
              textAlign: TextAlign.end,
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'Kundenforecast',
              textAlign: TextAlign.end,
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'Projektforecast',
              textAlign: TextAlign.end,
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'IST + Forecast',
              textAlign: TextAlign.end,
            ),
          ),
        ),
        DataColumn(
          label: Text(
            'Status',
          ),
        ),
      ],
      rows: (widget.detailData.brands != null)
          ? widget.detailData.brands
              .map((brand) => DataRow(
                      color: (brand['name'] == 'Gesamt')
                          ? MaterialStateProperty.resolveWith(
                              (Set<MaterialState> states) => Colors.grey[300])
                          : null,
                      onSelectChanged: (bool) {
                        Navigator.of(context)
                            .pushNamed(DetailScreen.routeName, arguments: {
                          'pageType': 'Brand',
                          'id': brand['name_slug'].toString(),
                        });
                      },
                      cells: [
                        DataCell(Text(brand['name'])),
                        DataCell(Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(formatter.format(brand['goal'])),
                          ],
                        )),
                        DataCell(Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(formatter.format(brand['ist_stichtag'])),
                          ],
                        )),
                        DataCell(Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(formatter.format(brand['kunden_forecast'])),
                          ],
                        )),
                        DataCell(Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(formatter.format(brand['projekt_forecast'])),
                          ],
                        )),
                        DataCell(Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(formatter.format(brand['ist_stichtag'] +
                                brand['projekt_forecast'] +
                                brand['kunden_forecast'])),
                          ],
                        )),
                        DataCell(
                          CircularPercentIndicator(
                            radius: 42.0,
                            percent: ((brand['ist_stichtag'] +
                                            brand['projekt_forecast'] +
                                            brand['kunden_forecast']) /
                                        brand['goal'] >
                                    1)
                                ? 1.0
                                : (brand['ist_stichtag'] +
                                        brand['projekt_forecast'] +
                                        brand['kunden_forecast']) /
                                    brand['goal'],
                            center: Text(
                              formatterPercent.format((brand['ist_stichtag'] +
                                      brand['projekt_forecast'] +
                                      brand['kunden_forecast']) /
                                  brand['goal']),
                              style: TextStyle(fontSize: 10),
                            ),
                            progressColor: getProgressColor(
                                (brand['ist_stichtag'] +
                                        brand['projekt_forecast'] +
                                        brand['kunden_forecast']) /
                                    brand['goal']),
                          ),
                        )
                      ]))
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
