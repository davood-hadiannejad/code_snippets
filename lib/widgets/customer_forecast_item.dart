import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import '../providers/customer_forecast_list.dart';
import '../providers/customer_forecast.dart';
import '../providers/verkaeufer_list.dart';
import '../providers/verkaeufer.dart';
import '../providers/year.dart';

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

int currentMonth = DateTime.now().month;

class _CustomerForecastItemState extends State<CustomerForecastItem> {
  final ScrollController _scrollController = ScrollController();
  Verkaeufer selectedVerkaufer;

  Map<CustomerForecast, List<FocusNode>> _focusNodeList = {};
  Map<CustomerForecast, FocusNode> _focusNodeSummary = {};

  DataTableSource _data;

  @override
  void dispose() {
    _focusNodeSummary.forEach((CustomerForecast forecast, FocusNode focusNode) {
      focusNode.dispose();
    });
    _focusNodeList.forEach((CustomerForecast forecast, List focusNodeList) {
      focusNodeList.asMap().forEach((index, focusNode) {
        focusNode.dispose();
      });
    });
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // addCellListener();
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   print("'''''''''''''''''''''changed'''''''''''''''''''''");
  //   selectedVerkaufer = Provider.of<VerkaeuferList>(context).selectedVerkaufer;
  //   int selectedYear = num.parse(Provider.of<Year>(context).selectedYear);
  //   _data = Data(
  //       customerForecast: widget.customerForecastData,
  //       selectedYear: selectedYear,
  //       selectedVerkaufer: selectedVerkaufer,
  //       context: context);
  // }

  @override
  Widget build(BuildContext context) {
    selectedVerkaufer = Provider.of<VerkaeuferList>(context).selectedVerkaufer;
    int selectedYear = num.parse(Provider.of<Year>(context).selectedYear);
    _data = Data(
        customerForecast: widget.customerForecastData,
        selectedYear: selectedYear,
        selectedVerkaufer: selectedVerkaufer,
        context: context);
    return Card(
      margin: EdgeInsets.all(12.0),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        width: double.infinity,
        height: double.infinity,
        alignment: Alignment.center,
        child: DraggableScrollbar.rrect(
          alwaysVisibleScrollThumb: true,
          controller: _scrollController,
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextButton.icon(
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
                  TextButton.icon(
                    onPressed: () {
                      Provider.of<CustomerForecastList>(context, listen: false)
                          .fetchAndSetCustomerForecastList(
                              verkaeufer: selectedVerkaufer, refresh: true);
                    },
                    icon: Icon(Icons.refresh),
                    label: Text('Refresh'),
                  ),
                ],
              ),
              Container(
                child: PaginatedDataTable(
                  columnSpacing: 5,
                  dataRowHeight: 170,
                  rowsPerPage: 3,
                  sortColumnIndex: widget.customerForecastData.sortColumnIndex,
                  sortAscending: widget.customerForecastData.sortAscending,
                  columns: [
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
                  source: _data,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Data extends DataTableSource {
  final CustomerForecastList customerForecast;
  final int selectedYear;
  final Verkaeufer selectedVerkaufer;
  final BuildContext context;
  Data(
      {@required this.customerForecast,
      @required this.selectedYear,
      this.selectedVerkaufer,
      @required this.context});

  Map<CustomerForecast, List<TextEditingController>> _controllerList = {};
  Map<CustomerForecast, List<FocusNode>> _focusNodeList = {};
  Map<CustomerForecast, TextEditingController> _controllerSummary = {};
  Map<CustomerForecast, FocusNode> _focusNodeSummary = {};
  int currentYear = DateTime.now().year;

  String dialogDropdownValue = 'Gesamtjahresumme';

  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => customerForecast.items.length;
  @override
  int get selectedRowCount => 0;

  bool get mounted => null;

  DataRow getRow(int index) {
    final forecast = customerForecast.items[index];
    _controllerList[forecast] = [];
    _focusNodeList[forecast] = [];
    _focusNodeSummary[forecast] = FocusNode();
    _controllerSummary[forecast] = TextEditingController(
      text: formatter.format(
        forecast.forecast.entries.map((e) {
          return e.value;
        }).reduce((a, b) => a + b),
      ),
    );

    return DataRow(
      cells: [
        DataCell(
          Container(
            child: Tooltip(
              child: Text(forecast.customer),
              message: forecast.agentur,
            ),
          ),
        ),
        DataCell(
          Container(
            child: Text(forecast.medium),
          ),
        ),
        DataCell(
          Container(
            child: Text((forecast.brand)),
          ),
        ),
        DataCell(
          Container(
            alignment: Alignment.center,
            width: double.infinity,
            height: double.infinity,
            child: Column(
              children: [
                SizedBox(height: 7),
                Text('Forecast'),
                Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  height: 1,
                  color: Colors.grey[300],
                ),
                Text('Goal'),
                Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  height: 1,
                  color: Colors.grey[300],
                ),
                Text('IST'),
                Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  height: 1,
                  color: Colors.grey[300],
                ),
                Text('IST (VJ)'),
                Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  height: 1,
                  color: Colors.grey[300],
                ),
                Tooltip(
                  child: Text('Delta'),
                  message: 'Δ FC+IST zu Goal',
                ),
                SizedBox(height: 8),
              ],
            ),
          ),
        ),
        ..._month.asMap().entries.map((entry) {
          int idx = entry.key;
          String monthKey = entry.value;
          _focusNodeList[forecast].add(FocusNode());
          _controllerList[forecast].add(
            TextEditingController(
              text: formatter.format(forecast.forecast[monthKey]),
            ),
          );
          return DataCell(
            Container(
              height: 170,
              child: Column(
                children: [
                  TextFormField(
                    textAlign: TextAlign.end,
                    readOnly: (currentYear == selectedYear)
                        ? !(idx + 1 >= currentMonth &&
                            !selectedVerkaufer.isGroup)
                        : (selectedYear > currentYear)
                            ? selectedVerkaufer.isGroup
                            : true,
                    controller: _controllerList[forecast][idx],
                    // focusNode: _focusNodeList[forecast][idx],
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: (currentYear == selectedYear)
                          ? (idx + 1 >= currentMonth)
                              ? Colors.blue[50]
                              : Colors.grey[300]
                          : (selectedYear > currentYear)
                              ? Colors.blue[50]
                              : Colors.grey[300],
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 12),
                      //Change this value to custom as you like
                      isDense: true, // and add this line
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    style: TextStyle(fontSize: 14),
                    maxLines: 1,
                    onEditingComplete: () {
                      FocusScope.of(context).unfocus();
                      String textInput = _controllerList[forecast][idx].text;
                      textInput =
                          textInput.replaceAll('€', '').replaceAll('.', '');
                      forecast.forecast[monthKey] = num.parse(textInput);
                      Provider.of<CustomerForecastList>(context, listen: false)
                          .addCustomerForecast(
                        forecast.customer,
                        forecast.medium,
                        forecast.brand,
                        forecast.agentur,
                        selectedYear,
                        selectedVerkaufer.email,
                        forecast.forecast,
                      );
                      _controllerList[forecast][idx].text =
                          formatter.format(forecast.forecast[monthKey]);
                      _controllerSummary[forecast].text =
                          formatter.format(forecast.forecast.entries.map((e) {
                        return e.value;
                      }).reduce((a, b) => a + b));
                      if (monthKey != 'm12') {
                        FocusScope.of(context)
                            .requestFocus(_focusNodeList[forecast][idx + 1]);
                      } else {
                        FocusScope.of(context).requestFocus(
                            _focusNodeList[forecast][currentMonth - 1]);
                      }

                      addCellListener();
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
                          Text(formatter.format(forecast.goal[monthKey])),
                        ],
                      )),
                  Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(vertical: 8),
                      height: 1,
                      color: Colors.grey[300]),
                  Container(
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(formatter.format(forecast.ist[monthKey])),
                        ],
                      )),
                  Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(vertical: 8),
                      height: 1,
                      color: Colors.grey[300]),
                  Container(
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                              formatter.format(forecast.istLastYear[monthKey])),
                        ],
                      )),
                  Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(vertical: 8),
                      height: 1,
                      color: Colors.grey[300]),
                  Container(
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(formatter.format(forecast.forecast[monthKey] +
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
            child: Column(
              children: [
                TextFormField(
                  textAlign: TextAlign.end,
                  controller: _controllerSummary[forecast],
                  focusNode: _focusNodeSummary[forecast],
                  readOnly: (selectedYear >= currentYear)
                      ? selectedVerkaufer.isGroup
                      : true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: (selectedYear >= currentYear)
                        ? Colors.blue[50]
                        : Colors.grey[300],
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                    //Change this value to custom as you like
                    isDense: true, // and add this line
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  style: TextStyle(fontSize: 14),
                  onEditingComplete: () {
                    FocusScope.of(context).unfocus();
                    print("pressed");
                    _showGesamtDialog(
                            num.parse(_controllerSummary[forecast].text),
                            forecast)
                        .then(
                            (value) => {notifyListeners(), print("finished")});
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
                      Text(
                        formatter.format(
                          forecast.goal.entries
                              .map((e) => e.value)
                              .reduce((a, b) => a + b),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  height: 1,
                  color: Colors.grey[300],
                ),
                Container(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          formatter.format(
                            forecast.ist.entries
                                .map((e) => e.value)
                                .reduce((a, b) => a + b),
                          ),
                        ),
                      ],
                    )),
                Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  height: 1,
                  color: Colors.grey[300],
                ),
                Container(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        formatter.format(
                          forecast.istLastYear.entries
                              .map((e) => e.value)
                              .reduce((a, b) => a + b),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  height: 1,
                  color: Colors.grey[300],
                ),
                Container(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        formatter.format(
                          forecast.forecast.entries
                                  .map((e) => e.value)
                                  .reduce((a, b) => a + b) +
                              forecast.ist.entries
                                  .map((e) => e.value)
                                  .reduce((a, b) => a + b) -
                              forecast.goal.entries
                                  .map((e) => e.value)
                                  .reduce((a, b) => a + b),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 4),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void addCellListener() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        _focusNodeList.forEach(
          (CustomerForecast forecast, List focusNodeList) {
            focusNodeList.asMap().forEach(
              (index, focusNode) {
                focusNode.addListener(
                  () {
                    if (focusNode.hasFocus) {
                      _controllerList[forecast][index].selection =
                          TextSelection(
                              baseOffset: 0,
                              extentOffset:
                                  _controllerList[forecast][index].text.length);
                    }
                  },
                );
              },
            );
          },
        );
        _focusNodeSummary.forEach(
          (CustomerForecast forecast, FocusNode focusNode) {
            focusNode.addListener(
              () {
                if (focusNode.hasFocus) {
                  _controllerSummary[forecast].selection = TextSelection(
                      baseOffset: 0,
                      extentOffset: _controllerSummary[forecast].text.length);
                }
              },
            );
          },
        );
        notifyListeners();
      },
    );
  }

  CustomerForecast updateForecast(
      forecast, gesamtSumme, activeMonth, countActiveMonth, sumLastYear,
      {updateKind = 'gleich'}) {
    if (dialogDropdownValue == 'Gesamtjahresumme') {
      // gesamtForecast - istGesamt
      gesamtSumme = gesamtSumme -
          forecast.ist.entries.map((e) => e.value).reduce((a, b) => a + b);
    }

    if (updateKind == 'gleich') {
      activeMonth.forEach(
        (monthKey) {
          forecast.forecast[monthKey] = (gesamtSumme / countActiveMonth);
        },
      );
    } else {
      activeMonth.forEach(
        (monthKey) {
          num montlyAmount =
              (gesamtSumme * forecast.istLastYear[monthKey] / sumLastYear);
          forecast.forecast[monthKey] = montlyAmount;
        },
      );
    }

    Provider.of<CustomerForecastList>(context, listen: false)
        .addCustomerForecast(
      forecast.customer,
      forecast.medium,
      forecast.brand,
      forecast.agentur,
      selectedYear,
      selectedVerkaufer.email,
      forecast.forecast,
    );
    Navigator.of(context).pop();
    print("updateforecast");
    return forecast;
    // setState(() {

    // forecast = forecast;
    // });
  }

  Future<void> _showGesamtDialog(
      num gesamtSumme, CustomerForecast forecast) async {
    num sumLastYear;
    int countActiveMonth;
    List<String> activeMonth;

    if (currentMonth == 12) {
      activeMonth = ['m12'];
      sumLastYear = forecast.istLastYear['m12'];
      countActiveMonth = 1;
    } else {
      activeMonth = _month.sublist(currentMonth);
      countActiveMonth = activeMonth.length;
      sumLastYear = activeMonth
          .map((monthKey) {
            return forecast.istLastYear[monthKey];
          })
          .toList()
          .reduce((a, b) => a + b);
    }
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('Wie soll die Gesamtsumme verteilt werden?'),
              content: Row(
                children: [
                  Text(formatter.format(gesamtSumme) + ' verteilen als '),
                  Container(
                    width: 158,
                    height: 50,
                    child: DropdownButton<dynamic>(
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
                      onChanged: (dynamic newValue) {
                        if (this.mounted) {
                          setState(
                            () {
                              dialogDropdownValue = newValue;
                            },
                          );
                        }
                      },
                    ),
                  )
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Gleichverteilt'),
                  onPressed: () async {
                    forecast = updateForecast(forecast, gesamtSumme,
                        activeMonth, countActiveMonth, sumLastYear,
                        updateKind: 'gleich');
                    setState(() {
                      forecast = forecast;
                    });
                  },
                ),
                TextButton(
                  child: Text('Wie Vorjahr'),
                  onPressed: (sumLastYear > 0)
                      ? () {
                          var forcast = updateForecast(forecast, gesamtSumme,
                              activeMonth, countActiveMonth, sumLastYear,
                              updateKind: 'vorjahr');
                          setState(() {
                            forecast = forcast;
                          });
                        }
                      : null,
                ),
                TextButton(
                  child: Text('Abbrechen'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
