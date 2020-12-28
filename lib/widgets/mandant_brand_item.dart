import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../providers/detail.dart';
import './monthly_chart.dart';
import '../screens/project_forecast_screen.dart';
import '../screens/detail_screen.dart';

final formatter = new NumberFormat.simpleCurrency(locale: 'eu', decimalDigits: 0);
final formatterPercent =
    new NumberFormat.decimalPercentPattern(locale: 'de', decimalDigits: 0);

class MandantBrandItem extends StatelessWidget {
  final Detail detailData;
  final String pageType;

  MandantBrandItem(this.detailData, this.pageType);

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
                  ),
                ),
              ],
            ),
            SizedBox(height: 50),
            Container(
              width: 1200,
              child: (pageType == 'Mandant')
                  ? buildMandantTable(context)
                  : buildCustomerTable(context),
            ),
            Container(
              width: 1200,
              child: (pageType == 'Brand')
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 50),
                      child: buildProjectTable(context),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  DataTable buildMandantTable(context) {
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
              'Kunden-Forecast',
              textAlign: TextAlign.end,
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'Projekt-Forecast',
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
      rows: (detailData.brands != null)
          ? detailData.brands
              .map((brand) => DataRow(
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
                        DataCell(
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(formatter.format(brand['kunden_forecast'])),
                              ],
                            )),
                        DataCell(
                            Row(
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

  DataTable buildCustomerTable(context) {
    return DataTable(
      showCheckboxColumn: false,
      columns: const <DataColumn>[
        DataColumn(
          label: Text(
            'Kunde',
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
              'Kunden-Forecast',
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
      rows: (detailData.customers != null)
          ? detailData.customers
              .map((customer) => DataRow(
                      onSelectChanged: (bool) {
                        Navigator.of(context)
                            .pushNamed(DetailScreen.routeName, arguments: {
                          'pageType': 'Kunde',
                          'id': customer['name_slug'].toString(),
                        });
                      },
                      cells: [
                        DataCell(Text(customer['name'])),
                        DataCell(Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(formatter.format(customer['goal'])),
                          ],
                        )),
                        DataCell(
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(formatter.format(customer['ist_stichtag'])),
                              ],
                            )),
                        DataCell(Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                                formatter.format(customer['kunden_forecast'])),
                          ],
                        )),
                        DataCell(Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(formatter.format(
                                customer['ist_stichtag'] +
                                    customer['kunden_forecast'])),
                          ],
                        )),
                        DataCell(
                          CircularPercentIndicator(
                            radius: 42.0,
                            percent: ((customer['ist_stichtag'] +
                                            customer['kunden_forecast']) /
                                        customer['goal'] >
                                    1)
                                ? 1.0
                                : (customer['ist_stichtag'] +
                                        customer['kunden_forecast']) /
                                    customer['goal'],
                            center: Text(
                              formatterPercent.format(
                                  (customer['ist_stichtag'] +
                                          customer['kunden_forecast']) /
                                      customer['goal']),
                              style: TextStyle(fontSize: 10),
                            ),
                            progressColor: getProgressColor(
                                (customer['ist_stichtag'] +
                                        customer['kunden_forecast']) /
                                    customer['goal']),
                          ),
                        )
                      ]))
              .toList()
          : [],
    );
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
            'Kunde',
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
                      DataCell(Text(project['kunde'])),
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
