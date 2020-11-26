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

  final String authToken;

  CustomerForecastList(this.authToken, this._items);

  List<CustomerForecast> get items {
    return [..._activeItems];
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
      {bool init = false, Verkaeufer verkaeufer}) async {
    Map<String, String> uriQuery = {};
    if (verkaeufer != null && verkaeufer.email != null) {
      uriQuery['email'] = verkaeufer.email;
    }

    var uri = Uri.http('hammbwdsc02:96', '/api/customer-forecast/', uriQuery);

    try {
      final response = await http.get(
        uri,
        headers: {"Authorization": "Bearer $authToken"},
      );
      //final extractedData = json.decode(response.body) as List<dynamic>;
      final extractedData = json.decode(dummyData) as List<dynamic>;

      if (extractedData == null) {
        return;
      }
      final List<CustomerForecast> loadedCustomerForecastList = [];
      extractedData.forEach((customerForecast) {
        loadedCustomerForecastList.add(
          CustomerForecast(
            customer: customerForecast['customer'],
            medium: customerForecast['medium'],
            brand: customerForecast['brand'],
            goal: customerForecast['goal'],
            forecast: customerForecast['forecast'],
            ist: customerForecast['ist'],
            istLastYear: customerForecast['ist_letztes_jahr'],
          ),
        );
      });
      _items = loadedCustomerForecastList;
      _activeItems = loadedCustomerForecastList;

      if (init != true) {
        notifyListeners();
      }
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addCustomerForecast(
    String customer,
    String medium,
    String brand,
    Map<dynamic, dynamic> forecast,
  ) async {
    var url = 'http://hammbwdsc02:96/api/CustomerForecasts/';
    try {
      final response = await http.post(url, headers: {
        "Authorization": "Bearer $authToken"
      }, body: {
        'customer': customer,
        'medium': medium,
        'brand': brand,
        'forecast': forecast,
      });
      final extractedData = json.decode(response.body) as dynamic;
      print(response.body);
      CustomerForecast tempItem = _items.firstWhere((forecast) =>
          forecast.customer == customer &&
          forecast.brand == brand &&
          forecast.medium == medium);
      _items.removeWhere((forecast) =>
          forecast.customer == customer &&
          forecast.brand == brand &&
          forecast.medium == medium);
      _items.add(CustomerForecast(
          customer: customer,
          medium: medium,
          brand: brand,
          forecast: forecast,
          goal: tempItem.goal,
          ist: tempItem.ist,
          istLastYear: tempItem.istLastYear));

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
