import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './brand_select.dart';
import '../providers/detail.dart';
import '../providers/verkaeufer.dart';

class DetailFilter extends StatefulWidget {
  final String pageType;
  final String detailId;
  final Verkaeufer selectedUser;
  DetailFilter(this.pageType, this.detailId, this.selectedUser);

  @override
  _DetailFilterState createState() => _DetailFilterState();
}

class _DetailFilterState extends State<DetailFilter> {
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
              Text(
                'Filter',
                style: Theme.of(context).textTheme.headline5,
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
                  color: (isSelected == 'Gesamt')
                      ? Theme.of(context).accentColor
                      : Theme.of(context).primaryColor.withOpacity(0.70),
                  textColor: Colors.white,
                  onPressed: () {
                    if (this.mounted) {
                      setState(() {
                        isSelected = 'Gesamt';
                        Provider.of<Detail>(context, listen: false)
                            .fetchAndSetDetail(widget.pageType, widget.detailId,
                            init: true, verkaeufer: widget.selectedUser);
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
                  color: (isSelected == 'TV')
                      ? Theme.of(context).accentColor
                      : Theme.of(context).primaryColor.withOpacity(0.70),
                  textColor: Colors.white,
                  onPressed: () {
                    if (this.mounted) {
                      setState(() {
                        isSelected = 'TV';
                        Provider.of<Detail>(context, listen: false)
                            .fetchAndSetDetail(widget.pageType, widget.detailId,
                            init: true, verkaeufer: widget.selectedUser, medium: 'TV');
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
                        Provider.of<Detail>(context, listen: false)
                            .fetchAndSetDetail(widget.pageType, widget.detailId,
                            init: true, verkaeufer: widget.selectedUser, medium: 'Online');
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
