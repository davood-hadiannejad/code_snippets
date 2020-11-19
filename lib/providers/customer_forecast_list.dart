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
        .where((customerForecast) =>
            customerForecast.customer.toLowerCase().startsWith(searchString.toLowerCase()))
        .toList();
    notifyListeners();
  }

  Future<void> fetchAndSetCustomerForecastList({bool init = false, Verkaeufer verkaeufer}) async {
    var url =
        'http://hammbwdsc02:96/api/customer-forecast/';

    if (verkaeufer != null) {
      url = url + '?email=' + verkaeufer.email;
    }

    try {
      final response = await http.get(
        url,
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
    String name,
    String customer,
    String medium,
    String brand,
    String agency,
    double mn3,
    double cashRabatt,
    double naturalRabatt,
    int bewertung,
    String comment,
    String dueDate,
    String status,
  ) async {
    var url = 'http://hammbwdsc02:96/api/CustomerForecasts/';
    try {
      final response = await http.post(url, headers: {
        "Authorization": "Bearer $authToken"
      }, body: {
        'name': name,
        'name_slug': name,
        'kunde': customer,
        'verkaeufer': 'magdalena.idziak@visoon.de',
        'medium': medium,
        'brand': brand,
        'agentur': agency,
        'mn3': mn3.toString(),
        'cashRabatt': cashRabatt.toString(),
        'naturalRabatt': naturalRabatt.toString(),
        'bewertung': bewertung.toString(),
        'comment': comment,
        'dueDate': dueDate,
        'status': status,
      });
      final extractedData = json.decode(response.body) as dynamic;
      print(response.body);
      _items.add(CustomerForecast(
        customer: customer,
        medium: medium,
        brand: brand,
      ));

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
