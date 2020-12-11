import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './select_menu.dart';
import '../providers/agency_list.dart';
import '../providers/brand_list.dart';
import '../providers/customer_list.dart';

class CustomerForecastSideItem extends StatefulWidget {
  @override
  _CustomerForecastSideItemState createState() =>
      _CustomerForecastSideItemState();
}

class _CustomerForecastSideItemState extends State<CustomerForecastSideItem> {
  String isSelected = 'offen';
  List<String> agencyDropdownList = [];
  List<String> brandDropdownList = [];
  List<String> customerDropdownList = [];

  String agencyDropdownValue;
  String customerDropdownValue;
  String brandDropdownValue;
  String mediumDropdownValue;

  @override
  void didChangeDependencies() {
    brandDropdownList =
        Provider.of<BrandList>(context).items.map((e) => e.name).toList();
    customerDropdownList =
        Provider.of<CustomerList>(context).items.map((e) => e.name).toList();
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    Provider.of<BrandList>(context, listen: false).fetchAndSetBrandList();
    Provider.of<CustomerList>(context, listen: false).fetchAndSetCustomerList();
    //Provider.of<AgencyList>(context, listen: false).fetchAndSetAgencyList();
  }

  Future<void> showAddDialog() async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Neuer Forecast'),
            content: Column(
              children: [
                Container(
                  width: 450,
                  child: DropdownButton<String>(
                    value: customerDropdownValue,
                    hint: Text('Bitte Kunde auswählen...'),
                    iconSize: 24,
                    elevation: 16,
                    onChanged: (String newValue) {
                      if (this.mounted) {
                        setState(() {
                          customerDropdownValue = newValue;
                          //agencyDropdownList = Provider.of<CustomerList>(context, listen: false).findByName(customerDropdownValue).agenturen;
                        });
                      }
                    },
                    items: customerDropdownList
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                Container(
                  width: 450,
                  child: DropdownButton<String>(
                    value: agencyDropdownValue,
                    hint: Text('Bitte Agentur auswählen...'),
                    iconSize: 24,
                    elevation: 16,
                    onChanged: (String newValue) {
                      if (this.mounted) {
                        setState(() {
                          agencyDropdownValue = newValue;
                        });
                      }
                    },
                    items: agencyDropdownList.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 100,
                      child: DropdownButton<String>(
                        value: mediumDropdownValue,
                        hint: Text('Medium'),
                        iconSize: 24,
                        elevation: 16,
                        onChanged: (String newValue) {
                          if (this.mounted) {
                            setState(() {
                              mediumDropdownValue = newValue;
                            });
                          }
                        },
                        items: <String>[
                          'TV',
                          'ONLINE',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                      width: 330,
                      child: DropdownButton<String>(
                        value: brandDropdownValue,
                        hint: Text('Brand'),
                        iconSize: 24,
                        elevation: 16,
                        onChanged: (String newValue) {
                          if (this.mounted) {
                            setState(() {
                              brandDropdownValue = newValue;
                            });
                          }
                        },
                        items: brandDropdownList.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              FlatButton(
                child: Text('Speichern'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text('Abbrechen'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

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
                  onPressed: showAddDialog,
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
