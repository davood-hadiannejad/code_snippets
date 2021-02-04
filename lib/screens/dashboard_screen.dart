import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';

import '../main.dart';
import '../widgets/year_select.dart';
import '../providers/verkaeufer.dart';
import '../providers/verkaeufer_list.dart';
import '../providers/summary_list.dart';
import '../widgets/dashboard_filter.dart';
import '../widgets/dashboard_item.dart';
import '../widgets/user_select.dart';
import '../providers/auth.dart';
import '../providers/year.dart';
import '../widgets/main_drawer.dart';

final tabList = [
  'Mandant',
  'Kunde',
  'Agentur',
  'Konzern',
  'Brand',
  'Agenturnetzwerk'
];

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with RouteAware {
  final ScrollController _scrollController = ScrollController();
  Verkaeufer selectedVerkaufer;
  String selectedYear;
  String activeTab = 'Mandant';
  String isSelected = 'Gesamt';
  String searchText = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void didPopNext() {
    setState(() {
      Provider.of<SummaryList>(context, listen: false)
          .fetchAndSetSummaryList(activeTab, verkaeufer: selectedVerkaufer, year: selectedYear);
    });

  }

  @override
  Widget build(BuildContext context) {
    selectedVerkaufer = Provider.of<VerkaeuferList>(context).selectedVerkaufer;
    selectedYear = Provider.of<Year>(context).selectedYear;
    return DefaultTabController(
      length: tabList.length,
      child: Scaffold(
        drawer: MainDrawer(),
        appBar: AppBar(
          bottom: TabBar(
            onTap: (selectedTab) {
              setState(() {
                activeTab = tabList[selectedTab];
                isSelected = 'Gesamt';
                searchText = '';
              });
              Provider.of<SummaryList>(context, listen: false)
                  .fetchAndSetSummaryList(activeTab, verkaeufer: selectedVerkaufer, year: selectedYear);
            },
            tabs: tabList
                .map((e) =>
                Tab(
                  text: e,
                ))
                .toList(),
          ),
          title: Text('Visoon Forecasting'),
          actions: <Widget>[
            UserSelect(),
            SizedBox(width: 10,),
            YearSelect(),
            SizedBox(
              width: 30,
            ),
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/');
                Provider.of<Auth>(context, listen: false).logout();
              },
            ),
            SizedBox(
              width: 30,
            ),
          ],
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: (Row(
            children: [
              FutureBuilder(
                future: Provider.of<SummaryList>(context, listen: false)
                    .fetchAndSetSummaryList(activeTab, init: true, verkaeufer: selectedVerkaufer, year: selectedYear),
                builder: (ctx, dataSnapshot) {
                  if (dataSnapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      width: 1250,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  } else {
                    if (dataSnapshot.error != null) {
                      // ...
                      // Do error handling stuff
                      print(dataSnapshot.error);
                      return Container(
                          width: 1250,
                          child: Center(
                            child: Text(
                                'Es ist ein Fehler aufgetreten! Bitte überprüfe deine Netzwerkverbidung....'),
                          ));
                    } else {
                      return Container(
                        width: 1250,
                        child: Consumer<SummaryList>(
                          builder: (ctx, summaryData, child) =>
                              DraggableScrollbar.rrect(
                                alwaysVisibleScrollThumb: true,
                                controller: _scrollController,
                                child: ListView.builder(
                                  controller: _scrollController,
                                  itemCount: summaryData.items.length,
                                  itemBuilder: (ctx, i) =>
                                      DashboardItem(
                                          summaryData.items[i], activeTab),
                                ),
                              ),
                        ),
                      );
                    }
                  }
                },
              ),
              DashboardFilter(activeTab, selectedVerkaufer, selectedYear, isSelected, searchText),
            ],
          )),
        ),
      ),
    );
  }
}
