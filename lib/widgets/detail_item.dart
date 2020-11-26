import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../providers/detail.dart';
import './monthly_chart.dart';
import '../screens/project_forecast_screen.dart';


final formatter = new NumberFormat.currency(locale: 'eu', decimalDigits: 0);
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    detailData.name,
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
                      width: 300,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Cash Rabatt: ',
                                    style:
                                        Theme.of(context).textTheme.headline5,
                                  ),
                                  Text(
                                    formatterPercent.format(.25),
                                    style:
                                        Theme.of(context).textTheme.headline5,
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Natural Rabatt: ',
                                    style:
                                        Theme.of(context).textTheme.headline5,
                                  ),
                                  Text(
                                    formatterPercent.format(.25),
                                    style:
                                        Theme.of(context).textTheme.headline5,
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Global Rabatt: ',
                                    style:
                                        Theme.of(context).textTheme.headline5,
                                  ),
                                  Text(
                                    formatterPercent.format(.25),
                                    style:
                                        Theme.of(context).textTheme.headline5,
                                  )
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
        Card(
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    detailData.name,
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
                Container(
                  width: 1200,
                  child: buildCustomerTable(context),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  DataTable buildDetailTable() {
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
      rows: (detailData.tv != null)
          ? detailData.tv
              .map((brand) => DataRow(cells: [
                    DataCell(Text(brand['name'])),
                    DataCell(Text(formatter.format(brand['goal']))),
                    DataCell(Text(formatter.format(brand['ist_stichtag']))),
                    DataCell(Text(formatter.format(brand['kunden_forecast']))),
                    DataCell(Text(formatter.format(brand['projekt_forecast']))),
                    DataCell(Text(formatter.format(brand['ist_stichtag'] +
                        brand['projekt_forecast'] +
                        brand['kunden_forecast']))),
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
                        progressColor: getProgressColor((brand['ist_stichtag'] +
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

  DataTable buildCustomerTable(context) {
    return DataTable(columnSpacing: 0, columns: const <DataColumn>[
      DataColumn(
        label: Text(
          '',
        ),
      ),
      DataColumn(
          label: Center(
        child: Text(
          'Januar',
        ),
      )),
      DataColumn(
          label: Text(
        'Februar',
      )),
      DataColumn(
          label: Text(
        'März',
      )),
      DataColumn(
          label: Text(
        'April',
      )),
      DataColumn(
          label: Text(
        'Mai',
      )),
      DataColumn(
          label: Text(
        'Juni',
      )),
      DataColumn(
          label: Text(
        'Juli',
      )),
      DataColumn(
          label: Text(
        'August',
      )),
      DataColumn(
          label: Text(
        'September',
      )),
      DataColumn(
          label: Text(
        'Oktober',
      )),
      DataColumn(
          label: Text(
        'November',
      )),
      DataColumn(
          label: Text(
        'Dezember',
      )),
      DataColumn(
        label: Text(
          'Summe Jahr',
        ),
      ),
    ], rows: [
      DataRow(
        cells: [
          DataCell(Text('Goal')),
          ..._month
              .map((month) => DataCell(
                  Text(formatter.format(detailData.goalGesamt[month]))))
              .toList(),
          DataCell(Text(formatter.format(_month
              .map((month) => detailData.goalGesamt[month])
              .toList()
              .reduce((a, b) => a + b))))
        ],
      ),
      DataRow(
        cells: [
          DataCell(Text('IST')),
          ..._month
              .map((month) => DataCell(
                  Text(formatter.format(detailData.istStichtagGesamt[month]))))
              .toList(),
          DataCell(Text(formatter.format(_month
              .map((month) => detailData.istStichtagGesamt[month])
              .toList()
              .reduce((a, b) => a + b))))
        ],
      ),
      DataRow(
        cells: [
          DataCell(Text('Kunden Forecast')),
          ..._month
              .map((month) => DataCell(Text(
                  formatter.format(detailData.kundenForecastGesamt[month]))))
              .toList(),
          DataCell(Text(formatter.format(_month
              .map((month) => detailData.kundenForecastGesamt[month])
              .toList()
              .reduce((a, b) => a + b))))
        ],
      ),
      DataRow(
        cells: [
          DataCell(Text('IST + Forecast')),
          ..._month
              .map((month) => DataCell(Text(formatter.format(
                  detailData.kundenForecastGesamt[month] +
                      detailData.istStichtagGesamt[month]))))
              .toList(),
          DataCell(Text(formatter.format(_month
              .map((month) =>
                  detailData.kundenForecastGesamt[month] +
                  detailData.istStichtagGesamt[month])
              .toList()
              .reduce((a, b) => a + b))))
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
          label: Text(
            'MN3 bewertet',
          ),
        ),
        DataColumn(
          label: Text(
            'Bewertung',
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
                        child: Text(formatter.format(
                            project['mn3'] * project['bewertung'] / 100)),
                      )),
                      DataCell(Text(project['bewertung'].toString() + '%')),
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