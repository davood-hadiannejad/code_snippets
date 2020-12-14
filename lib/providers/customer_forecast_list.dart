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
      final List<CustomerForecast> loadedCustomerForecastList = [];
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
      _activeItems = loadedCustomerForecastList.sublist(0, 10);

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
      print(response.body);
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

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
