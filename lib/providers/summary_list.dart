import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';
import './summary.dart';


String dummyDataMandant = '[{"id": 1, "name" : "Viacom", "stichtag" : {"2020": 123.000, "2019": 123.000} , '
    '"forecast" : {"2020": 123.000, "2019": 123.000} , "gobalrate" : {"2020": 123.000, "2019": 123.000}}, '
    '{"id": 2, "name" : "Welt", "stichtag" : {"2020": 123.000, "2019": 123.000} , "forecast" : {"2020": 123.000, "2019": 123.000} , "gobalrate" : {"2020": 123.000, "2019": 123.000}},'
    '{"id": 3, "name" : "Drittanbieter", "stichtag" : {"2020": 123.000, "2019": 123.000} , "forecast" : {"2020": 123.000, "2019": 123.000} , "gobalrate" : {"2020": 123.000, "2019": 123.000}}]';


String dummyData = '[{"id": 1, "name" : "Volkswagen", "stichtag" : {"2020": 123.000, "2019": 123.000} , '
    '"forecast" : {"2020": 123.000, "2019": 123.000} , "gobalrate" : {"2020": 123.000, "2019": 123.000}}, '
    '{"id": 2, "name" : "Audi", "stichtag" : {"2020": 123.000, "2019": 123.000} , "forecast" : {"2020": 123.000, "2019": 123.000} , "gobalrate" : {"2020": 123.000, "2019": 123.000}},'
    '{"id": 3, "name" : "BMW", "stichtag" : {"2020": 123.000, "2019": 123.000} , "forecast" : {"2020": 123.000, "2019": 123.000} , "gobalrate" : {"2020": 123.000, "2019": 123.000}}]';


class SummaryList with ChangeNotifier {
  List<Summary> _items = [];
  List<Summary> _activeItems = [];


  final String authToken;

  SummaryList(this.authToken, this._items);

  List<Summary> get items {
    return [..._activeItems];
  }

  Summary findById(int id) {
    return _items.firstWhere((summary) => summary.id == id);
  }

  Future<void> searchByName(String searchString) async {
    _activeItems = _items.where((summary) => summary.name.toLowerCase().startsWith(searchString.toLowerCase())).toList();
    notifyListeners();
  }

  Future<void> fetchAndSetSummaryList(String kind, {bool init=false}) async {
    var url = '/api/dashboard/$kind/';
    var extractedData;
    try {
//      final response = await http.get(
//        url,
//        headers: {"Authorization": "Bearer $authToken"},
//      );
      //final extractedData = json.decode(response.body) as List<dynamic>;
      if (kind == 'Mandant') {
        extractedData = json.decode(dummyDataMandant) as List<dynamic>;
      } else {
        extractedData = json.decode(dummyData) as List<dynamic>;
      }

      if (extractedData == null) {
        return;
      }
      print(kind + ': loading Dashboard items...');
      final List<Summary> loadedSummaryList = [];
      extractedData.forEach((summary) {
        loadedSummaryList.add(
          Summary(
            id: summary['id'],
            name: summary['name'],
            stichtag: summary['stichtag'],
            forecast: summary['forecast'],
            gobalrate: summary['gobalrate'],
          ),
        );
      });
      _items = loadedSummaryList;
      _activeItems = loadedSummaryList;

      if (init != true) {
        notifyListeners();
      }
    } catch (error) {
      throw (error);
    }
  }
}
