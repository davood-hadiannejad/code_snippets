import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../providers/project_forecast.dart';


class ProjectForecastItem extends StatelessWidget {
  final ProjectForecast forecastData;

  ProjectForecastItem(this.forecastData);

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
                'AOB Überblick',
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: 1000,
              child: DataTable(
                columns: const <DataColumn>[
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
                      'Goal (MN3)',
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Offene Projekte (MN3 bewertet)',
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Gebuchte Projekte (MN3)',
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Differenz',
                    ),
                  ),
                ],
                rows: <DataRow>[
                  DataRow(
                    cells: <DataCell>[
                      DataCell(Text('TV')),
                      DataCell(Text('MTV')),
                      DataCell(Text('600.000')),
                      DataCell(Text('500.000')),
                      DataCell(Text('50.000')),
                      DataCell(Text('50.000')),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Projekte',
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            Container(
              width: 1200,
              child: DataTable(
                columns: const <DataColumn>[
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
                rows: <DataRow>[
                  DataRow(
                    cells: <DataCell>[
                      DataCell(Text('Weihnachtskampagne')),
                      DataCell(Text('Volkswagen')),
                      DataCell(Text('TV')),
                      DataCell(Text('MTV')),
                      DataCell(Text('500.000')),
                      DataCell(Text('90')),
                      DataCell(
                        CircularPercentIndicator(
                          radius: 30.0,
                          percent: 1.00,
                          center: Text(
                            "100%",
                            style: TextStyle(fontSize: 8),
                          ),
                          progressColor: Colors.green,
                        ),
                      ),
                      DataCell(Text('offen')),
                    ],
                  ),
                ],
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
