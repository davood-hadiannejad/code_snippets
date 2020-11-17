import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class CustomerForecast with ChangeNotifier {
  final String customer;
  final String medium;
  final String brand;
  final Map<dynamic, dynamic> goal;
  final Map<dynamic, dynamic> forecast;
  final Map<dynamic, dynamic> ist;
  final Map<dynamic, dynamic> istLastYear;



  CustomerForecast({
    @required this.customer,
    @required this.medium,
    @required this.brand,
    @required this.goal,
    @required this.forecast,
    @required this.istLastYear,
    @required this.ist,
  });
}
