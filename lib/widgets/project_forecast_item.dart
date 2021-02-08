import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../providers/project_list.dart';
import './project_forecast_dialog.dart';
import './aob_item.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';

final formatter =
    new NumberFormat.simpleCurrency(locale: 'eu', decimalDigits: 0);
final formatterPercent =
    new NumberFormat.decimalPercentPattern(locale: 'de', decimalDigits: 0);

class ProjectForecastItem extends StatefulWidget {
  final ProjectList forecastData;
  String pageType;
  String pageId;
  String pageName;

  ProjectForecastItem(this.forecastData, {this.pageType, this.pageId, this.pageName});

  @override
  _ProjectForecastItemState createState() => _ProjectForecastItemState();
}

class _ProjectForecastItemState extends State<ProjectForecastItem> {
  int columnSort;
  bool ascSort = false;
  final today = DateTime.now();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
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
              AobItem(pageType: widget.pageType, pageId: widget.pageId),
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
          label: Expanded(
            child: Text(
              'MN3 bewertet',
              textAlign: TextAlign.end,
            ),
          ),
          onSort: (idx, asc) {
            setState(() {
              columnSort = idx;
              ascSort = asc;
              widget.forecastData.sortByField('mb3_bewertet', ascending: asc);
            });
          },
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'Bewertung',
              textAlign: TextAlign.end,
            ),
          ),
          onSort: (idx, asc) {
            setState(() {
              columnSort = idx;
              ascSort = asc;
              widget.forecastData.sortByField('bewertung', ascending: asc);
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
              widget.forecastData.sortByField('dueDate', ascending: asc);
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(formatter
                            .format(project.mn3 * project.bewertung / 100)),
                      ],
                    ),
                  )),
                  DataCell(Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(project.bewertung.toString() + '%'),
                    ],
                  )),
                  DataCell(Row(
                    children: [
                      Text(project.dueDate),
                      SizedBox(
                        width: 5,
                      ),
                      Center(
                          child: CircleAvatar(
                        backgroundColor: (today
                                    .difference(DateTime.parse(project.dueDate))
                                    .inDays <
                                0)
                            ? (today
                                        .difference(
                                            DateTime.parse(project.dueDate))
                                        .inDays <
                                    -7)
                                ? Colors.green
                                : Colors.yellow
                            : Colors.red,
                        radius: 12,
                      )),
                    ],
                  )),
                  DataCell(Text(project.status)),
                  DataCell(IconButton(
                    color: Colors.blue,
                    icon: Icon(Icons.edit),
                    onPressed: () =>
                        projectForecastDialog(context, projectId: project.id),
                  )),
                ],
              ))
          .toList(),
    );
  }
}
