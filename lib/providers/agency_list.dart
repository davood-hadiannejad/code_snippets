import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../main.dart';

import './agency.dart';

String dummyData =
    '[{"medium": "TV", "agency": "Nick", "goal": 600000, "offen": 500000, "gebucht": 5000}, {"medium": "TV", "agency": "MTV", "goal": 800000, "offen": 500000, "gebucht": 10000}]';

class AgencyList with ChangeNotifier {
  List<Agency> _items = [];

  final String authToken;

  AgencyList(this.authToken, this._items);

  List<Agency> get items {
    return [..._items];
  }

  Future<void> fetchAndSetAgencyList({bool init = false}) async {
    var url = APIPROTOCOL + APIHOST + '/api/agenturen/';

    try {
      final response = await http.get(
        url,
        headers: {"Authorization": "Bearer $authToken"},
      );
      final extractedData =
          json.decode(utf8.decode(response.bodyBytes)) as List<dynamic>;
      if (extractedData == null) {
        return;
      }
      final List<Agency> loadedAgencyList = [];
      extractedData.forEach((agency) {
        loadedAgencyList.add(
          Agency(
            name: agency['name'],
            slug: agency['name_slug'],
          ),
        );
      });
      loadedAgencyList.sort((a, b) => a.name.compareTo(b.name));
      _items = loadedAgencyList;

      if (init != true) {
        notifyListeners();
      }
    } catch (error) {
      throw (error);
    }
  }
}
