import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/material.dart';

final formatter = new NumberFormat.currency(locale: 'eu', decimalDigits: 0);

class ProjectForecastForm extends StatefulWidget {
  ProjectForecastForm({Key key}) : super(key: key);

  @override
  _ProjectForecastFormState createState() => _ProjectForecastFormState();
}

class _ProjectForecastFormState extends State<ProjectForecastForm> {
  DateTime _fromDate = DateTime.now();
  String customerDropdownValue;
  String agencyDropdownValue;
  String brandDropdownValue;
  String mediumDropdownValue;
  String bewertungDropdownValue;
  String statusDropdownValue;

  int mN3;
  int cashRabatt;
  int naturalRabatt;
  var _cashRabattController = TextEditingController();
  var _naturalRabattController = TextEditingController();
  var _mN3Controller = TextEditingController();
  var _dateController = TextEditingController();

  _addMN3() {
    setState(() {
      if (_mN3Controller.text != '') {
        mN3 = num.parse(_mN3Controller.text);
      } else {
        mN3 = null;
      }
    });
  }

  _addCashRabatt() {
    setState(() {
      if (_cashRabattController.text != '') {
        cashRabatt = num.parse(_cashRabattController.text);
      } else {
        cashRabatt = null;
      }
    });
  }

  _addNaturalRabatt() {
    setState(() {
      if (_naturalRabattController.text != '') {
        naturalRabatt = num.parse(_naturalRabattController.text);
      } else {
        naturalRabatt = null;
      }
    });
  }

  @override
  void dispose() {
    _cashRabattController.dispose();
    _naturalRabattController.dispose();
    _mN3Controller.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _mN3Controller.addListener(_addMN3);
    _cashRabattController.addListener(_addCashRabatt);
    _naturalRabattController.addListener(_addNaturalRabatt);
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 250,
              child: TextField(
                onChanged: (text) {
                  //Provider.of<ProjectForecast>(context, listen: false)
                  //    .searchByName(text);
                },
                decoration: InputDecoration(
                  hintText: 'Projekt Name',
                ),
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
                  'Volkswagen',
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
                      'Online',
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
                    items: <String>[
                      'MTV',
                      'NTV',
                    ].map<DropdownMenuItem<String>>((String value) {
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
                (bewertungDropdownValue != null) ? Container(width: 100,child: Text('Bewertung')) : SizedBox(width: 100,),
                SizedBox(width: 20,),
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
              child: TextField(
                controller: _naturalRabattController,
                decoration: InputDecoration(
                  hintText: 'Natural Rabatt',
                  helperText: (naturalRabatt != null) ? 'Natural Rabatt' : null,
                  suffixText: '%',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ),
            Container(
              width: 250,
              child: TextField(
                controller: _cashRabattController,
                decoration: InputDecoration(
                  hintText: 'Cash Rabatt',
                  helperText: (cashRabatt != null) ? 'Cash Rabatt' : null,
                  suffixText: '%',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ),
            Container(
              width: 250,
              child: TextField(
                controller: _mN3Controller,
                decoration: InputDecoration(
                  hintText: 'MN 3',
                  helperText: (mN3 != null) ? 'MN 3' : null,
                  suffixText: '€',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ),
            Row(
              children: [
                Container(
                  width: 150,
                  child: TextField(
                    onTap: _showDatePicker,
                    controller: _dateController,
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: 'Due Date',
                    ),
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
                decoration: InputDecoration(hintText: 'Kommentar'),
                minLines: 2,
                maxLines: 2,
              ),
            ),
          ],
        ),
        Container(
          height: 440,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(height: 20),
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
                          child: Text((mN3 != null &&
                                  cashRabatt != null &&
                                  naturalRabatt != null)
                              ? formatter.format(mN3 +
                                  (mN3 * cashRabatt / 100) +
                                  ((mN3 + (mN3 * cashRabatt / 100)) *
                                      naturalRabatt /
                                      100))
                              : ''),
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
                          child: Text((mN3 != null &&
                                  cashRabatt != null &&
                                  naturalRabatt != null)
                              ? formatter.format(
                                  (mN3 + (mN3 * cashRabatt / 100)) *
                                      naturalRabatt /
                                      100)
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
                              child: Text((mN3 != null && cashRabatt != null)
                                  ? formatter
                                      .format(mN3 + (mN3 * cashRabatt / 100))
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
                            child: Text((mN3 != null && cashRabatt != null)
                                ? formatter.format(mN3 * cashRabatt / 100)
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
                            child: Text((mN3 != null &&
                                    cashRabatt != null &&
                                    naturalRabatt != null)
                                ? ((1 -
                                                (mN3 /
                                                    (mN3 +
                                                        (mN3 *
                                                            cashRabatt /
                                                            100) +
                                                        ((mN3 +
                                                                (mN3 *
                                                                    cashRabatt /
                                                                    100)) *
                                                            naturalRabatt /
                                                            100)))) *
                                            100)
                                        .toInt()
                                        .toString() +
                                    '%'
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
                            child: Text(
                                (mN3 != null && bewertungDropdownValue != null)
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
            ],
          ),
        ),
      ],
    ));
  }
}
