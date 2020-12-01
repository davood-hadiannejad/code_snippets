import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../providers/customer_forecast_list.dart';
import '../providers/customer_forecast.dart';

final formatter = new NumberFormat.simpleCurrency(locale: 'eu', decimalDigits: 0);
final formatterPercent =
new NumberFormat.decimalPercentPattern(locale: 'de', decimalDigits: 0);

class CustomerForecastItem extends StatefulWidget {
  final CustomerForecastList customerForecastData;

  CustomerForecastItem(this.customerForecastData);

  @override
  _CustomerForecastItemState createState() => _CustomerForecastItemState();
}

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

int currentMonth = DateTime
    .now()
    .month;

class _CustomerForecastItemState extends State<CustomerForecastItem> {
  int columnSort;
  bool ascSort = false;
  Map<CustomerForecast, List<TextEditingController>> _controllerList = {};
  Map<CustomerForecast, TextEditingController> _controllerSummary = {};

  //Map<String, <List<TextEditingController>>> _controllerList;

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
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                FlatButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  label: Text('Zurück'),
                  icon: Icon(Icons.arrow_back_ios),
                ),
              ],
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Kunden Forecast',
                style: Theme
                    .of(context)
                    .textTheme
                    .headline5,
              ),
            ),
            Container(
              width: 1400,
              child: DataTable(
                showBottomBorder: true,
                dataRowHeight: 170,
                columnSpacing: 0,
                sortColumnIndex: columnSort,
                sortAscending: ascSort,
                columns: <DataColumn>[
                  DataColumn(
                    label: Center(
                      child: Text(
                        'Kunde',
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Center(
                      child: Text(
                        'Medium',
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Center(
                      child: Text(
                        'Brand',
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Center(
                      child: Text(
                        'Metrik',
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Center(
                      child: Text(
                        'Januar',
                      ),
                    ),
                    onSort: (idx, asc) {
                      setState(() {});
                    },
                  ),
                  DataColumn(
                    label: Text(
                      'Februar',
                    ),
                    onSort: (idx, asc) {
                      setState(() {});
                    },
                  ),
                  DataColumn(
                    label: Text(
                      'März',
                    ),
                    onSort: (idx, asc) {
                      setState(() {});
                    },
                  ),
                  DataColumn(
                    label: Text(
                      'April',
                    ),
                    onSort: (idx, asc) {
                      setState(() {});
                    },
                  ),
                  DataColumn(
                    label: Text(
                      'Mai',
                    ),
                    onSort: (idx, asc) {
                      setState(() {});
                    },
                  ),
                  DataColumn(
                    label: Text(
                      'Juni',
                    ),
                    onSort: (idx, asc) {
                      setState(() {});
                    },
                  ),
                  DataColumn(
                    label: Text(
                      'Juli',
                    ),
                    onSort: (idx, asc) {
                      setState(() {});
                    },
                  ),
                  DataColumn(
                    label: Text(
                      'August',
                    ),
                    onSort: (idx, asc) {
                      setState(() {});
                    },
                  ),
                  DataColumn(
                    label: Text(
                      'September',
                    ),
                    onSort: (idx, asc) {
                      setState(() {});
                    },
                  ),
                  DataColumn(
                    label: Text(
                      'Oktober',
                    ),
                    onSort: (idx, asc) {
                      setState(() {});
                    },
                  ),
                  DataColumn(
                    label: Text(
                      'November',
                    ),
                    onSort: (idx, asc) {
                      setState(() {});
                    },
                  ),
                  DataColumn(
                    label: Text(
                      'Dezember',
                    ),
                    onSort: (idx, asc) {
                      setState(() {});
                    },
                  ),
                  DataColumn(
                    label: Text(
                      'Summe Jahr',
                    ),
                  ),
                ],
                rows: widget.customerForecastData.items
                    .map((forecast) {
                  _controllerList[forecast] = [];
                  _controllerSummary[forecast] = TextEditingController(text: formatter.format(forecast.forecast.entries.map((e) => e.value).reduce((a, b) => a + b)));
                  return DataRow(cells: [
                    DataCell(Container(width: 80, child: Text(forecast.customer))),
                    DataCell(Container(child: Text(forecast.medium))),
                    DataCell(Container(width: 80, child: Text(forecast.brand))),
                    DataCell(Container(
                      height: 170,
                      child: Column(
                        children: [
                          SizedBox(height: 8),
                          Text('Forecast'),
                          Divider(),
                          Text('Goal'),
                          Divider(),
                          Text('IST'),
                          Divider(),
                          Text('IST (VJ)'),
                          Divider(),
                          Text('Delta'),
                          SizedBox(height: 8),
                        ],
                      ),
                    )),
                    ..._month
                        .asMap()
                        .entries
                        .map((entry) {
                      int idx = entry.key;
                      String monthKey = entry.value;
                      _controllerList[forecast].add(TextEditingController(
                          text: formatter.format(forecast.forecast[monthKey])));
                      return DataCell(
                        Container(
                          height: 170,
                          child: Column(
                            children: [
                              TextFormField(
                                readOnly: false,
                                controller: _controllerList[forecast][idx],
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: (idx + 1 >= currentMonth)
                                      ? Colors.blue[50]
                                      : Colors.grey[300],
                                  border: InputBorder.none,
                                  contentPadding:
                                  EdgeInsets.symmetric(vertical: 8),
                                  //Change this value to custom as you like
                                  isDense: true, // and add this line
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                style: TextStyle(fontSize: 14),
                                maxLines: 1,
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Container(
                                  width: double.infinity,
                                  child: Text(formatter.format(forecast.goal[monthKey]))),
                              Divider(),
                              Container(
                                  width: double.infinity,
                                  child: Text(formatter.format(forecast.ist[monthKey]))),
                              Divider(),
                              Container(
                                  width: double.infinity,
                                  child: Text(formatter.format(forecast.goal[monthKey]))),
                              Divider(),
                              Container(
                                  width: double.infinity,
                                  child: Text(monthKey)),
                              SizedBox(height: 4),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                    DataCell(
                      Container(
                        height: 170,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _controllerSummary[forecast],
                              readOnly: false,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.blue[50],
                                border: InputBorder.none,
                                contentPadding:
                                EdgeInsets.symmetric(vertical: 8),
                                //Change this value to custom as you like
                                isDense: true, // and add this line
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              style: TextStyle(fontSize: 14),
                              maxLines: 1,
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Container(
                                width: double.infinity, child: Text('gesamt')),
                            Divider(),
                            Container(
                                width: double.infinity,
                                child: Text('gesamtWert')),
                            Divider(),
                            Container(
                                width: double.infinity,
                                child: Text('gesamtWert')),
                            Divider(),
                            Container(
                                width: double.infinity,
                                child: Text('gesamtWert')),
                            SizedBox(height: 4),
                          ],
                        ),
                      ),
                    )
                  ]);
                })
                    .toList(),
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
