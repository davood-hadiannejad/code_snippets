import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/project_list.dart';
import './select_menu.dart';
import './project_forecast_dialog.dart';
import '../providers/verkaeufer.dart';

class ProjectForecastSideItem extends StatefulWidget {
  final Verkaeufer selectedVerkaeufer;

  ProjectForecastSideItem(this.selectedVerkaeufer);
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
                  onPressed: widget.selectedVerkaeufer.isGroup ? null : ()  => projectForecastDialog(context),
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
                  Provider.of<ProjectList>(context, listen: false).searchByName(text);
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Suche...',
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Center(child: SelectMenu('project-forecast',[], 'Brand')),
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
                        Provider.of<ProjectList>(context,
                            listen: false)
                            .filterByStatus('offen');
                      });
                    }
                  },
                  child: Text(
                    'offene Projekte',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ),
              SizedBox(height: 5,),
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
                        Provider.of<ProjectList>(context,
                            listen: false)
                            .filterByStatus('gebucht');
                      });
                    }
                  },
                  child: Text(
                    'gebuchte Projekte',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ),
              SizedBox(height: 5,),
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
                        Provider.of<ProjectList>(context,
                            listen: false)
                            .filterByStatus('abgesagt');
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
