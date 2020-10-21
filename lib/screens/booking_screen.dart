import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../widgets/main_drawer.dart';
import '../widgets/booking_widget.dart';
import '../widgets/dashboard_chart.dart';

class BookingScreen extends StatelessWidget {
  static const routeName = '/booking';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        title: Text('Visoon Forecasting'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<Auth>(context, listen: false).logout();
            },
          )
        ],
      ),
      body: Center(
        child: Container(width: 500, height: 500,child: DashboardChart.withSampleData()),
      ),
    );
  }
}