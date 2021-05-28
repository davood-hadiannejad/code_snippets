import 'dart:convert';
import 'package:latinize/latinize.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../main.dart';
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

  Customer findByName(String name) {
    return _items.firstWhere((customer) => customer.name == name);
  }

  Future<void> fetchAndSetCustomerList({bool init = false}) async {
    var url = APIPROTOCOL + APIHOST + '/api/kunden/';

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
            agenturen: customer['agentur'].cast<String>(),
          ),
        );
      });
      loadedCustomerList.sort((a, b) => latinize(a.name).compareTo(latinize(b.name)));
      _items = loadedCustomerList;

      if (init != true) {
        notifyListeners();
      }
    } catch (error) {
      throw (error);
    }
  }
}
