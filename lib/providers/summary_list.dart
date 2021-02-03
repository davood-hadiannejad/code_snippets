import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../main.dart';
import './verkaeufer.dart';
import './summary.dart';


class SummaryList with ChangeNotifier {
  List<Summary> _items = [];
  List<Summary> _activeItems = [];
  String searchString = '';

  final String authToken;

  SummaryList(this.authToken, this._items);

  List<Summary> get items {
    return [..._activeItems];
  }

  Summary findById(String id) {
    return _items.firstWhere((summary) => summary.id == id);
  }

  Future<void> searchByName(String currentSearchString) async {
    searchString = currentSearchString;
    _activeItems = _items.where((summary) =>
        summary.name.toLowerCase().startsWith(searchString.toLowerCase()))
        .toList();
    notifyListeners();
  }

  Future<void> fetchAndSetSummaryList(String kind,
      {bool init = false, Verkaeufer verkaeufer, String medium, String year}) async {
    var searchType = kind.toLowerCase();
    Map<String, String> uriQuery = {};
    if (verkaeufer != null && verkaeufer.email != null) {
      uriQuery['email'] = verkaeufer.email;
    }

    if (medium != null) {
      uriQuery['filter_gattung'] = medium;
    }

    if (year != null) {
      uriQuery['jahr'] = year;
    }

    var uri = Uri.http(
        APIHOST, '/api/dashboard/$searchType/', uriQuery);

    print(uri);

    try {
      final response = await http.get(
        uri,
        headers: {"Authorization": "Bearer $authToken"},
      );
      final extractedData = json.decode(response.body) as List<dynamic>;

      if (extractedData == null) {
        return;
      }
      print(kind + ': loading Dashboard items...');
      List<Summary> loadedSummaryList = [];
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
      if (searchType == 'mandant') {
        List<String> sortList = ['WELT', 'VIMN', 'VISO', 'DRIT', 'ZEEO'];

        loadedSummaryList.sort((a, b) {
          int aIntex = sortList.indexOf(a.name);
          int bIntex = sortList.indexOf(b.name);
          return aIntex.compareTo(bIntex);
        });
      } else {
        loadedSummaryList.sort((a, b) => a.name.compareTo(b.name));
      }
      _items = loadedSummaryList;

      //if (searchString != '') {
      //  loadedSummaryList = loadedSummaryList.where((summary) =>
      //      summary.name.toLowerCase().startsWith(searchString.toLowerCase()))
      //      .toList();
      //}

      _activeItems = loadedSummaryList;

      if (init != true) {
        notifyListeners();
      }
    } catch (error) {
      throw (error);
    }
  }
}
