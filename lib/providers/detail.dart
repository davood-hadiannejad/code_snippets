import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../main.dart';

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
  num naturalRabatt;
  num globalRate;
  num cashRabatt;
  List<dynamic> subType;

  List<dynamic> globalBrands;
  List<String> filterBrandList = [];
  String mediumFilter;

  Detail(
    this.authToken,
    this.name,
  );

  Future<void> resetFilter() async {
    globalBrands = null;
    filterBrandList = [];
    mediumFilter = '';
  }

  Future<void> filterByBrandList(List<String> currentFilterBrandList) async {
    filterBrandList = globalBrands
        .where((brand) =>
        currentFilterBrandList.contains(brand['name'].toString()))
        .map((e) => e['name_slug'].toString()).toList();
    notifyListeners();
  }

  Future<void> filterByMedium(String currentMediumFilter) async {
    mediumFilter = currentMediumFilter;
    notifyListeners();
  }

  Future<void> fetchAndSetDetail(String kind, String id,
      {init = false, Verkaeufer verkaeufer}) async {
    var searchType = kind.toLowerCase();
    var subTypeUri;
    Map<String, String> uriQuery = {};

    if (verkaeufer != null && verkaeufer.email != null) {
      uriQuery['email'] = verkaeufer.email;
    }

    if (mediumFilter != '' && mediumFilter != null) {
      uriQuery['filter_gattung'] = mediumFilter;
    }

    if (filterBrandList.isNotEmpty) {
      uriQuery['brand'] = filterBrandList.join('+');
    }

    var uri =
        Uri.http(APIHOST, '/api/detail/$searchType/$id/', uriQuery);
    if (searchType == 'agentur' ||
        searchType == 'konzern' ||
        searchType == 'agenturnetzwerk') {
      subTypeUri =
          Uri.http(APIHOST, '/api/subtype/$searchType/$id/', uriQuery);
      print(subTypeUri);
    }
    print(uri);

    try {
      final response = await http.get(
        uri,
        headers: {"Authorization": "Bearer $authToken"},
      );
      final extractedData =
          json.decode(utf8.decode(response.bodyBytes)) as dynamic;
      if (extractedData == null) {
        return;
      }
      name = extractedData['name'];
      goalGesamt = extractedData['goal_gesamt'];
      istStichtagGesamt = extractedData['ist_stichtag_gesamt'];
      kundenForecastGesamt = extractedData['kunden_forecast_gesamt'];
      projektForecastGesamt = extractedData['projekt_forecast_gesamt'];
      if (init) {
        globalBrands = extractedData['brands'];
      }
      brands = extractedData['brands'];
      customers = extractedData['customers'];
      projects = extractedData['projects'];
      tv = extractedData['TV'];
      online = extractedData['ONLINE'];
      naturalRabatt = extractedData['natural_rabatt_gesamt'];
      cashRabatt = extractedData['cash_rabatt_gesamt'];
      globalRate = extractedData['global_rate_gesamt'];

      if (subTypeUri != null) {
        final response = await http.get(
          subTypeUri,
          headers: {"Authorization": "Bearer $authToken"},
        );
        subType = json.decode(utf8.decode(response.bodyBytes)) as List<dynamic>;
      }

      if (init != true) {
        notifyListeners();
      }
    } catch (error) {
      throw (error);
    }
  }
}
