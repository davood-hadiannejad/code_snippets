import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:visoonfrontend/providers/verkaeufer.dart';

import './customer.dart';

String dummyData =
    '[{"medium": "TV", "customer": "Nick", "goal": 600000, "offen": 500000, "gebucht": 5000}, {"medium": "TV", "customer": "MTV", "goal": 800000, "offen": 500000, "gebucht": 10000}]';

class CustomerList with ChangeNotifier {
  List<Customer> _items = [];

  final String authToken;

  CustomerList(this.authToken, this._items);

  List<Customer> get items {
    return [..._items];
  }

  Future<void> fetchAndSetCustomerList(
      {bool init = false, Verkaeufer verkaeufer}) async {
    var url = 'http://hammbwdsc02:96/api/kunden/';

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
      final List<Customer> loadedCustomerList = [];
      extractedData.forEach((customer) {
        loadedCustomerList.add(
          Customer(
            name: customer['name'],
            slug: customer['name_slug'],
            konzern: customer['konzern'],
          ),
        );
      });
      loadedCustomerList.sort((a, b) => a.name.compareTo(b.name));
      _items = loadedCustomerList;

      if (init != true) {
        notifyListeners();
      }
    } catch (error) {
      throw (error);
    }
  }
}
