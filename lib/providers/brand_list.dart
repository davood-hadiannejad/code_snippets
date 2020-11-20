import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:visoonfrontend/providers/verkaeufer.dart';

import './brand.dart';

String dummyData =
    '[{"medium": "TV", "brand": "Nick", "goal": 600000, "offen": 500000, "gebucht": 5000}, {"medium": "TV", "brand": "MTV", "goal": 800000, "offen": 500000, "gebucht": 10000}]';

class BrandList with ChangeNotifier {
  List<Brand> _items = [];

  final String authToken;

  BrandList(this.authToken, this._items);

  List<Brand> get items {
    return [..._items];
  }

  Future<void> fetchAndSetBrandList(
      {bool init = false, Verkaeufer verkaeufer}) async {
    var url = 'http://hammbwdsc02:96/api/brands/';

    if (verkaeufer != null) {
      url = url + '?email=' + verkaeufer.email;
    }

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
      final List<Brand> loadedBrandList = [];
      extractedData.forEach((brand) {
        loadedBrandList.add(
          Brand(
            name: brand['name'],
            slug: brand['name_slug'],
          ),
        );
      });
      _items = loadedBrandList;

      if (init != true) {
        notifyListeners();
      }
    } catch (error) {
      throw (error);
    }
  }
}
