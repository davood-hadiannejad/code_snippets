import 'dart:convert';
import 'package:latinize/latinize.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../main.dart';

import './konzern.dart';


class KonzernList with ChangeNotifier {
  List<Konzern> _items = [];

  final String authToken;

  KonzernList(this.authToken, this._items);

  List<Konzern> get items {
    return [..._items];
  }

  Future<void> fetchAndSetKonzernList({bool init = false}) async {
    var url = APIPROTOCOL + APIHOST + '/api/konzerne/';

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
      final List<Konzern> loadedKonzernList = [];
      extractedData.forEach((konzern) {
        loadedKonzernList.add(
          Konzern(
            name: konzern['name'],
            slug: konzern['name_slug'],
          ),
        );
      });
      loadedKonzernList.sort((a, b) {
        return latinize(a.name).compareTo(latinize(b.name));
      });
      _items = loadedKonzernList;

      if (init != true) {
        notifyListeners();
      }
    } catch (error) {
      throw (error);
    }
  }
}
