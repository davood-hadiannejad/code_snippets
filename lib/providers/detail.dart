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
  num naturalRabatt;
  num globalRate;
  num cashRabatt;
  List<dynamic> subType;

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
    var subTypeUri;
    Map<String, String> uriQuery = {};

    if (verkaeufer != null && verkaeufer.email != null) {
      uriQuery['email'] = verkaeufer.email;
    }

    if (medium != null) {
      uriQuery['filter_gattung'] = medium;
    }

    var uri = Uri.http('hammbwdsc02:96', '/api/detail/$searchType/$id/', uriQuery);
    if (searchType == 'agentur' || searchType == 'konzern' || searchType == 'agenturnetzwerk') {
      subTypeUri = Uri.http('hammbwdsc02:96', '/api/subtype/$searchType/$id/', uriQuery);
      print(subTypeUri);
    }
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
        subType = json.decode(utf8.decode(response.bodyBytes) ) as List<dynamic>;
      }

      if (init != true) {
        notifyListeners();
      }
    } catch (error) {
      throw (error);
    }
  }
}
