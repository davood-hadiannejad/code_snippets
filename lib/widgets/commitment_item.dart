import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:intl/intl.dart';
import '../providers/commitment_list.dart';
import './commitment_dialog.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';

final formatter =
    new NumberFormat.simpleCurrency(locale: 'eu', decimalDigits: 0);
final formatterPercent =
    new NumberFormat.decimalPercentPattern(locale: 'de', decimalDigits: 0);

class CommitmentItem extends StatefulWidget {
  final CommitmentList commitmentData;
  String pageType;
  String pageId;
  String pageName;

  CommitmentItem(this.commitmentData,
      {this.pageType, this.pageId, this.pageName});

  @override
  _CommitmentItemState createState() => _CommitmentItemState();
}

class _CommitmentItemState extends State<CommitmentItem> {
  int columnSort;
  bool ascSort = false;
  final today = DateTime.now();
  int currentMonth = DateTime.now().month;
  final ScrollController _scrollController = ScrollController();

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

  double getCommitmentState(monthStart, monthEnd, currentMonth) {
    double state =
        ((currentMonth - monthStart) + 1) / (monthEnd - monthStart + 1);
    return state;
  }

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
                'Commitment - ACHTUNG NUR TESTUMGEBUNG',
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            Container(
              width: 1650,
              child: buildCommitmentTable(context),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCommitmentTable(BuildContext context) {
    return Container(
      width: 1400,
      height: 750,
      child: DataTable2(
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
              'Kunde / Konzern',
            ),
            numeric: false,
          ),
          DataColumn(
            label: Text(
              'Agentur',
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
            label: Text(
              'Umsatzcluster',
            ),
            numeric: false,
          ),
          DataColumn(
            label: Text(
              'CR',
            ),
            numeric: true,
          ),
          DataColumn(
            label: Text(
              'CR IST',
            ),
            numeric: true,
          ),
          DataColumn(
            label: Text(
              'NR',
            ),
            numeric: true,
          ),
          DataColumn(
            label: Text(
              'NR IST',
            ),
            numeric: true,
          ),
          DataColumn(
            label: Text(
              'MN3',
              textAlign: TextAlign.end,
            ),
            onSort: (idx, asc) {
              setState(() {
                columnSort = idx;
                ascSort = asc;
                widget.commitmentData.sortByField('mn3', ascending: asc);
              });
            },
            numeric: true,
          ),
          DataColumn(
            label: Text(
              'MN3 IST',
              textAlign: TextAlign.end,
            ),
            numeric: true,
          ),
          DataColumn(
            label: Text(
              'Zeitraum',
            ),
            numeric: false,
          ),
          // DataColumn(
          //   label: Text(
          //     'Jahr',
          //   ),
          // ),
          // DataColumn(
          //   label: Text(
          //     'Status',
          //   ),
          // ),
          DataColumn(
            label: Text(
              '',
            ),
            numeric: false,
          ),
        ],
        rows: widget.commitmentData.items
            .map((commitment) => DataRow(
                  cells: <DataCell>[
                    DataCell(
                        (commitment.comment != null && commitment.comment != '')
                            ? Tooltip(
                                message: commitment.comment,
                                waitDuration: Duration(microseconds: 300),
                                child: Text((commitment.customer != null)
                                    ? commitment.customer
                                    : commitment.konzern + ' (Konzern)'))
                            : Text((commitment.customer != null)
                                ? commitment.customer
                                : commitment.konzern + ' (Konzern)')),
                    DataCell(Text(commitment.agentur)),
                    DataCell(Text(commitment.medium
                        .toString()
                        .replaceAll('[', '')
                        .replaceAll(']', ''))),
                    DataCell(Text(commitment.brand
                        .toString()
                        .replaceAll('[', '')
                        .replaceAll(']', ''))),
                    DataCell(Text(commitment.umsatzcluster
                        .toString()
                        .replaceAll('[', '')
                        .replaceAll(']', ''))),
                    DataCell(
                      (commitment.cashRabatt != null)
                          ? Text(formatterPercent
                              .format(commitment.cashRabatt / 100))
                          : Text('-'),
                    ),
                    DataCell(
                      (commitment.cashRabattIst != null)
                          ? Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(formatterPercent
                                      .format(commitment.cashRabattIst / 100)),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Center(
                                      child: Tooltip(
                                    message: 'Delta: ' +
                                        (commitment.cashRabattIst -
                                                commitment.cashRabatt)
                                            .abs()
                                            .toStringAsFixed(1) +
                                        '%',
                                    waitDuration: Duration(microseconds: 300),
                                    child: CircleAvatar(
                                      backgroundColor: ((commitment
                                                          .cashRabattIst -
                                                      commitment.cashRabatt)
                                                  .abs() <
                                              2)
                                          ? ((commitment.cashRabattIst -
                                                          commitment.cashRabatt)
                                                      .abs() <
                                                  1)
                                              ? Colors.green
                                              : Colors.yellow
                                          : Colors.red,
                                      radius: 8,
                                    ),
                                  )),
                                ],
                              ),
                            )
                          : Text('-'),
                    ),
                    DataCell(
                      (commitment.naturalRabatt != null)
                          ? Text(formatterPercent
                              .format(commitment.naturalRabatt / 100))
                          : Text('-'),
                    ),
                    DataCell(
                      (commitment.naturalRabattIst != null)
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                (commitment.naturalRabattIst != null)
                                    ? Text(formatterPercent.format(
                                        commitment.naturalRabattIst / 100))
                                    : Text('-'),
                                SizedBox(
                                  width: 5,
                                ),
                                Center(
                                    child: Tooltip(
                                  message: 'Delta: ' +
                                      (commitment.naturalRabattIst -
                                              commitment.naturalRabatt)
                                          .abs()
                                          .toStringAsFixed(1) +
                                      '%',
                                  waitDuration: Duration(microseconds: 300),
                                  child: CircleAvatar(
                                    backgroundColor: ((commitment
                                                        .naturalRabattIst -
                                                    commitment.naturalRabatt)
                                                .abs() <
                                            2)
                                        ? ((commitment.naturalRabattIst -
                                                        commitment
                                                            .naturalRabatt)
                                                    .abs() <
                                                1)
                                            ? Colors.green
                                            : Colors.yellow
                                        : Colors.red,
                                    radius: 8,
                                  ),
                                )),
                              ],
                            )
                          : Text('-'),
                    ),
                    DataCell(
                      (commitment.mn3 != null)
                          ? Text(formatter.format(commitment.mn3))
                          : Text('-'),
                    ),
                    DataCell(
                      (commitment.mn3 != null)
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                (commitment.mn3Ist != null)
                                    ? Text(formatter.format(commitment.mn3Ist))
                                    : Text('-'),
                                SizedBox(
                                  width: 5,
                                ),
                                Center(
                                    child: Tooltip(
                                  message: 'Erwartet: ' +
                                      formatter.format(getCommitmentState(
                                              commitment.monthStart,
                                              commitment.monthEnd,
                                              currentMonth) *
                                          commitment.mn3),
                                  child: CircleAvatar(
                                    backgroundColor: ((getCommitmentState(
                                                    commitment.monthStart,
                                                    commitment.monthEnd,
                                                    currentMonth) *
                                                commitment.mn3 *
                                                0.80) <
                                            commitment.mn3Ist)
                                        ? ((getCommitmentState(
                                                        commitment.monthStart,
                                                        commitment.monthEnd,
                                                        currentMonth) *
                                                    commitment.mn3 *
                                                    0.99) <
                                                commitment.mn3Ist)
                                            ? Colors.green
                                            : Colors.yellow
                                        : Colors.red,
                                    radius: 8,
                                  ),
                                )),
                              ],
                            )
                          : Text('-'),
                    ),
                    DataCell(Text(monthItems[commitment.monthStart - 1] +
                        ' - ' +
                        monthItems[commitment.monthEnd - 1])),
                    // DataCell(Text(commitment.year.toString())),
                    //DataCell(Text(commitment.status)),
                    DataCell(IconButton(
                      color: Colors.blue,
                      icon: Icon(Icons.edit),
                      onPressed: () => commitmentDialog(context,
                          commitmentId: commitment.id),
                    )),
                  ],
                ))
            .toList(),
      ),
    );
  }
}
