import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:search_choices/search_choices.dart';

import '../providers/customer_forecast_list.dart';
import '../providers/agency_list.dart';
import '../providers/brand_list.dart';
import '../providers/customer_list.dart';

class CustomerForecastForm extends StatefulWidget {
  @override
  _CustomerForecastFormState createState() => _CustomerForecastFormState();
}

class _CustomerForecastFormState extends State<CustomerForecastForm> {
  List<String> agencyDropdownList = [];
  List<String> brandDropdownList = [];
  List<String> customerDropdownList = [];

  String agencyDropdownValue;
  String customerDropdownValue;
  String brandDropdownValue;
  String mediumDropdownValue;
  bool _hasError = false;

  @override
  void didChangeDependencies() {
    brandDropdownList =
        Provider.of<BrandList>(context).items.map((e) => e.name).toList();
    customerDropdownList =
        Provider.of<CustomerList>(context).items.map((e) => e.name).toList();
    agencyDropdownList =
        Provider.of<AgencyList>(context).items.map((e) => e.name).toList();
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    Provider.of<BrandList>(context, listen: false).fetchAndSetBrandList();
    Provider.of<CustomerList>(context, listen: false).fetchAndSetCustomerList();
    Provider.of<AgencyList>(context, listen: false).fetchAndSetAgencyList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 254,
      child: Column(
        children: [
          Container(
            width: 450,
            child: SearchChoices.single(
              items: customerDropdownList
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              value: customerDropdownValue,
              hint: "Bitte Kunde auswählen...",
              searchHint: "Bitte Kunde auswählen...",
              onChanged: (String newValue) {
                if (this.mounted) {
                  setState(() {
                    customerDropdownValue = newValue;
                    //agencyDropdownValue = null;
                    //agencyDropdownList = Provider.of<CustomerList>(context, listen: false).findByName(customerDropdownValue).agenturen;
                  });
                }
              },
              isExpanded: true,
            ),
            // DropdownButton<String>(
            //   value: customerDropdownValue,
            //   hint: Text('Bitte Kunde auswählen...'),
            //   iconSize: 24,
            //   elevation: 16,
            //   onChanged: (String newValue) {
            //     if (this.mounted) {
            //       setState(() {
            //         customerDropdownValue = newValue;
            //         agencyDropdownValue = null;
            //         agencyDropdownList = Provider.of<CustomerList>(context, listen: false).findByName(customerDropdownValue).agenturen;
            //       });
            //     }
            //   },
            //   items: customerDropdownList
            //       .map<DropdownMenuItem<String>>((String value) {
            //     return DropdownMenuItem<String>(
            //       value: value,
            //       child: Text(value),
            //     );
            //   }).toList(),
            // ),
          ),
          Container(
            width: 450,
            child: SearchChoices.single(
              items: agencyDropdownList
                     .map<DropdownMenuItem<String>>((String value) {
                   return DropdownMenuItem<String>(
                     value: value,
                     child: Text(value),
                   );
                 }).toList(),
              value: agencyDropdownValue,
              hint: 'Bitte Agentur auswählen...',
              searchHint: 'Bitte Agentur auswählen...',
              onChanged: (String newValue) {
                if (this.mounted) {
                  setState(() {
                    agencyDropdownValue = newValue;
                    //agencyDropdownValue = null;
                    //agencyDropdownList = Provider.of<CustomerList>(context, listen: false).findByName(customerDropdownValue).agenturen;
                  });
                }
              },
              isExpanded: true,
            ),
            // DropdownButton<String>(
            //   value: agencyDropdownValue,
            //   hint: Text('Bitte Agentur auswählen...'),
            //   iconSize: 24,
            //   elevation: 16,
            //   onChanged: (String newValue) {
            //     if (this.mounted) {
            //       setState(() {
            //         agencyDropdownValue = newValue;
            //       });
            //     }
            //   },
            //   items: agencyDropdownList
            //       .map<DropdownMenuItem<String>>((String value) {
            //     return DropdownMenuItem<String>(
            //       value: value,
            //       child: Text(value),
            //     );
            //   }).toList(),
            // ),
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
                  items: brandDropdownList
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          _hasError
              ? Text(
                  'Bitte alle Angaben ausfüllen.',
                  style: TextStyle(color: Colors.red),
                )
              : SizedBox(
                  height: 20,
                ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              FlatButton(
                child: const Text('Abbrechen'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              RaisedButton(
                child: const Text('Speichern'),
                onPressed: () {
                  if (brandDropdownValue != null &&
                      mediumDropdownValue != null &&
                      customerDropdownValue != null &&
                      agencyDropdownValue != null) {
                    Provider.of<CustomerForecastList>(context, listen: false)
                        .newCustomerForecast(
                            customerDropdownValue,
                            mediumDropdownValue,
                            brandDropdownValue,
                            agencyDropdownValue);
                    Navigator.of(context).pop();
                  } else {
                    setState(() {
                      _hasError = true;
                    });
                  }
                },
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
              )
            ],
          )
        ],
      ),
    );
  }
}
