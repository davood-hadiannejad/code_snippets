import 'dart:convert';

import 'package:flutter/material.dart';

class Year with ChangeNotifier {
  List<String> yearList = ['2020', '2021', '2022'];
  String selectedYear = '2022';

  Year();

  void changeYear(String year) {
    selectedYear = year;
    notifyListeners();
  }
}
