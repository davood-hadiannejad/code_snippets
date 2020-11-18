import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/verkaeufer.dart';
import '../providers/summary_list.dart';

class DashboardFilter extends StatefulWidget {
  final String activeTab;
  final Verkaeufer selectedUser;
  String isSelected;

  DashboardFilter(this.activeTab, this.selectedUser, this.isSelected);

  @override
  _DashboardFilterState createState() => _DashboardFilterState();
}

class _DashboardFilterState extends State<DashboardFilter> {

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
              Text(
                'Suche & Filter',
                style: Theme.of(context).textTheme.headline5,
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                onChanged: (text) {
                  Provider.of<SummaryList>(context, listen: false)
                      .searchByName(text);
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Suche...',
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Center(
                child: FlatButton(
                  minWidth: 200,
                  color: (widget.isSelected == 'Gesamt')
                      ? Theme.of(context).accentColor
                      : Theme.of(context).primaryColor.withOpacity(0.70),
                  textColor: Colors.white,
                  onPressed: () {
                    if (this.mounted) {
                      setState(() {
                        widget.isSelected = 'Gesamt';
                        Provider.of<SummaryList>(context, listen: false)
                            .fetchAndSetSummaryList(widget.activeTab, verkaeufer: widget.selectedUser);
                      });
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
                  color: (widget.isSelected == 'TV')
                      ? Theme.of(context).accentColor
                      : Theme.of(context).primaryColor.withOpacity(0.70),
                  textColor: Colors.white,
                  onPressed: () {
                    if (this.mounted) {
                      setState(() {
                        widget.isSelected = 'TV';
                        Provider.of<SummaryList>(context, listen: false)
                            .fetchAndSetSummaryList(widget.activeTab, verkaeufer: widget.selectedUser, medium: 'TV');
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
                  color: (widget.isSelected == 'Online')
                      ? Theme.of(context).accentColor
                      : Theme.of(context).primaryColor.withOpacity(0.70),
                  textColor: Colors.white,
                  onPressed: () {
                    if (this.mounted) {
                      setState(() {
                        widget.isSelected = 'Online';
                        Provider.of<SummaryList>(context, listen: false)
                            .fetchAndSetSummaryList(widget.activeTab, verkaeufer: widget.selectedUser, medium: 'Online');
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
