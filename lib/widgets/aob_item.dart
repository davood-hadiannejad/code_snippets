import 'dart:ui';

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../providers/aob.dart';
import '../providers/aob_list.dart';
import '../providers/verkaeufer_list.dart';
import '../providers/verkaeufer.dart';
import '../providers/year.dart';

final formatter =
    new NumberFormat.simpleCurrency(locale: 'eu', decimalDigits: 0);

class AobItem extends StatefulWidget {
  String pageType;
  String pageId;

  AobItem({this.pageType, this.pageId});

  @override
  _AobItemState createState() => _AobItemState();
}

class _AobItemState extends State<AobItem> {
  List<AOB> myAobList;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Verkaeufer selectedVerkaufer =
        Provider.of<VerkaeuferList>(context, listen: false).selectedVerkaufer;
    String selectedYear =
        Provider.of<Year>(context, listen: false).selectedYear;
    Provider.of<AOBList>(context, listen: false).fetchAndSetAOBList(
        verkaeufer: selectedVerkaufer,
        year: selectedYear,
        pageType: widget.pageType,
        id: widget.pageId);
  }

  @override
  Widget build(BuildContext context) {
    myAobList = Provider.of<AOBList>(context).items;
    return Container(
      width: 1600,
      height: 400,
      child: DataTable2(
        headingRowColor:
            MaterialStateColor.resolveWith((states) => Colors.black45),
        scrollController: _scrollController,
        columnSpacing: 10,
        horizontalMargin: 30,
        showBottomBorder: true,
        decoration:
            BoxDecoration(border: Border.all(color: Colors.black45, width: 5)),
        // border: TableBorder.symmetric(
        //     outside: BorderSide(width: 2, color: Colors.black12)),
        columns: <DataColumn>[
          DataColumn(
            label: Text(
              'Medium',
              style:
                  TextStyle(fontStyle: FontStyle.italic, color: Colors.white),
            ),
            numeric: false,
          ),
          DataColumn(
            label: Text(
              'Brand',
              style:
                  TextStyle(fontStyle: FontStyle.italic, color: Colors.white),
            ),
            numeric: false,
          ),
          DataColumn(
            label: Text('Agentur',
                style: TextStyle(
                    fontStyle: FontStyle.italic, color: Colors.white)),
            numeric: false,
          ),
          DataColumn(
            label: Container(
              child: Text(
                'Goal (MN3)',
                textAlign: TextAlign.end,
                style:
                    TextStyle(fontStyle: FontStyle.italic, color: Colors.white),
              ),
            ),
            numeric: true,
          ),
          DataColumn(
            label: Container(
              width: 100,
              child: Text(
                'Offene Projekte (MN3 bewertet)',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.end,
                style:
                    TextStyle(fontStyle: FontStyle.italic, color: Colors.white),
              ),
            ),
            numeric: true,
          ),
          DataColumn(
            label: Container(
              width: 100,
              child: Text(
                'Gebuchte Projekte (MN3)',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.end,
                style:
                    TextStyle(fontStyle: FontStyle.italic, color: Colors.white),
              ),
            ),
            numeric: true,
          ),
          DataColumn(
            label: Container(
              child: Text(
                'Differenz',
                textAlign: TextAlign.end,
                style:
                    TextStyle(fontStyle: FontStyle.italic, color: Colors.white),
              ),
            ),
            numeric: true,
          ),
        ],
        rows: myAobList
            .map((aob) => DataRow(cells: [
                  DataCell(Text(aob.medium)),
                  DataCell(Text(aob.brand)),
                  DataCell(Text(aob.agency)),
                  DataCell(Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(formatter.format(aob.goal)),
                    ],
                  )),
                  DataCell(Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(formatter.format(aob.offen)),
                    ],
                  )),
                  DataCell(Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(formatter.format(aob.gebucht)),
                    ],
                  )),
                  DataCell(Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                          formatter.format(aob.goal - aob.offen - aob.gebucht)),
                    ],
                  )),
                ]))
            .toList(),
      ),
    );
  }
}
