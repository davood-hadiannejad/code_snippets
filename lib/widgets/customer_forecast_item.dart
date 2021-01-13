import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';

import '../providers/customer_forecast_list.dart';
import '../providers/customer_forecast.dart';
import '../providers/verkaeufer_list.dart';
import '../providers/verkaeufer.dart';

final formatter =
    new NumberFormat.simpleCurrency(locale: 'eu', decimalDigits: 0);
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
int currentYear = 2020;
int lastYear = currentYear - 1;

int currentMonth = DateTime.now().month;

class _CustomerForecastItemState extends State<CustomerForecastItem> {
  final ScrollController _scrollController = ScrollController();
  Verkaeufer selectedVerkaufer;
  Map<CustomerForecast, List<TextEditingController>> _controllerList = {};
  Map<CustomerForecast, TextEditingController> _controllerSummary = {};
  int maxPages;
  int currentPage;
  String dialogDropdownValue = 'Gesamtjahresumme';

  @override
  void initState() {
    maxPages = widget.customerForecastData.maxPages;
    currentPage = widget.customerForecastData.currentPage;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    selectedVerkaufer = Provider.of<VerkaeuferList>(context).selectedVerkaufer;

    void updateForecast(
        forecast, gesamtSumme, activeMonth, countActiveMonth, sumLastYear,
        {updateKind = 'gleich'}) {
      if (dialogDropdownValue == 'Gesamtjahresumme') {
        // gesamtForecast - istGesamt
        gesamtSumme = gesamtSumme -
            forecast.ist.entries.map((e) => e.value).reduce((a, b) => a + b);
      }

      if (updateKind == 'gleich') {
        activeMonth.forEach((monthKey) {
          forecast.forecast[monthKey] = (gesamtSumme / countActiveMonth);
        });
      } else {
        activeMonth.forEach((monthKey) {
          num montlyAmount =
              (gesamtSumme * forecast.istLastYear[monthKey] / sumLastYear);
          forecast.forecast[monthKey] = montlyAmount;
        });
      }

      Provider.of<CustomerForecastList>(context, listen: false)
          .addCustomerForecast(
        forecast.customer,
        forecast.medium,
        forecast.brand,
        forecast.agentur,
        currentYear,
        selectedVerkaufer.email,
        forecast.forecast,
      );
      Navigator.of(context).pop();
      setState(() {
        forecast = forecast;
      });
    }

    Future<void> _showGesamtDialog(
        num gesamtSumme, CustomerForecast forecast) async {
      List<String> activeMonth = _month.sublist(currentMonth - 1);
      int countActiveMonth = activeMonth.length;
      num sumLastYear = activeMonth
          .map((monthKey) {
            return forecast.istLastYear[monthKey];
          })
          .toList()
          .reduce((a, b) => a + b);
      return showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Wie soll die Gesamtsumme verteilt werden?'),
              content: Row(
                children: [
                  Text(formatter.format(gesamtSumme) + ' verteilen als '),
                  StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                    return Container(
                      width: 158,
                      height: 50,
                      child: DropdownButton(
                          value: dialogDropdownValue,
                          items: [
                            DropdownMenuItem(
                              child: Text('Restjahressumme'),
                              value: 'Restjahressumme',
                            ),
                            DropdownMenuItem(
                              child: Text('Gesamtjahresumme'),
                              value: 'Gesamtjahresumme',
                            ),
                          ],
                          onChanged: (String newValue) {
                            if (this.mounted) {
                              setState(
                                () {
                                  dialogDropdownValue = newValue;
                                },
                              );
                            }
                          }),
                    );
                  })
                ],
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('Gleichverteilt'),
                  onPressed: () {
                    updateForecast(forecast, gesamtSumme, activeMonth,
                        countActiveMonth, sumLastYear,
                        updateKind: 'gleich');
                  },
                ),
                FlatButton(
                  child: Text('Wie Vorjahr'),
                  onPressed: (sumLastYear > 0)
                      ? () {
                          updateForecast(forecast, gesamtSumme, activeMonth,
                              countActiveMonth, sumLastYear,
                              updateKind: 'vorjahr');
                        }
                      : null,
                ),
                FlatButton(
                  child: Text('Abbrechen'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
    }

    return Card(
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
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  FlatButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                      widget.customerForecastData.resetItems();
                    },
                    label: Text('Zurück'),
                    icon: Icon(Icons.arrow_back_ios),
                  ),
                ],
              ),
              SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Kundenforecast',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                  FlatButton.icon(
                      onPressed: () {
                        Provider.of<CustomerForecastList>(context,
                                listen: false)
                            .fetchAndSetCustomerForecastList(
                                verkaeufer: selectedVerkaufer, refresh: true);
                      },
                      icon: Icon(Icons.refresh),
                      label: Text('Refresh'))
                ],
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 1,
                    ),
                    Row(
                      children: List<Container>.generate(
                        maxPages,
                        (i) => Container(
                          width: 25,
                          height: 25,
                          child: FlatButton(
                            color: ((i + 1) == currentPage)
                                ? Theme.of(context).accentColor
                                : null,
                            padding: EdgeInsets.all(1.0),
                            child: Text((i + 1).toString(),
                                style: TextStyle(
                                  fontSize: 8,
                                )),
                            onPressed: () {
                              Provider.of<CustomerForecastList>(context,
                                      listen: false)
                                  .changePage(i + 1);
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 1,
                    ),
                  ],
                ),
              ),
              Container(
                width: 1400,
                child: DataTable(
                  showBottomBorder: true,
                  dataRowHeight: 170,
                  columnSpacing: 0,
                  sortColumnIndex: widget.customerForecastData.sortColumnIndex,
                  sortAscending: widget.customerForecastData.sortAscending,
                  columns: <DataColumn>[
                    DataColumn(
                      label: Center(
                        child: Text(
                          'Kunde',
                        ),
                      ),
                      onSort: (idx, asc) {
                        widget.customerForecastData
                            .sortByField('kunde', idx, ascending: asc);
                      },
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
                      label: Expanded(
                        child: Text(
                          'Januar',
                          textAlign: TextAlign.end,
                        ),
                      ),
                      onSort: (idx, asc) {
                        widget.customerForecastData
                            .sortByField('m1', idx, ascending: asc);
                      },
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Februar',
                          textAlign: TextAlign.end,
                        ),
                      ),
                      onSort: (idx, asc) {
                        widget.customerForecastData
                            .sortByField('m2', idx, ascending: asc);
                      },
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'März',
                          textAlign: TextAlign.end,
                        ),
                      ),
                      onSort: (idx, asc) {
                        widget.customerForecastData
                            .sortByField('m3', idx, ascending: asc);
                      },
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'April',
                          textAlign: TextAlign.end,
                        ),
                      ),
                      onSort: (idx, asc) {
                        widget.customerForecastData
                            .sortByField('m4', idx, ascending: asc);
                      },
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Mai',
                          textAlign: TextAlign.end,
                        ),
                      ),
                      onSort: (idx, asc) {
                        widget.customerForecastData
                            .sortByField('m5', idx, ascending: asc);
                      },
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Juni',
                          textAlign: TextAlign.end,
                        ),
                      ),
                      onSort: (idx, asc) {
                        widget.customerForecastData
                            .sortByField('m6', idx, ascending: asc);
                      },
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Juli',
                          textAlign: TextAlign.end,
                        ),
                      ),
                      onSort: (idx, asc) {
                        widget.customerForecastData
                            .sortByField('m7', idx, ascending: asc);
                      },
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'August',
                          textAlign: TextAlign.end,
                        ),
                      ),
                      onSort: (idx, asc) {
                        widget.customerForecastData
                            .sortByField('m8', idx, ascending: asc);
                      },
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'September',
                          textAlign: TextAlign.end,
                        ),
                      ),
                      onSort: (idx, asc) {
                        widget.customerForecastData
                            .sortByField('m9', idx, ascending: asc);
                      },
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Oktober',
                          textAlign: TextAlign.end,
                        ),
                      ),
                      onSort: (idx, asc) {
                        widget.customerForecastData
                            .sortByField('m10', idx, ascending: asc);
                      },
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'November',
                          textAlign: TextAlign.end,
                        ),
                      ),
                      onSort: (idx, asc) {
                        widget.customerForecastData
                            .sortByField('m11', idx, ascending: asc);
                      },
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Dezember',
                          textAlign: TextAlign.end,
                        ),
                      ),
                      onSort: (idx, asc) {
                        widget.customerForecastData
                            .sortByField('m12', idx, ascending: asc);
                      },
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Summe Jahr',
                          textAlign: TextAlign.end,
                        ),
                      ),
                      onSort: (idx, asc) {
                        widget.customerForecastData
                            .sortByField('gesamt', idx, ascending: asc);
                      },
                    ),
                  ],
                  rows: widget.customerForecastData.items.map((forecast) {
                    _controllerList[forecast] = [];
                    _controllerSummary[forecast] = TextEditingController(
                        text:
                            formatter.format(forecast.forecast.entries.map((e) {
                      return e.value;
                    }).reduce((a, b) => a + b)));
                    return DataRow(cells: [
                      DataCell(Container(
                          width: 80,
                          child: Tooltip(
                            child: Text(forecast.customer),
                            message: forecast.agentur,
                          ))),
                      DataCell(Container(child: Text(forecast.medium))),
                      DataCell(
                          Container(width: 80, child: Text(forecast.brand))),
                      DataCell(Container(
                        height: 170,
                        child: Column(
                          children: [
                            SizedBox(height: 7),
                            Text('Forecast'),
                            Container(
                                alignment: Alignment.center,
                                width: double.infinity,
                                margin: EdgeInsets.symmetric(vertical: 8),
                                height: 1,
                                color: Colors.grey[300]
                            ),
                            Text('Goal'),
                            Container(
                                alignment: Alignment.center,
                                width: double.infinity,
                                margin: EdgeInsets.symmetric(vertical: 8),
                                height: 1,
                                color: Colors.grey[300]
                            ),
                            Text('IST'),
                            Container(
                                alignment: Alignment.center,
                                width: double.infinity,
                                margin: EdgeInsets.symmetric(vertical: 8),
                                height: 1,
                                color: Colors.grey[300]
                            ),
                            Text('IST (VJ)'),
                            Container(
                                alignment: Alignment.center,
                                width: double.infinity,
                                margin: EdgeInsets.symmetric(vertical: 8),
                                height: 1,
                                color: Colors.grey[300]
                            ),
                            Tooltip(
                              child: Text('Delta'),
                              message: 'Δ FC+IST zu Goal',
                            ),
                            SizedBox(height: 8),
                          ],
                        ),
                      )),
                      ..._month.asMap().entries.map((entry) {
                        int idx = entry.key;
                        String monthKey = entry.value;
                        _controllerList[forecast].add(TextEditingController(
                            text:
                                formatter.format(forecast.forecast[monthKey])));
                        return DataCell(
                          Container(
                            height: 170,
                            child: Column(
                              children: [
                                TextFormField(
                                  textAlign: TextAlign.end,
                                  readOnly: !(idx + 1 >= currentMonth),
                                  controller: _controllerList[forecast][idx],
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: (idx + 1 >= currentMonth)
                                        ? Colors.blue[50]
                                        : Colors.grey[300],
                                    border: InputBorder.none,
                                    contentPadding:
                                        EdgeInsets.symmetric(vertical: 12),
                                    //Change this value to custom as you like
                                    isDense: true, // and add this line
                                  ),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  style: TextStyle(fontSize: 14),
                                  maxLines: 1,
                                  onEditingComplete: () {
                                    FocusScope.of(context).unfocus();
                                    forecast.forecast[monthKey] = num.parse(
                                        _controllerList[forecast][idx].text);
                                    Provider.of<CustomerForecastList>(context,
                                            listen: false)
                                        .addCustomerForecast(
                                      forecast.customer,
                                      forecast.medium,
                                      forecast.brand,
                                      forecast.agentur,
                                      currentYear,
                                      selectedVerkaufer.email,
                                      forecast.forecast,
                                    );
                                  },
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Container(
                                    width: double.infinity,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(formatter
                                            .format(forecast.goal[monthKey])),
                                      ],
                                    )),
                                Container(
                                    alignment: Alignment.center,
                                    width: double.infinity,
                                    margin: EdgeInsets.symmetric(vertical: 8),
                                    height: 1,
                                    color: Colors.grey[300]
                                ),
                                Container(
                                    width: double.infinity,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(formatter
                                            .format(forecast.ist[monthKey])),
                                      ],
                                    )),
                                Container(
                                    alignment: Alignment.center,
                                    width: double.infinity,
                                    margin: EdgeInsets.symmetric(vertical: 8),
                                    height: 1,
                                    color: Colors.grey[300]
                                ),
                                Container(
                                    width: double.infinity,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(formatter.format(
                                            forecast.istLastYear[monthKey])),
                                      ],
                                    )),
                                Container(
                                    alignment: Alignment.center,
                                    width: double.infinity,
                                    margin: EdgeInsets.symmetric(vertical: 8),
                                    height: 1,
                                    color: Colors.grey[300]
                                ),
                                Container(
                                    width: double.infinity,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(formatter.format(
                                            forecast.forecast[monthKey] +
                                                forecast.ist[monthKey] -
                                                forecast.goal[monthKey])),
                                      ],
                                    )),
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
                                textAlign: TextAlign.end,
                                controller: _controllerSummary[forecast],
                                readOnly: false,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.blue[50],
                                  border: InputBorder.none,
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 12),
                                  //Change this value to custom as you like
                                  isDense: true, // and add this line
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                style: TextStyle(fontSize: 14),
                                onEditingComplete: () {
                                  FocusScope.of(context).unfocus();
                                  _showGesamtDialog(
                                      num.parse(
                                          _controllerSummary[forecast].text),
                                      forecast);
                                },
                                maxLines: 1,
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Container(
                                  width: double.infinity,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(formatter.format(forecast
                                          .goal.entries
                                          .map((e) => e.value)
                                          .reduce((a, b) => a + b))),
                                    ],
                                  )),
                              Container(
                                  alignment: Alignment.center,
                                  width: double.infinity,
                                  margin: EdgeInsets.symmetric(vertical: 8),
                                  height: 1,
                                  color: Colors.grey[300]
                              ),
                              Container(
                                  width: double.infinity,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(formatter.format(forecast.ist.entries
                                          .map((e) => e.value)
                                          .reduce((a, b) => a + b))),
                                    ],
                                  )),
                              Container(
                                  alignment: Alignment.center,
                                  width: double.infinity,
                                  margin: EdgeInsets.symmetric(vertical: 8),
                                  height: 1,
                                  color: Colors.grey[300]
                              ),
                              Container(
                                  width: double.infinity,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(formatter.format(forecast
                                          .istLastYear.entries
                                          .map((e) => e.value)
                                          .reduce((a, b) => a + b))),
                                    ],
                                  )),
                              Container(
                                  alignment: Alignment.center,
                                  width: double.infinity,
                                  margin: EdgeInsets.symmetric(vertical: 8),
                                  height: 1,
                                  color: Colors.grey[300]
                              ),
                              Container(
                                  width: double.infinity,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(formatter.format(forecast
                                              .forecast.entries
                                              .map((e) => e.value)
                                              .reduce((a, b) => a + b) +
                                          forecast.ist.entries
                                              .map((e) => e.value)
                                              .reduce((a, b) => a + b) -
                                          forecast.goal.entries
                                              .map((e) => e.value)
                                              .reduce((a, b) => a + b))),
                                    ],
                                  )),
                              SizedBox(height: 4),
                            ],
                          ),
                        ),
                      )
                    ]);
                  }).toList(),
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
