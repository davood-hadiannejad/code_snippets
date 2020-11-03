import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../providers/detail.dart';
import './monthly_chart.dart';


class ProjectForecastItem extends StatelessWidget {

  final Detail forecastData;

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
                      Navigator.of(context).pushReplacementNamed('/');
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

              SizedBox(height: 50),
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
