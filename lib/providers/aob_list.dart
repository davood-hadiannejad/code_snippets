import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:visoonfrontend/providers/verkaeufer.dart';
import '../main.dart';

import './aob.dart';

String dummyData = '[{"medium": "TV", "brand": "Nick", "goal": 600000, "offen": 500000, "gebucht": 5000}, {"medium": "TV", "brand": "MTV", "goal": 800000, "offen": 500000, "gebucht": 10000}]';

class AOBList with ChangeNotifier {
  List<AOB> _items = [];
  List<AOB> _activeItems = [];
  List<String> filterBrandList = [];
  final String authToken;

  AOBList(this.authToken, this._items);

  List<AOB> get items {
    return [..._activeItems];
  }

  Future<void> filterByBrandList(List<String> currentFilterBrandList) async {
    filterBrandList = currentFilterBrandList;
    notifyListeners();
  }

  Future<void> fetchAndSetAOBList({bool init = false, Verkaeufer verkaeufer}) async {
    var url = APIPROTOCOL + APIHOST + '/api/aob/';

    if (verkaeufer != null) {
      url = url + '?email=' + verkaeufer.email;
    }

    try {
      final response = await http.get(
        url,
        headers: {"Authorization": "Bearer $authToken"},
      );
      final extractedData = json.decode(utf8.decode(response.bodyBytes) ) as List<dynamic>;
      if (extractedData == null) {
        return;
      }
      List<AOB> loadedAOBList = [];
      extractedData.forEach((aob) {
        loadedAOBList.add(
          AOB(
            goal: aob['goal'],
            medium: aob['medium'],
            brand: aob['brand'],
            offen: aob['offen'],
            gebucht: aob['gebucht'],
          ),
        );
      });
      _items = loadedAOBList;

      if (filterBrandList.isNotEmpty) {
        loadedAOBList = loadedAOBList
            .where((aob) => filterBrandList.contains(aob.brand))
            .toList();
      }
      _activeItems = loadedAOBList;

      if (init != true) {
        notifyListeners();
      }
    } catch (error) {
      throw (error);
    }
  }
}
