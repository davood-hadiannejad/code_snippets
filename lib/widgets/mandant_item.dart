import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../providers/detail.dart';
import './monthly_chart.dart';


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
                      child: MonthlyChart.withSampleData()),
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
                  rows: <DataRow>[
                    DataRow(
                      cells: <DataCell>[
                        DataCell(Text('Nick')),
                        DataCell(Text('19.000')),
                        DataCell(Text('19.000')),
                        DataCell(Text('19.000')),
                        DataCell(Text('19.000')),
                        DataCell(Text('22.000')),
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
                        )
                      ],
                    ),
                    DataRow(
                      cells: <DataCell>[
                        DataCell(Text('Nick')),
                        DataCell(Text('19.000')),
                        DataCell(Text('19.000')),
                        DataCell(Text('19.000')),
                        DataCell(Text('19.000')),
                        DataCell(Text('22.000')),
                        DataCell(
                          CircularPercentIndicator(
                            radius: 33.0,
                            percent: 0.10,
                            center: Text(
                              "10%",
                              style: TextStyle(fontSize: 8),
                            ),
                            progressColor: Colors.red,
                          ),
                        )
                      ],
                    ),
                    DataRow(
                      cells: <DataCell>[
                        DataCell(Text('Nick')),
                        DataCell(Text('19.000')),
                        DataCell(Text('19.000')),
                        DataCell(Text('19.000')),
                        DataCell(Text('19.000')),
                        DataCell(Text('22.000')),
                        DataCell(CircularPercentIndicator(
                          radius: 33.0,
                          percent: 0.78,
                          center: Text(
                            "78%",
                            style: TextStyle(fontSize: 8),
                          ),
                          progressColor: Colors.yellow,
                        )),
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
