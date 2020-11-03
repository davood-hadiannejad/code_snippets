import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import './brand_select.dart';

class ProjectForecastSideItem extends StatefulWidget {
  @override
  _ProjectForecastSideItemState createState() =>
      _ProjectForecastSideItemState();
}

class _ProjectForecastSideItemState extends State<ProjectForecastSideItem> {
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
              SizedBox(height: 20,),
              Center(
                child: RaisedButton.icon(
                  onPressed: () {},
                  label: Text('Neues Projekt'),
                  icon: Icon(Icons.add),
                ),
              ),
              SizedBox(height: 60,),
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
              Center(child: BrandSelect()),
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