import 'package:flutter/material.dart';


import './select_menu.dart';
import 'customer_forecast_dialog.dart';

class CustomerForecastSideItem extends StatefulWidget {
  @override
  _CustomerForecastSideItemState createState() =>
      _CustomerForecastSideItemState();
}

class _CustomerForecastSideItemState extends State<CustomerForecastSideItem> {
  String isSelected = 'offen';

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
                  //Provider.of<SummaryList>(context, listen: false)
                  //    .searchByName(text);
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
                  color: (isSelected == 'offen')
                      ? Theme.of(context).accentColor
                      : Theme.of(context).primaryColor.withOpacity(0.70),
                  textColor: Colors.white,
                  onPressed: () {
                    if (this.mounted) {
                      setState(() {
                        isSelected = 'offen';
                      });
                    }
                  },
                  child: Text(
                    'offene Projekte',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ),
              Center(
                child: FlatButton(
                  minWidth: 200,
                  color: (isSelected == 'gebucht')
                      ? Theme.of(context).accentColor
                      : Theme.of(context).primaryColor.withOpacity(0.70),
                  textColor: Colors.white,
                  onPressed: () {
                    if (this.mounted) {
                      setState(() {
                        isSelected = 'gebucht';
                      });
                    }
                  },
                  child: Text(
                    'gebuchte Projekte',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ),
              Center(
                child: FlatButton(
                  minWidth: 200,
                  color: (isSelected == 'abgesagt')
                      ? Theme.of(context).accentColor
                      : Theme.of(context).primaryColor.withOpacity(0.70),
                  textColor: Colors.white,
                  onPressed: () {
                    if (this.mounted) {
                      setState(() {
                        isSelected = 'abgesagt';
                      });
                    }
                  },
                  child: Text(
                    'abgesagte Projekte',
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
