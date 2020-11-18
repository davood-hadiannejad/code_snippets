import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/verkaeufer.dart';
import '../providers/verkaeufer_list.dart';
import '../providers/summary_list.dart';
import '../widgets/dashboard_filter.dart';
import '../widgets/dashboard_item.dart';
import '../widgets/user_select.dart';
import '../providers/auth.dart';
import '../widgets/main_drawer.dart';

final tabList = [
  'Mandant',
  'Kunde',
  'Agentur',
  'Konzern',
  'Brand',
  'Agenturnetzwerk'
];

class DashboardScreen extends StatelessWidget {
  Verkaeufer selectedVerkaufer;
  String activeTab = 'Mandant';

  @override
  Widget build(BuildContext context) {
    selectedVerkaufer = Provider.of<VerkaeuferList>(context).selectedVerkaufer;
    return DefaultTabController(
      length: tabList.length,
      child: Scaffold(
        drawer: MainDrawer(),
        appBar: AppBar(
          bottom: TabBar(
            onTap: (selectedTab) {
              Provider.of<SummaryList>(context, listen: false)
                  .fetchAndSetSummaryList(tabList[selectedTab], verkaeufer: selectedVerkaufer);
              activeTab = tabList[selectedTab];
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
                    .fetchAndSetSummaryList('Mandant', init: true, verkaeufer: selectedVerkaufer),
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
                              ListView.builder(
                                itemCount: summaryData.items.length,
                                itemBuilder: (ctx, i) =>
                                    DashboardItem(
                                        summaryData.items[i], activeTab),
                              ),
                        ),
                      );
                    }
                  }
                },
              ),
              DashboardFilter(),
            ],
          )),
        ),
      ),
    );
  }
}
