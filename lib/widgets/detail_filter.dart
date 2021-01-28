import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './select_menu.dart';
import '../providers/detail.dart';
import '../providers/verkaeufer.dart';

class DetailFilter extends StatefulWidget {
  final String pageType;
  final String detailId;
  final Verkaeufer selectedUser;
  final String selectedYear;
  List<String> brandList;
  List<String> customerList;

  DetailFilter(
      this.pageType, this.detailId, this.selectedUser, this.selectedYear,
      {this.brandList, this.customerList});

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
              (widget.brandList != null)
                  ? Center(
                      child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: SelectMenu(
                        'detail',
                        widget.brandList,
                        'Brand',
                        pageType: widget.pageType,
                        detailId: widget.detailId,
                        selectedUser: widget.selectedUser,
                        selectedYear: widget.selectedYear,
                      ),
                    ))
                  : SizedBox(
                      height: 1,
                    ),
              (widget.customerList != null)
                  ? Center(
                      child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: SelectMenu(
                        'detail',
                        widget.customerList,
                        'Kunde',
                        pageType: widget.pageType,
                        detailId: widget.detailId,
                        selectedUser: widget.selectedUser,
                        selectedYear: widget.selectedYear,
                      ),
                    ))
                  : SizedBox(
                      height: 1,
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
                            .filterByMedium(null);
                        Provider.of<Detail>(context, listen: false)
                            .fetchAndSetDetail(widget.pageType, widget.detailId,
                                verkaeufer: widget.selectedUser, year: widget.selectedYear);
                      });
                    }
                  },
                  child: Text(
                    'Gesamt',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ),
              SizedBox(
                height: 5,
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
                            .filterByMedium(isSelected);
                        Provider.of<Detail>(context, listen: false)
                            .fetchAndSetDetail(widget.pageType, widget.detailId,
                                verkaeufer: widget.selectedUser, year: widget.selectedYear);
                      });
                    }
                  },
                  child: Text(
                    'TV',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ),
              SizedBox(
                height: 5,
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
                            .filterByMedium(isSelected);
                        Provider.of<Detail>(context, listen: false)
                            .fetchAndSetDetail(widget.pageType, widget.detailId,
                                verkaeufer: widget.selectedUser, year: widget.selectedYear);
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
