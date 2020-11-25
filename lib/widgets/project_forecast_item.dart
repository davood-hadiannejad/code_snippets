import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../providers/project_list.dart';
import './project_forecast_dialog.dart';
import './aob_item.dart';

final formatter = new NumberFormat.currency(locale: 'eu', decimalDigits: 0);
final formatterPercent =
new NumberFormat.decimalPercentPattern(locale: 'de', decimalDigits: 0);

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
            AobItem(),
            SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Projekte',
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            Container(
              width: 1350,
              child: buildProjectTable(context),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  DataTable buildProjectTable(BuildContext context) {
    return DataTable(
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
                          DataCell(Container(
                            width: 110,
                            child: Text(
                                formatter.format(project.mn3 * project.bewertung / 100)),
                          )),
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
            );
  }
}
