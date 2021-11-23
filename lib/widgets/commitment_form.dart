import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/material.dart';
import 'package:search_choices/search_choices.dart';

import '../providers/agency_list.dart';
import '../providers/konzern_list.dart';
import '../providers/commitment_list.dart';
import '../providers/commitment.dart';
import '../providers/brand_list.dart';
import '../providers/customer_list.dart';
import '../providers/verkaeufer_list.dart';
import '../providers/year.dart';

final formatter =
    new NumberFormat.simpleCurrency(locale: 'eu', decimalDigits: 0);

class CommitmentForm extends StatefulWidget {
  final int commitmentId;

  CommitmentForm({this.commitmentId});

  @override
  _CommitmentFormState createState() => _CommitmentFormState();
}

class _CommitmentFormState extends State<CommitmentForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  String customerDropdownValue;
  String agencyDropdownValue;
  String konzernDropdownValue;
  List<dynamic> brandValues;
  List<dynamic> mediumValues;
  List<dynamic> umsatzclusterValues;

  String statusDropdownValue;
  String kundeOrKonzernDropdownValue = 'Kunde';
  String monthStartDropdownValue;
  String monthEndDropdownValue;

  List<String> brandDropdownList = [];
  List<String> customerDropdownList = [];
  List<String> agencyDropdownList = [];
  List<String> konzernDropdownList = [];
  List<String> agencyDropdownListComplete = [];

  List<int> selectedItemsMedium = [];
  List<int> selectedItemsUmsatzcluster = [];
  List<int> selectedItemsBrand = [];

  String selectedVerkauferEmail;
  String selectedYear;
  List<String> monthItems = [
    'Januar',
    'Februar',
    'März',
    'April',
    'Mai',
    'Juni',
    'Juli',
    'August',
    'September',
    'Oktober',
    'November',
    'Dezember'
  ];

  List<String> umsatzclusterList = [
    "Klassisch (TV)",
    "SoWeFo (TV)",
    "DRTV (TV)",
    "Trade (TV)",
    "ATV (TV)",
    "Klassisch (Online)",
    "3rd-Party (Online)"
  ];

  List<String> mediumList = [
    'TV',
    'ONLINE',
  ];

  List<int> selectedMonth = [];

  int mN3;
  int cashRabattPercent;
  int naturalRabattPercent;
  var _cashRabattPercentController = TextEditingController();
  var _naturalRabattPercentController = TextEditingController();

  var _commentController = TextEditingController();
  var _mN3Controller = TextEditingController();

  num mN2;
  num mN1;
  num cashRabatt;
  num mB1;
  num naturalRabatt;
  num mB3;
  num globalRate;

  bool _isLoading = false;
  bool _hasError = false;
  bool _networkError = false;
  String _errorMessage = '';

  @override
  void dispose() {
    _cashRabattPercentController.dispose();
    _naturalRabattPercentController.dispose();
    _mN3Controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    selectedVerkauferEmail =
        Provider.of<VerkaeuferList>(context).selectedVerkaufer.email;
    selectedYear = Provider.of<Year>(context).selectedYear;
    brandDropdownList =
        Provider.of<BrandList>(context).items.map((e) => e.name).toList();
    customerDropdownList =
        Provider.of<CustomerList>(context).items.map((e) => e.name).toList();

    agencyDropdownList =
        Provider.of<AgencyList>(context).items.map((e) => e.name).toList();
    konzernDropdownList =
        Provider.of<KonzernList>(context).items.map((e) => e.name).toList();
    agencyDropdownListComplete = [...agencyDropdownList];
    if (widget.commitmentId != null) {
      Commitment commitment =
          Provider.of<CommitmentList>(context, listen: false)
              .findById(widget.commitmentId);
      _mN3Controller.text = commitment.mn3.toString();
      _naturalRabattPercentController.text =
          commitment.naturalRabatt.toString();
      _cashRabattPercentController.text = commitment.cashRabatt.toString();

      _commentController.text = commitment.comment;


      agencyDropdownValue = commitment.agentur.toString();

      if (commitment.customer == null) {
        kundeOrKonzernDropdownValue = 'Konzern';
        konzernDropdownValue = commitment.konzern.toString();
      } else {
        customerDropdownValue = commitment.customer.toString();
        kundeOrKonzernDropdownValue = 'Kunde';
      }
      brandValues = commitment.brand;
      mediumValues = commitment.medium;

      umsatzclusterValues = commitment.umsatzcluster;

      selectedItemsUmsatzcluster = commitment.umsatzcluster
          .map((e) => umsatzclusterList.indexOf(e))
          .toList();
      selectedItemsMedium =
          commitment.medium.map((e) => mediumList.indexOf(e)).toList();
      selectedItemsBrand =
          commitment.brand.map((e) => brandDropdownList.indexOf(e)).toList();

      monthStartDropdownValue = monthItems[commitment.monthStart - 1];
      monthEndDropdownValue = monthItems[commitment.monthEnd - 1];

      statusDropdownValue = commitment.status.toString();
    }
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    Provider.of<BrandList>(context, listen: false).fetchAndSetBrandList();
    Provider.of<CustomerList>(context, listen: false).fetchAndSetCustomerList();
    Provider.of<AgencyList>(context, listen: false).fetchAndSetAgencyList();
    Provider.of<KonzernList>(context, listen: false).fetchAndSetKonzernList();

    selectedVerkauferEmail = Provider.of<VerkaeuferList>(context, listen: false)
        .selectedVerkaufer
        .email;
    selectedYear = Provider.of<Year>(context, listen: false).selectedYear;
  }


  _submit() {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      setState(() {
        _hasError = true;
      });
      return;
    }

    if (((customerDropdownValue == null ||
        customerDropdownValue == '')  && (konzernDropdownValue == null ||
        konzernDropdownValue == '')) ||
        mediumValues == null ||
        brandValues == null ||
        agencyDropdownValue == null ||
        statusDropdownValue == null) {
      setState(() {
        _hasError = true;
      });

      return;
    }
    _formKey.currentState.save();

    setState(() {
      _isLoading = true;
      _hasError = false;
    });
    try {
      if (widget.commitmentId != null) {
        Provider.of<CommitmentList>(context, listen: false).updateCommitment(
          widget.commitmentId,
          customerDropdownValue,
          konzernDropdownValue,
          mediumValues,
          brandValues,
          agencyDropdownValue,
          selectedVerkauferEmail,
          num.parse(_mN3Controller.text),
          num.parse(_cashRabattPercentController.text),
          num.parse(_naturalRabattPercentController.text),
          umsatzclusterValues,
          _commentController.text,
          monthItems.indexOf(monthStartDropdownValue) + 1,
          monthItems.indexOf(monthEndDropdownValue) + 1,
          statusDropdownValue,
          selectedYear,
          kundeOrKonzernDropdownValue,
        );
      } else {
        Provider.of<CommitmentList>(context, listen: false).addCommitment(
          customerDropdownValue,
          konzernDropdownValue,
          mediumValues,
          brandValues,
          agencyDropdownValue,
          selectedVerkauferEmail,
          num.parse(_mN3Controller.text),
          num.parse(_cashRabattPercentController.text),
          num.parse(_naturalRabattPercentController.text),
          umsatzclusterValues,
          _commentController.text,
          monthItems.indexOf(monthStartDropdownValue) + 1,
          monthItems.indexOf(monthEndDropdownValue) + 1,
          statusDropdownValue,
          selectedYear,
          kundeOrKonzernDropdownValue,
        );
      }
    } catch (error) {
      setState(() {
        _networkError = true;
      });
    }

    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();

    if (customerDropdownValue == 'Neukunde') {
      Provider.of<CustomerList>(context, listen: false)
          .fetchAndSetCustomerList();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (mN3 != null &&
        cashRabattPercent != null &&
        naturalRabattPercent != null) {
      mN2 = mN3 / 0.99; // wg. 1% Skonto
      mN1 = mN2 / 0.85; // wg. 15% Agenturrabatt
      mB1 = mN1 / (1 - cashRabattPercent / 100);
      cashRabatt = mB1 - mN1;
      mB3 = mB1 * (1 + naturalRabattPercent / 100);
      naturalRabatt = mB3 - mB1;
      globalRate = (1 - (mN3 / mB3)) * 100;
    }

    return SingleChildScrollView(
        child: Form(
      key: _formKey,
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  Container(
                  width: 100,
                  height: 50,
                  child: DropdownButton<String>(
                    value: kundeOrKonzernDropdownValue,
                    iconSize: 24,
                    elevation: 16,
                    onChanged: (String newValue) {
                      if (this.mounted) {
                        setState(() {
                          kundeOrKonzernDropdownValue = newValue;
                        });
                      }
                    },
                    items: <String>[
                      'Kunde',
                      'Konzern',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                  (kundeOrKonzernDropdownValue == 'Kunde') ? Container(
                    width: 350,
                    child: SearchChoices.single(
                      items: customerDropdownList
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      value: customerDropdownValue,
                      hint: Container(
                        child: Text("Bitte Kunde auswählen..."),
                      ),
                      searchHint: "Bitte Kunde auswählen...",
                      onChanged: (String newValue) {
                        if (this.mounted) {
                          setState(() {
                            customerDropdownValue = newValue;
                            //agencyDropdownValue = null;
                          });
                        }
                      },
                      isExpanded: true,
                    ),
                  ) : Container(
                    width: 350,
                    child: SearchChoices.single(
                      items: konzernDropdownList
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      value: konzernDropdownValue,
                      hint: Container(
                        child: Text("Bitte Konzern auswählen..."),
                      ),
                      searchHint: "Bitte Konzern auswählen...",
                      onChanged: (String newValue) {
                        if (this.mounted) {
                          setState(() {
                            konzernDropdownValue = newValue;
                            //agencyDropdownValue = null;
                          });
                        }
                      },
                      isExpanded: true,
                    ),
                  ),
                ],
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
              ),
              Row(
                children: [
                  Container(
                    width: 150,
                    child: SearchChoices.multiple(
                      items: mediumList
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      hint: 'Medium',
                      searchHint: 'Bitte Medium auswählen...',
                      selectedItems: selectedItemsMedium,
                      onChanged: (List<int> values) {
                        if (this.mounted) {
                          setState(() {
                            selectedItemsMedium = values;
                            mediumValues =
                                values.map((e) => mediumList[e]).toList();
                          });
                        }
                      },
                      isExpanded: true,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    width: 330,
                    child: SearchChoices.multiple(
                      items: brandDropdownList
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      hint: 'Brand',
                      searchHint: 'Bitte Brand auswählen...',
                      selectedItems: selectedItemsBrand,
                      onChanged: (List<int> newValues) {
                        if (this.mounted) {
                          setState(() {
                            selectedItemsBrand = newValues;
                            brandValues = newValues
                                .map((e) => brandDropdownList[e])
                                .toList();
                          });
                        }
                      },
                      isExpanded: true,
                    ),
                  ),
                ],
              ),
              Container(
                width: 250,
                child: SearchChoices.multiple(
                  items: umsatzclusterList
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  hint: 'Umsatzcluster',
                  searchHint: 'Bitte Umsatzcluster auswählen...',
                  selectedItems: selectedItemsUmsatzcluster,
                  onChanged: (List<int> newValues) {
                    if (this.mounted) {
                      setState(() {
                        selectedItemsUmsatzcluster = newValues;
                        umsatzclusterValues =
                            newValues.map((e) => umsatzclusterList[e]).toList();
                      });
                    }
                  },
                  isExpanded: true,
                ),
              ),
              Container(
                width: 250,
                child: TextFormField(
                  controller: _mN3Controller,
                  decoration: InputDecoration(
                    hintText: 'MN3',
                    helperText: 'MN3',
                    suffixText: '€',
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Bitte MN3 angeben.';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                width: 250,
                child: TextFormField(
                  controller: _cashRabattPercentController,
                  decoration: InputDecoration(
                    hintText: 'Cash-Rabatt',
                    helperText: 'Cash-Rabatt',
                    suffixText: '%',
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Bitte Cash-Rabatt angeben.';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                width: 250,
                child: TextFormField(
                  controller: _naturalRabattPercentController,
                  decoration: InputDecoration(
                    hintText: 'Naturalrabatt',
                    helperText: 'Naturalrabatt',
                    suffixText: '%',
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Bitte Naturalrabatt angeben.';
                    }
                    return null;
                  },
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 125,
                    child: DropdownButton<String>(
                      hint: Text('Zeitraum von'),
                      disabledHint: Text('Zeitraum von'),
                      value: monthStartDropdownValue,
                      iconSize: 24,
                      elevation: 16,
                      onChanged: (String newValue) {
                        if (this.mounted) {
                          setState(() {
                            monthStartDropdownValue = newValue;
                          });
                        }
                      },
                      items: monthItems
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                  Container(
                    width: 125,
                    child: DropdownButton<String>(
                      hint: Text('bis'),
                      disabledHint: Text('bis'),
                      value: monthEndDropdownValue,
                      iconSize: 24,
                      elevation: 16,
                      onChanged: (String newValue) {
                        if (this.mounted) {
                          setState(() {
                            monthEndDropdownValue = newValue;
                          });
                        }
                      },
                      items: monthItems
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
              Container(
                width: 150,
                child: DropdownButton<String>(
                  hint: Text('Status'),
                  value: statusDropdownValue,
                  iconSize: 24,
                  elevation: 16,
                  onChanged: (String newValue) {
                    if (this.mounted) {
                      setState(() {
                        statusDropdownValue = newValue;
                      });
                    }
                  },
                  items: <String>[
                    'offen',
                    'abgeschlossen',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              Container(
                width: 250,
                height: 70,
                child: TextField(
                  controller: _commentController,
                  decoration: InputDecoration(hintText: 'Kommentar'),
                  minLines: 2,
                  maxLines: 2,
                ),
              ),
              Container(
                height: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(height: 20),
                    _hasError
                        ? Text(
                            'Bitte alle Angaben ausfüllen.',
                            style: TextStyle(color: Colors.red),
                          )
                        : SizedBox(
                            height: 12,
                          ),
                    _networkError
                        ? Text(
                            'Bitte Verbindung prüfen.',
                            style: TextStyle(color: Colors.red),
                          )
                        : SizedBox(
                            height: 12,
                          ),
                    Row(
                      children: [
                        FlatButton(
                          child: const Text('Abbrechen'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        RaisedButton(
                          child: (widget.commitmentId != null)
                              ? const Text('Update')
                              : const Text('Speichern'),
                          onPressed: _submit,
                          color: Theme.of(context).primaryColor,
                          textColor: Colors.white,
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ));
  }
}
