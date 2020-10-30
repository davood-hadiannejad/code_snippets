import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visoonfrontend/widgets/mandant_item.dart';

import '../providers/detail.dart';
import '../widgets/detail_filter.dart';
import '../widgets/dashboard_item.dart';
import '../widgets/user_select.dart';
import '../providers/auth.dart';
import '../widgets/main_drawer.dart';

final tabList = ['Goal und Forecast', 'Detailansicht'];

class DetailScreen extends StatelessWidget {
  static const routeName = '/detail';

  @override
  Widget build(BuildContext context) {
    final Map<String, String> args = ModalRoute.of(context).settings.arguments;
    print(args);
    return DefaultTabController(
      length: tabList.length,
      child: Scaffold(
        drawer: MainDrawer(),
        appBar: AppBar(
          bottom: (args != null && args['pageType'] == 'customer') ? TabBar(
            onTap: (selectedTab) {
              //Provider.of<SummaryList>(context, listen: false).fetchAndSetSummaryList(tabList[selectedTab]);
            },
            tabs: tabList
                .map((e) => Tab(
                      text: e,
                    ))
                .toList(),
          ) : null,
          title: Text('Detailansicht'),
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
                future: Provider.of<Detail>(context, listen: false)
                    .fetchAndSetDetail(init: true),
                builder: (ctx, dataSnapshot) {
                  if (dataSnapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    if (dataSnapshot.error != null) {
                      // ...
                      // Do error handling stuff
                      print(dataSnapshot.error);
                      return Container(
                          width: 1250,
                          child: Center(
                            child: Text(
                                'Es ist ein Fehler aufgetreten! Bitte überprüfe deine Netzwerkverbidung...'),
                          ));
                    } else {
                      return Container(
                        width: 1250,
                        child: Consumer<Detail>(
                          builder: (ctx, detailData, child) => Center(
                            child: MandantItem(),
                          ),
                        ),
                      );
                    }
                  }
                },
              ),
              DetailFilter(),
            ],
          )),
        ),
      ),
    );
  }
}
