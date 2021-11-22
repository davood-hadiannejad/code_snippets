import 'package:data_table_2/data_table_2.dart';
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

  ProjectForecastItem(this.forecastData,
      {this.pageType, this.pageId, this.pageName});

  @override
  _ProjectForecastItemState createState() => _ProjectForecastItemState();
}

class _ProjectForecastItemState extends State<ProjectForecastItem> {
  int columnSort;
  bool ascSort = false;
  final today = DateTime.now();
  ScrollController _scrollController = ScrollController();

  List<String> monthItems = [
    'Jan',
    'Feb',
    'Mär',
    'Apr',
    'Mai',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Okt',
    'Nov',
    'Dez'
  ];

  List<String> monthKeys = [
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

  String _returnFirstMonth(Map<String, num> monthlyMn3) {
    String firstMonth = '';
    String firstMonthKey;
    for (String key in monthlyMn3.keys) {
      if (monthlyMn3[key] != 0 && monthlyMn3[key] != null) {
        firstMonthKey = key;
        break;
      }
    }
    if (firstMonthKey != null) {
      firstMonth = monthItems[monthKeys.indexOf(firstMonthKey)];
    }
    return firstMonth;
  }

  String _returnLastMonth(Map<String, num> monthlyMn3) {
    String lastMonth = '';
    String lastMonthKey;
    for (String key in monthlyMn3.keys.toList().reversed) {
      if (monthlyMn3[key] != 0 && monthlyMn3[key] != null) {
        lastMonthKey = key;
        break;
      }
    }
    if (lastMonthKey != null) {
      lastMonth = monthItems[monthKeys.indexOf(lastMonthKey)];
    }
    return lastMonth;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(12.0),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        width: double.infinity,
        height: double.infinity,
        child: DraggableScrollbar.rrect(
          // alwaysVisibleScrollThumb: true,
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
              (widget.pageType == 'Mandant' ||
                      widget.pageType == 'Brand' ||
                      widget.pageType == 'Agenturnetzwerk' ||
                      widget.pageType == null)
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'AOB Überblick',
                            style: Theme.of(context).textTheme.headline5,
                          ),
                        ),
                        SizedBox(height: 20),
                        AobItem(
                            pageType: widget.pageType, pageId: widget.pageId),
                        SizedBox(height: 50),
                      ],
                    )
                  : SizedBox(height: 1),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Projekte',
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
              buildProjectTable(context),
              SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildProjectTable(BuildContext context) {
    return Container(
      width: 1400,
      height: 400,
      child: DataTable2(
        scrollController: _scrollController,
        columnSpacing: 10,
        horizontalMargin: 30,
        showBottomBorder: true,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black45, width: 5),
        ),
        sortColumnIndex: columnSort,
        sortAscending: ascSort,
        columns: <DataColumn>[
          DataColumn(
            label: Text(
              'Projekt',
            ),
            numeric: false,
          ),
          DataColumn(
            label: Text(
              'Kunde',
            ),
            numeric: false,
          ),
          DataColumn(
            label: Text(
              'Medium',
            ),
            numeric: false,
          ),
          DataColumn(
            label: Text(
              'Brand',
            ),
            numeric: false,
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
            numeric: true,
          ),
          DataColumn(
            label: Expanded(
              child: Text(
                'Zeitraum',
                textAlign: TextAlign.center,
              ),
            ),
            numeric: false,
          ),
          DataColumn(
            label: Expanded(
              child: Text(
                'Bewertung',
                textAlign: TextAlign.center,
              ),
            ),
            onSort: (idx, asc) {
              setState(() {
                columnSort = idx;
                ascSort = asc;
                widget.forecastData.sortByField('bewertung', ascending: asc);
              });
            },
            numeric: true,
          ),
          DataColumn(
            label: Text(
              'Due Date',
              textAlign: TextAlign.center,
            ),
            onSort: (idx, asc) {
              setState(() {
                columnSort = idx;
                ascSort = asc;
                widget.forecastData.sortByField('dueDate', ascending: asc);
              });
            },
            numeric: false,
          ),
          DataColumn(
            label: Text(
              'Status',
            ),
            numeric: false,
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
                    DataCell(Container(
                      width: 110,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text((_returnFirstMonth(project.monthlyMn3) ==
                                  _returnLastMonth(project.monthlyMn3))
                              ? _returnFirstMonth(project.monthlyMn3)
                              : _returnFirstMonth(project.monthlyMn3) +
                                  ' - ' +
                                  _returnLastMonth(project.monthlyMn3)),
                        ],
                      ),
                    )),
                    DataCell(Row(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                                      .difference(
                                          DateTime.parse(project.dueDate))
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
      ),
    );
  }
}
