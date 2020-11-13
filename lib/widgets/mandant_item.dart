import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../providers/detail.dart';
import './monthly_chart.dart';

final formatter = new NumberFormat.currency(locale: 'eu', decimalDigits: 0);
final formatterPercent =
    new NumberFormat.decimalPercentPattern(locale: 'de', decimalDigits: 0);

class MandantItem extends StatelessWidget {
  final Detail detailData;

  MandantItem(this.detailData);

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
              child: DataTable(
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
                rows: (detailData.brands != null)
                    ? detailData.brands
                        .map((brand) => DataRow(cells: [
                              DataCell(Text(brand['name'])),
                              DataCell(Text(formatter.format(brand['goal']))),
                              DataCell(Text(
                                  formatter.format(brand['ist_stichtag']))),
                              DataCell(Text(
                                  formatter.format(brand['kunden_forecast']))),
                              DataCell(Text(
                                  formatter.format(brand['projekt_forecast']))),
                              DataCell(Text(formatter.format(
                                  brand['ist_stichtag'] +
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
                                    formatterPercent.format(
                                        (brand['ist_stichtag'] +
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
