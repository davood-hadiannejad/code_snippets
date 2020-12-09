import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/project_forecast_item.dart';
import '../providers/project_list.dart';
import '../widgets/project_forecast_side_item.dart';
import '../widgets/user_select.dart';
import '../providers/auth.dart';
import '../widgets/main_drawer.dart';
import '../providers/verkaeufer.dart';
import '../providers/verkaeufer_list.dart';


class ProjectForecastScreen extends StatelessWidget {
  static const routeName = '/project-forecast';
  Verkaeufer selectedVerkaufer;

  @override
  Widget build(BuildContext context) {
    selectedVerkaufer = Provider.of<VerkaeuferList>(context).selectedVerkaufer;
    final Map<String, String> args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        title: Text('Projektforecast'),
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
              future: Provider.of<ProjectList>(context)
                  .fetchAndSetProjectList(init: true, verkaeufer: selectedVerkaufer),
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
                        width: 1350,
                        child: Center(
                          child: Text(
                              'Es ist ein Fehler aufgetreten! Bitte überprüfe deine Netzwerkverbidung...'),
                        ));
                  } else {
                    return Container(
                      width: 1350,
                      child: Consumer<ProjectList>(
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
