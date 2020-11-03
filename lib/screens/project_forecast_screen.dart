import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/project_forecast_item.dart';
import '../providers/detail.dart';
import '../widgets/project_forecast_side_item.dart';
import '../widgets/user_select.dart';
import '../providers/auth.dart';
import '../widgets/main_drawer.dart';

class ProjectForecastScreen extends StatelessWidget {
  static const routeName = '/project-forecast';

  @override
  Widget build(BuildContext context) {
    final Map<String, String> args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        title: Text('Projekt Forecast'),
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
                  .fetchAndSetDetail(args['id'], init: true),
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
                              'Es ist ein Fehler aufgetreten! Bitte überprüfe deine Netzwerkverbidung...'),
                        ));
                  } else {
                    return Container(
                      width: 1250,
                      child: Consumer<Detail>(
                        builder: (ctx, forecastData, child) => Center(
                          child: ProjectForecastItem(forecastData),
                        ),
                      ),
                    );
                  }
                }
              },
            ),
            ProjectForecastSideItem(),
          ],
        )),
      ),
    );
  }
}
