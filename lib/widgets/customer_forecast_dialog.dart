import 'package:flutter/material.dart';

import './customer_forecast_form.dart';


Future<void> showAddDialog(context) async {
  return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Neuer Forecast'),
          content: CustomerForecastForm(),
        );
      });
}