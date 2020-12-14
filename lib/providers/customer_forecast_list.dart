import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './verkaeufer.dart';
import './customer_forecast.dart';

String dummyData =
    '[{"customer": "Volkswagen", "medium": "TV", "brand": "Nick", "goal": {"m1": 123, "m2": 134}, "ist": {"m1": 123, "m2": 134}, "forecast": {"m1": 123, "m2": 134}, "ist_letztes_jahr": {"m1": 123, "m2": 134}}, '
    '{"customer": "Volkswagen", "medium": "Online", "brand": "Nick", "goal": {"m1": 123, "m2": 134}, "ist": {"m1": 123, "m2": 134}, "forecast": {"m1": 123, "m2": 134}, "ist_letztes_jahr": {"m1": 123, "m2": 134}}]';

class CustomerForecastList with ChangeNotifier {
  List<CustomerForecast> _items = [];
  List<CustomerForecast> _activeItems = [];
  CustomerForecast _addToActiveItems;
  int currentPage = 1;
  int maxPages;
  int maxItemsOnPage = 10;
  final String authToken;

  CustomerForecastList(this.authToken, this._items);

  List<CustomerForecast> get items {
    return [..._activeItems];
  }

  Future<void> changePage(int pageNumber) async {
    currentPage = pageNumber;
    notifyListeners();
  }

  List<CustomerForecast> sortByField(field, {ascending = false}) {
    return [..._activeItems];
  }

  Future<void> searchByName(String searchString) async {
    _activeItems = _items
        .where((customerForecast) => customerForecast.customer
            .toLowerCase()
            .startsWith(searchString.toLowerCase()))
        .toList();
    notifyListeners();
  }

  Future<void> fetchAndSetCustomerForecastList(
      {bool init = false, Verkaeufer verkaeufer, bool refresh = false}) async {
    Map<String, String> uriQuery = {};
    List<CustomerForecast> loadedCustomerForecastList = [];
    if (verkaeufer != null && verkaeufer.email != null) {
      uriQuery['email'] = verkaeufer.email;
    }
    if (_items.isEmpty || refresh) {
    var uri = Uri.http('hammbwdsc02:96', '/api/customer-forecast/', uriQuery);
    print(uri);
    try {
      final response = await http.get(
        uri,
        headers: {"Authorization": "Bearer $authToken"},
      );
      final extractedData = json.decode(response.body) as List<dynamic>;
      //final extractedData = json.decode(dummyData) as List<dynamic>;

      if (extractedData == null) {
        return;
      }
      extractedData.forEach((customerForecast) {
        loadedCustomerForecastList.add(
          CustomerForecast(
            customer: customerForecast['kunde'],
            medium: customerForecast['medium'],
            brand: customerForecast['brand'],
            agentur: customerForecast['agentur'],
            goal: customerForecast['goal'],
            forecast: customerForecast['forecast'],
            ist: customerForecast['ist'],
            istLastYear: customerForecast['ist_letztes_jahr'],
          ),
        );
      });
      _items = loadedCustomerForecastList;
    } catch (error) {
      throw (error);
    }} else {
      loadedCustomerForecastList = [..._items];
    }

    maxPages = (_items.length / maxItemsOnPage).ceil();
    int minItemsPage = currentPage * maxItemsOnPage - maxItemsOnPage;
    int maxItemsPage = currentPage * maxItemsOnPage;
    if (maxItemsPage > _items.length) {
      _activeItems = loadedCustomerForecastList.sublist(minItemsPage);
    } else {
      _activeItems = loadedCustomerForecastList.sublist(minItemsPage, maxItemsPage);
    }


    if (_addToActiveItems != null) {
      _activeItems.insert(0, _addToActiveItems);
    }
    if (init != true) {
      notifyListeners();
    }
  }

  Future<void> newCustomerForecast(customer, medium, brand, agentur) async {
    _addToActiveItems = CustomerForecast(
        customer: customer,
        medium: medium,
        brand: brand,
        agentur: agentur,
        forecast: {
          "m1": 0.0,
          "m2": 0.0,
          "m3": 0.0,
          "m4": 0.0,
          "m5": 0.0,
          "m6": 0.0,
          "m7": 0.0,
          "m8": 0.0,
          "m9": 0.0,
          "m10": 0.0,
          "m11": 0.0,
          "m12": 0.0
        },
        goal: {
          "m1": 0.0,
          "m2": 0.0,
          "m3": 0.0,
          "m4": 0.0,
          "m5": 0.0,
          "m6": 0.0,
          "m7": 0.0,
          "m8": 0.0,
          "m9": 0.0,
          "m10": 0.0,
          "m11": 0.0,
          "m12": 0.0
        },
        ist: {
          "m1": 0.0,
          "m2": 0.0,
          "m3": 0.0,
          "m4": 0.0,
          "m5": 0.0,
          "m6": 0.0,
          "m7": 0.0,
          "m8": 0.0,
          "m9": 0.0,
          "m10": 0.0,
          "m11": 0.0,
          "m12": 0.0
        },
        istLastYear: {
          "m1": 0.0,
          "m2": 0.0,
          "m3": 0.0,
          "m4": 0.0,
          "m5": 0.0,
          "m6": 0.0,
          "m7": 0.0,
          "m8": 0.0,
          "m9": 0.0,
          "m10": 0.0,
          "m11": 0.0,
          "m12": 0.0
        });

    notifyListeners();
  }

  Future<void> addCustomerForecast(
    String customer,
    String medium,
    String brand,
    String agentur,
    int year,
    String verkaeufer,
    Map<dynamic, dynamic> forecast,
  ) async {
    print('update customer forecast');
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer $authToken"
    };
    final msg = jsonEncode({
      'kunde': customer,
      'medium': medium,
      'brand': brand,
      'agentur': agentur,
      'year': year,
      'verkaeufer': verkaeufer,
      'forecast': forecast,
    });
    var url = 'http://hammbwdsc02:96/api/customer-forecast/';
    try {
      final response = await http.post(url, headers: headers, body: msg);
      final extractedData = json.decode(response.body) as dynamic;

      CustomerForecast tempItem = _items.firstWhere((forecast) =>
          forecast.customer == customer &&
          forecast.brand == brand &&
          forecast.medium == medium &&
          forecast.agentur == agentur);
      _items.removeWhere((forecast) =>
          forecast.customer == customer &&
          forecast.brand == brand &&
          forecast.medium == medium &&
          forecast.agentur == agentur);
      _items.add(CustomerForecast(
          customer: customer,
          medium: medium,
          brand: brand,
          agentur: agentur,
          forecast: forecast,
          goal: tempItem.goal,
          ist: tempItem.ist,
          istLastYear: tempItem.istLastYear));

      //notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
