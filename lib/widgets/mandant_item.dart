import 'package:flutter/material.dart';
import 'package:visoonfrontend/providers/summary.dart';
import 'package:visoonfrontend/screens/detail_screen.dart';

import './table_item.dart';
import './monthly_chart.dart';

class MandantItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.all(12.0),
        child: Container(
          padding: const EdgeInsets.all(8.0),
          width: double.infinity,
          height: double.infinity,
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  FlatButton.icon(
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/');
                    },
                    label: Text('Zurück'),
                    icon: Icon(Icons.arrow_back_ios),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Viacom',
                  style: Theme.of(context).textTheme.headline3,
                ),
              ),
              SizedBox(height: 20),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Monatlicher Umsatz',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  Container(
                      width: 1200,
                      height: 300,
                      child: MonthlyChart.withSampleData()),
                ],
              ),
              SizedBox(height: 50),
              Container(
                width: 1200,
                child: TableItem()
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
    );
  }
}
