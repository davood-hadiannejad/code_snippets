import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';
import './aob.dart';

String dummyData = '[{"medium": "TV", "brand": "Nick", "goal": 600000, "offen": 500000, "gebucht": 5000}, {"medium": "TV", "brand": "MTV", "goal": 800000, "offen": 500000, "gebucht": 10000}]';

class AOBList with ChangeNotifier {
  List<AOB> _items = [];

  final String authToken;

  AOBList(this.authToken, this._items);

  List<AOB> get items {
    return [..._items];
  }

  Future<void> fetchAndSetAOBList({bool init = false}) async {
    var url = 'http://127.0.0.1:8002/api/aob/';
    try {
      final response = await http.get(
        url,
        headers: {"Authorization": "Bearer $authToken"},
      );
      final extractedData = json.decode(response.body) as List<dynamic>;
      //final extractedData = json.decode(dummyData) as List<dynamic>;

      if (extractedData == null) {
        return;
      }
      final List<AOB> loadedAOBList = [];
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

      if (init != true) {
        notifyListeners();
      }
    } catch (error) {
      throw (error);
    }
  }
}
