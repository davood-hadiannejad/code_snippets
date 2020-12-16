import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/customer_forecast_list.dart';
import './select_menu.dart';
import 'customer_forecast_dialog.dart';

class CustomerForecastSideItem extends StatefulWidget {
  @override
  _CustomerForecastSideItemState createState() =>
      _CustomerForecastSideItemState();
}

class _CustomerForecastSideItemState extends State<CustomerForecastSideItem> {
  String isSelected = 'Gesamt';

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: double.infinity,
      child: Card(
        margin: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 2,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              Center(
                child: RaisedButton.icon(
                  onPressed: () => showAddDialog(context),
                  label: Text('Neuer Forecast'),
                  icon: Icon(Icons.add),
                ),
              ),
              SizedBox(
                height: 60,
              ),
              Text(
                'Suche & Filter',
                style: Theme.of(context).textTheme.headline5,
              ),
              TextField(
                onChanged: (text) {
                  Provider.of<CustomerForecastList>(context, listen: false)
                      .searchByName(text);
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Suche...',
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Center(child: SelectMenu([], 'Brand')),
              SizedBox(
                height: 20,
              ),
              Center(
                child: FlatButton(
                  minWidth: 200,
                  color: (isSelected == 'Gesamt')
                      ? Theme.of(context).accentColor
                      : Theme.of(context).primaryColor.withOpacity(0.70),
                  textColor: Colors.white,
                  onPressed: () {
                    if (this.mounted) {
                      setState(() {
                        isSelected = 'Gesamt';
                      });
                      Provider.of<CustomerForecastList>(context, listen: false)
                          .filterByMedium('');
                    }
                  },
                  child: Text(
                    'Gesamt',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ),
              Center(
                child: FlatButton(
                  minWidth: 200,
                  color: (isSelected == 'TV')
                      ? Theme.of(context).accentColor
                      : Theme.of(context).primaryColor.withOpacity(0.70),
                  textColor: Colors.white,
                  onPressed: () {
                    if (this.mounted) {
                      setState(() {
                        isSelected = 'TV';
                        Provider.of<CustomerForecastList>(context, listen: false)
                            .filterByMedium('TV');
                      });
                    }
                  },
                  child: Text(
                    'TV',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ),
              Center(
                child: FlatButton(
                  minWidth: 200,
                  color: (isSelected == 'Online')
                      ? Theme.of(context).accentColor
                      : Theme.of(context).primaryColor.withOpacity(0.70),
                  textColor: Colors.white,
                  onPressed: () {
                    if (this.mounted) {
                      setState(() {
                        isSelected = 'Online';
                        Provider.of<CustomerForecastList>(context, listen: false)
                            .filterByMedium('ONLINE');
                      });
                    }
                  },
                  child: Text(
                    'Online',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
