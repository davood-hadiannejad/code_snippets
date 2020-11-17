import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';
import './summary.dart';


class SummaryList with ChangeNotifier {
  List<Summary> _items = [];
  List<Summary> _activeItems = [];


  final String authToken;

  SummaryList(this.authToken, this._items);

  List<Summary> get items {
    return [..._activeItems];
  }

  Summary findById(String id) {
    return _items.firstWhere((summary) => summary.id == id);
  }

  Future<void> searchByName(String searchString) async {
    _activeItems = _items.where((summary) => summary.name.toLowerCase().startsWith(searchString.toLowerCase())).toList();
    notifyListeners();
  }

  Future<void> fetchAndSetSummaryList(String kind, {bool init=false}) async {
    var searchType = kind.toLowerCase();
    var url = 'http://hammbwdsc02:96/api/dashboard/$searchType/?email=magdalena.idziak@visoon.de';
    try {
      final response = await http.get(
        url,
        headers: {"Authorization": "Bearer $authToken"},
      );
      final extractedData = json.decode(response.body) as List<dynamic>;

      if (extractedData == null) {
        return;
      }
      print(kind + ': loading Dashboard items...');
      final List<Summary> loadedSummaryList = [];
      extractedData.forEach((summary) {
        loadedSummaryList.add(
          Summary(
            id: summary['name_slug'],
            name: summary['name'],
            stichtag: summary['ist_stichtag'],
            forecast: summary['forecast'],
            gobalrate: summary['gobalrate'],
            goal: summary['goal'],
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
