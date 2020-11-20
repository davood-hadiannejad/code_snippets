import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/material.dart';

import '../providers/project_list.dart';
import '../providers/project.dart';
import '../providers/brand_list.dart';

final formatter = new NumberFormat.currency(locale: 'eu', decimalDigits: 0);

class ProjectForecastForm extends StatefulWidget {
  final int projectId;

  ProjectForecastForm({this.projectId});

  @override
  _ProjectForecastFormState createState() => _ProjectForecastFormState();
}

class _ProjectForecastFormState extends State<ProjectForecastForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  DateTime _fromDate = DateTime.now();
  String customerDropdownValue;
  String agencyDropdownValue;
  String brandDropdownValue;
  String mediumDropdownValue;
  String bewertungDropdownValue;
  String statusDropdownValue;
  List<String> brandDropdownList = [];

  int mN3;
  int cashRabattPercent;
  int naturalRabattPercent;
  var _cashRabattPercentController = TextEditingController();
  var _naturalRabattPercentController = TextEditingController();
  var _projectNameController = TextEditingController();
  var _commentController = TextEditingController();
  var _mN3Controller = TextEditingController();
  var _neukundeController = TextEditingController();
  var _dateController = TextEditingController();
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

  _addMN3() {
    setState(() {
      if (_mN3Controller.text != '') {
        mN3 = num.parse(_mN3Controller.text);
      } else {
        mN3 = null;
      }
    });
  }

  _addcashRabattPercent() {
    setState(() {
      if (_cashRabattPercentController.text != '') {
        cashRabattPercent = num.parse(_cashRabattPercentController.text);
      } else {
        cashRabattPercent = null;
      }
    });
  }

  _addnaturalRabattPercent() {
    setState(() {
      if (_naturalRabattPercentController.text != '') {
        naturalRabattPercent = num.parse(_naturalRabattPercentController.text);
      } else {
        naturalRabattPercent = null;
      }
    });
  }

  @override
  void dispose() {
    _cashRabattPercentController.dispose();
    _naturalRabattPercentController.dispose();
    _mN3Controller.dispose();
    _dateController.dispose();
    _neukundeController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    brandDropdownList = (Provider.of<BrandList>(context).items.isNotEmpty) ? Provider.of<BrandList>(context).items.map((e) => e.name).toList() : [];
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    Provider.of<BrandList>(context, listen: false).fetchAndSetBrandList();
    _mN3Controller.addListener(_addMN3);
    _cashRabattPercentController.addListener(_addcashRabattPercent);
    _naturalRabattPercentController.addListener(_addnaturalRabattPercent);
    if (widget.projectId != null) {
      Project project = Provider.of<ProjectList>(context, listen: false)
          .findById(widget.projectId);
      _mN3Controller.text = project.mn3.toString();
      _naturalRabattPercentController.text = project.naturalRabatt.toString();
      _cashRabattPercentController.text = project.cashRabatt.toString();
      _projectNameController.text = project.name;
      _commentController.text = project.comment;
      _dateController.text = project.dueDate;
      bewertungDropdownValue = project.bewertung.toString();

      customerDropdownValue = project.customer.toString();
      agencyDropdownValue = project.agency.toString();
      brandDropdownValue = project.brand.toString();
      mediumDropdownValue = project.medium.toString();
      statusDropdownValue = project.status.toString();
    }
  }

  bool enableNeukunde = false;

  Future<void> _showDatePicker() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _fromDate,
      firstDate: DateTime(2015, 1),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _fromDate) {
      setState(() {
        _fromDate = picked;
        initializeDateFormatting();
        var df = DateFormat('yyyy-MM-dd');
        _dateController.text = df.format(picked);
      });
    }
  }

  void _showStatusInfoDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Definition Wahrscheinlichkeits Bewertung'),
        content: Container(
          height: 440,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Container(
                width: 680,
                child: Table(
                  columnWidths: {
                    0: FixedColumnWidth(200.0),
                    1: FixedColumnWidth(480.0)
                  },
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  border: TableBorder.all(color: Colors.grey, width: 1),
                  children: [
                    TableRow(children: [
                      TableCell(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Wahrscheinlichkeitsfaktor in %',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      )),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Wahrscheinlichkeitsbewertung (Definition)',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ]),
                    TableRow(children: [
                      TableCell(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '100 % = Umsatz',
                        ),
                      )),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('- Auftrag ist verbindlich bei Visoon'),
                              Text('- Ggf. Boniprüfung O.K.'),
                            ],
                          ),
                        ),
                      ),
                    ]),
                    TableRow(
                      children: [
                        TableCell(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '90 %',
                          ),
                        )),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('- Auftrag mündlich erteilt'),
                                Text('- Aktions- bzw. Projektplan definiert'),
                                Text('- Entscheidungszeitraum: 1 - 2 Wochen'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        TableCell(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '75 %',
                          ),
                        )),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    '- Anschlusstermin/Telefonat beim Entscheider verlief positiv'),
                                Text('- Budget ist für Visoon vorgesehen'),
                                Text('- Wettbewerb wurde ggf. abgelehnt'),
                                Text('- Entscheidungszeitraum: 2 - 4 Wochen'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        TableCell(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '50 %',
                          ),
                        )),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('- Budget vom Kunden ist vorhanden'),
                                Text('- Anschlusstermin beim Entscheider'),
                                Text('- Wettbewerb ist bekannt'),
                                Text('- Entscheidungszeitraum: 4 - 6 Wochen'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Verstanden'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  _submit() {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      setState(() {
        _hasError = true;
      });
      return;
    }

    String inputCustomer = (customerDropdownValue == 'Neukunde')
        ? _neukundeController.text
        : customerDropdownValue;

    if (inputCustomer == null ||
        inputCustomer == '' ||
        mediumDropdownValue == null ||
        brandDropdownValue == null ||
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
      if (widget.projectId != null) {
        // todo update provider
      } else {
        Provider.of<ProjectList>(context, listen: false).addProject(
          _projectNameController.text,
          inputCustomer,
          mediumDropdownValue,
          brandDropdownValue,
          agencyDropdownValue,
          num.parse(_mN3Controller.text),
          num.parse(_cashRabattPercentController.text),
          num.parse(_naturalRabattPercentController.text),
          num.parse(bewertungDropdownValue),
          _commentController.text,
          _dateController.text,
          statusDropdownValue,
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
      // todo reload customer list
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
              Container(
                width: 250,
                child: TextFormField(
                  controller: _projectNameController,
                  decoration: InputDecoration(
                    hintText: 'Projekt Name',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Bitte Projekt Namen eingeben.';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                width: 250,
                child: DropdownButton<String>(
                  value: customerDropdownValue,
                  hint: Text('Bitte Kunde auswählen...'),
                  iconSize: 24,
                  elevation: 16,
                  onChanged: (String newValue) {
                    if (this.mounted) {
                      setState(() {
                        customerDropdownValue = newValue;
                        if (newValue == 'Neukunde') {
                          enableNeukunde = true;
                        } else {
                          enableNeukunde = false;
                        }
                      });
                    }
                  },
                  items: <String>[
                    'dummy_Baum',
                    'Audi',
                    'Mercedes-Benz',
                    'Neukunde',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              enableNeukunde
                  ? Container(
                      width: 250,
                      child: TextField(
                        controller: _neukundeController,
                        enabled: enableNeukunde,
                        onChanged: (text) {
                          //Provider.of<ProjectForecast>(context, listen: false)
                          //    .searchByName(text);
                        },
                        decoration: InputDecoration(
                          hintText: 'Neukunden Name',
                        ),
                      ),
                    )
                  : SizedBox(
                      height: 1,
                    ),
              Container(
                width: 250,
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
                  items: <String>[
                    'Initiative',
                    'Universal McCann',
                    'MEDIAPLUS HAMBURG',
                  ].map<DropdownMenuItem<String>>((String value) {
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
                    width: 200,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  (bewertungDropdownValue != null)
                      ? Container(width: 100, child: Text('Bewertung'))
                      : SizedBox(
                          width: 100,
                        ),
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    width: 100,
                    child: DropdownButton<String>(
                      value: bewertungDropdownValue,
                      hint: Text('Bewertung'),
                      iconSize: 24,
                      elevation: 16,
                      onChanged: (String newValue) {
                        if (this.mounted) {
                          setState(() {
                            bewertungDropdownValue = newValue;
                          });
                        }
                      },
                      items: <String>[
                        '100',
                        '90',
                        '75',
                        '50',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.info_outline),
                    onPressed: _showStatusInfoDialog,
                  )
                ],
              ),
              Container(
                width: 250,
                child: TextFormField(
                  controller: _naturalRabattPercentController,
                  decoration: InputDecoration(
                    hintText: 'Natural Rabatt',
                    helperText: (naturalRabattPercent != null)
                        ? 'Natural Rabatt'
                        : null,
                    suffixText: '%',
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Bitte Cash Rabatt angeben.';
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
                    hintText: 'Cash Rabatt',
                    helperText:
                        (cashRabattPercent != null) ? 'Cash Rabatt' : null,
                    suffixText: '%',
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Bitte Cash Rabatt angeben.';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                width: 250,
                child: TextFormField(
                  controller: _mN3Controller,
                  decoration: InputDecoration(
                    hintText: 'MN 3',
                    helperText: (mN3 != null) ? 'MN 3' : null,
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
              Row(
                children: [
                  Container(
                    width: 150,
                    child: TextFormField(
                      onTap: _showDatePicker,
                      controller: _dateController,
                      readOnly: true,
                      decoration: InputDecoration(
                        hintText: 'Due Date',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Bitte Due Date angeben.';
                        }
                        return null;
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: _showDatePicker,
                  )
                ],
              ),
              Container(
                width: 150,
                child: DropdownButton<String>(
                  hint: Text('Projekt Status'),
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
                    'gebucht',
                    'abgesagt',
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
            ],
          ),
          Container(
            height: 540,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(height: 40),
                Container(
                  width: 250,
                  child: Table(
                    columnWidths: {
                      0: FixedColumnWidth(100.0),
                      1: FixedColumnWidth(150.0)
                    },
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    border: TableBorder.all(color: Colors.grey, width: 1),
                    children: [
                      TableRow(children: [
                        TableCell(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('MB 3'),
                        )),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                (mB3 != null) ? formatter.format(mB3) : ''),
                          ),
                        ),
                      ]),
                      TableRow(children: [
                        TableCell(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Natural Rabatt',
                          ),
                        )),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text((naturalRabatt != null)
                                ? formatter.format(naturalRabatt)
                                : ''),
                          ),
                        ),
                      ]),
                      TableRow(
                        children: [
                          TableCell(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'MB 1',
                            ),
                          )),
                          TableCell(
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text((mB1 != null)
                                    ? formatter.format(mB1)
                                    : '')),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          TableCell(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Cash Rabatt',
                            ),
                          )),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text((cashRabatt != null)
                                  ? formatter.format(cashRabatt)
                                  : ''),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          TableCell(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'MN 3',
                            ),
                          )),
                          TableCell(
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    mN3 != null ? formatter.format(mN3) : '')),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          TableCell(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Global Rate',
                            ),
                          )),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text((globalRate != null)
                                  ? globalRate.toStringAsFixed(1) + '%'
                                  : ''),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          TableCell(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'MN 3 bewertet',
                            ),
                          )),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text((mN3 != null &&
                                      bewertungDropdownValue != null)
                                  ? formatter.format(mN3 *
                                      int.parse(bewertungDropdownValue) /
                                      100)
                                  : ''),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
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
                      child: (widget.projectId != null)
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
    ));
  }
}
