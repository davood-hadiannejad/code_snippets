import 'dart:convert';
import 'package:latinize/latinize.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../main.dart';

import './mandant.dart';


class MandantList with ChangeNotifier {
  List<Mandant> _items = [];

  final String authToken;

  MandantList(this.authToken, this._items);

  List<Mandant> get items {
    return [..._items];
  }


  Mandant findByName(String name) {
    return _items.firstWhere((mandant) => mandant.name == name);
  }

  Future<void> fetchAndSetMandantList({bool init = false}) async {
    var url = APIPROTOCOL + APIHOST + '/api/mandanten/';

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
      final List<Mandant> loadedMandantList = [];
      extractedData.forEach((mandant) {
        loadedMandantList.add(
          Mandant(
            name: mandant['name'],
            slug: mandant['name_slug'],
            brands: mandant['brands'],
          ),
        );
      });
      loadedMandantList.sort((a, b) {
        return latinize(a.name).compareTo(latinize(b.name));
      });
      _items = loadedMandantList;

      if (init != true) {
        notifyListeners();
      }
    } catch (error) {
      throw (error);
    }
  }
}
