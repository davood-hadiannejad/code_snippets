import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';



class Detail with ChangeNotifier {
  final String authToken;
  String name;
  Map<dynamic, dynamic> goalGesamt;
  Map<dynamic, dynamic> istStichtagGesamt;
  Map<dynamic, dynamic> kundenForecastGesamt;
  Map<dynamic, dynamic> projektForecastGesamt;
  List<dynamic> brands;
  List<dynamic> customers;
  List<dynamic> projects;
  List<dynamic> tv;
  List<dynamic> online;

  Detail(
    this.authToken,
    this.name,
  );

  Future<void> fetchAndSetDetail(String kind, String id, {init=false}) async {
    print('load $kind $id');
    var searchType = kind.toLowerCase();
    var url = 'http://127.0.0.1:8002/api/detail/$searchType/$id/?email=magdalena.idziak@visoon.de';
    try {
      final response = await http.get(
        url,
        headers: {"Authorization": "Bearer $authToken"},
      );
      final extractedData = json.decode(response.body) as dynamic;

      if (extractedData == null) {
        return;
      }

      name = extractedData['name'];
      goalGesamt = extractedData['goal_gesamt'];
      istStichtagGesamt = extractedData['ist_stichtag_gesamt'];
      kundenForecastGesamt = extractedData['kunden_forecast_gesamt'];
      projektForecastGesamt = extractedData['projekt_forecast_gesamt'];
      brands = extractedData['brands'];
      customers = extractedData['customers'];
      projects = extractedData['projects'];
      tv = extractedData['tv'];
      online = extractedData['online'];

      if (init != true) {
        notifyListeners();
      }
    } catch (error) {
      throw (error);
    }
  }
}
