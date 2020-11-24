import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './verkaeufer.dart';



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

  List<dynamic> activeBrands;
  Detail(
    this.authToken,
    this.name,
  );

  Future<void> filterBrands(List<String> brandsList) async {
    if (brandsList.isEmpty) {
      activeBrands = brands;
    } else {
      activeBrands = brands.where((b) => brandsList.contains(b['name'])).toList();
    }
    notifyListeners();
  }

  Future<void> fetchAndSetDetail(String kind, String id, {init=false, Verkaeufer verkaeufer, String medium}) async {
    var searchType = kind.toLowerCase();
    Map<String, String> uriQuery = {};

    if (verkaeufer != null && verkaeufer.email != null) {
      uriQuery['email'] = verkaeufer.email;
    }

    if (medium != null) {
      uriQuery['filter_gattung'] = medium;
    }

    var uri = Uri.http('hammbwdsc02:96', '/api/detail/$searchType/$id/', uriQuery);

    print(uri);

    try {
      final response = await http.get(
        uri,
        headers: {"Authorization": "Bearer $authToken"},
      );
      final extractedData = json.decode(utf8.decode(response.bodyBytes) ) as dynamic;
      if (extractedData == null) {
        return;
      }

      name = extractedData['name'];
      goalGesamt = extractedData['goal_gesamt'];
      istStichtagGesamt = extractedData['ist_stichtag_gesamt'];
      kundenForecastGesamt = extractedData['kunden_forecast_gesamt'];
      projektForecastGesamt = extractedData['projekt_forecast_gesamt'];
      brands = extractedData['brands'];
      activeBrands = brands;
      customers = extractedData['customers'];
      projects = extractedData['projects'];
      tv = extractedData['tv'];
      online = extractedData['online'];
      print(brands);
      print(init);
      if (init != true) {
        notifyListeners();
      }
    } catch (error) {
      throw (error);
    }
  }
}
