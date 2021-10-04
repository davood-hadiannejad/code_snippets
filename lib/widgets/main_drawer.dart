import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/customer_forecast_screen.dart';
import '../providers/auth.dart';
import '../screens/project_forecast_screen.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            title: Text('Visoon'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.dashboard),
            title: Text('Dashboard'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.people),
            title: Text('Kundenforecast'),
            onTap: () {
              Navigator.of(context)
                  .pushNamed(CustomerForecastScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.remove_red_eye),
            title: Text('Projektforecast'),
            onTap: () {
              Navigator.of(context)
                  .pushNamed(ProjectForecastScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}
