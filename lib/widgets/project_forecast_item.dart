import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../providers/project_list.dart';
import './project_forecast_dialog.dart';

class ProjectForecastItem extends StatefulWidget {
  final ProjectList forecastData;

  ProjectForecastItem(this.forecastData);

  @override
  _ProjectForecastItemState createState() => _ProjectForecastItemState();
}

class _ProjectForecastItemState extends State<ProjectForecastItem> {
  int columnSort;
  bool ascSort = false;

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
                sortColumnIndex: columnSort,
                sortAscending: ascSort,
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
                    label: Text(
                      'MN3 bewertet',
                    ),
                    onSort: (idx, asc) {
                      setState(() {
                        columnSort = idx;
                        ascSort = asc;
                        widget.forecastData
                            .sortByField('mb3_bewertet', ascending: asc);
                      });
                    },
                  ),
                  DataColumn(
                    label: Text(
                      'Bewertung',
                    ),
                    onSort: (idx, asc) {
                      setState(() {
                        columnSort = idx;
                        ascSort = asc;
                        widget.forecastData
                            .sortByField('bewertung', ascending: asc);
                      });
                    },
                  ),
                  DataColumn(
                    label: Text(
                      'Due Date',
                    ),
                    onSort: (idx, asc) {
                      setState(() {
                        columnSort = idx;
                        ascSort = asc;
                        widget.forecastData
                            .sortByField('dueDate', ascending: asc);
                      });
                    },
                  ),
                  DataColumn(
                    label: Text(
                      'Status',
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      '',
                    ),
                  ),
                ],
                rows: widget.forecastData.items
                    .map((project) => DataRow(
                          cells: <DataCell>[
                            DataCell((project.comment != null && project.comment != '')
                                ? Tooltip(
                                    message: project.comment,
                                    waitDuration: Duration(microseconds: 300),
                                    child: Text(project.name))
                                : Text(project.name)),
                            DataCell(Text(project.customer)),
                            DataCell(Text(project.medium)),
                            DataCell(Text(project.brand)),
                            DataCell(Text(
                                (project.mn3 * project.bewertung / 100)
                                    .toString())),
                            DataCell(Text(project.bewertung.toString() + '%')),
                            DataCell(Text(project.dueDate)),
                            DataCell(Text(project.status)),
                            DataCell(IconButton(
                              color: Colors.blue,
                              icon: Icon(Icons.edit),
                              onPressed: () => projectForecastDialog(context,
                                  projectId: project.id),
                            )),
                          ],
                        ))
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
