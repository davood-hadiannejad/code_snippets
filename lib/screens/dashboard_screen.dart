import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/dashboard_filter.dart';
import '../widgets/dashboard_item.dart';
import '../widgets/user_select.dart';
import '../providers/auth.dart';
import '../widgets/main_drawer.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        drawer: MainDrawer(),
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(
                text: 'Mandant',
              ),
              Tab(
                text: 'Kunde',
              ),
              Tab(
                text: 'Agentur',
              ),
              Tab(
                text: 'Konzern',
              ),
              Tab(
                text: 'Brand',
              ),
              Tab(
                text: 'Agenturnetzwerk',
              )
            ],
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
          scrollDirection: Axis.horizontal, child: (Row(
          children: [
            Container(
              width: 1250,
              child: ListView(
                children: [
                  DashboardItem(),
                  DashboardItem(),
                  DashboardItem(),
                ],
              ),
            ),
            DashboardFilter(),
          ],
        )),),
      ),
    );
  }
}
