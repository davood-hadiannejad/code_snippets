import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/customer_forecast_list.dart';
import '../widgets/user_select.dart';
import '../providers/auth.dart';
import '../widgets/main_drawer.dart';
import '../widgets/customer_forecast_side_item.dart';
import '../widgets/customer_forecast_item.dart';
import '../providers/verkaeufer.dart';
import '../providers/verkaeufer_list.dart';
import '../providers/year.dart';
import '../widgets/year_select.dart';

class CustomerForecastScreen extends StatefulWidget {
  static const routeName = '/customer-forecast';

  @override
  _CustomerForecastScreenState createState() => _CustomerForecastScreenState();
}

class _CustomerForecastScreenState extends State<CustomerForecastScreen> {
  late Verkaeufer selectedVerkaufer;
  late String selectedYear;

  @override
  void initState() {
    Provider.of<CustomerForecastList>(context, listen: false).resetItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    selectedVerkaufer = Provider.of<VerkaeuferList>(context).selectedVerkaufer;
    selectedYear = Provider.of<Year>(context).selectedYear;
    final Map<String, String> args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
            'Kundenforecast ${(args != null && args.containsKey('pageName')) ? ' -  ' + args['pageName'] : ''}'),
        actions: <Widget>[
          UserSelect(),
          SizedBox(
            width: 10,
          ),
          YearSelect(
            disable: true,
          ),
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
              future: Provider.of<CustomerForecastList>(context)
                  .fetchAndSetCustomerForecastList(
                init: true,
                verkaeufer: selectedVerkaufer,
                year: selectedYear,
                pageType: (args != null && args.containsKey('pageType'))
                    ? args['pageType']
                    : null,
                id: (args != null && args.containsKey('id'))
                    ? args['id']
                    : null,
              ),
              builder: (ctx, dataSnapshot) {
                if (dataSnapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    width: 1450,
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else {
                  if (dataSnapshot.error != null) {
                    // ...
                    // Do error handling stuff
                    print(dataSnapshot.error);
                    return Container(
                        width: 1450,
                        child: Center(
                          child: Text(
                              'Es ist ein Fehler aufgetreten! Bitte überprüfe deine Netzwerkverbidung...'),
                        ));
                  } else {
                    return Container(
                      width: 1450,
                      child: Consumer<CustomerForecastList>(
                        builder: (ctx, customerForecastData, child) => Center(
                          child: CustomerForecastItem(customerForecastData),
                        ),
                      ),
                    );
                  }
                }
              },
            ),
            CustomerForecastSideItem(selectedVerkaufer),
          ],
        )),
      ),
    );
  }
}
