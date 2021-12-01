import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../main.dart';
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
  String searchString = '';
  String filterKind = '';
  String sortField = 'kunde';
  int sortColumnIndex = 0;
  bool sortAscending = true;
  List<String> filterBrandList = [];
  final String authToken;

  CustomerForecastList(this.authToken, this._items);

  List<CustomerForecast> get items {
    return [..._activeItems];
  }

  Future<void> resetItems() async {
    _items = [];
    _activeItems = [];
    _addToActiveItems = null;
    currentPage = 1;
    maxPages = null;
    maxItemsOnPage = 2;
    searchString = '';
    filterKind = '';
    sortField = 'kunde';
    sortColumnIndex = 0;
    sortAscending = true;
    filterBrandList = [];
  }

  Future<void> changePage(int pageNumber) async {
    currentPage = pageNumber;
    notifyListeners();
  }

  List<CustomerForecast> sortByField(String field, idx, {ascending = false}) {
    sortField = field;
    sortAscending = ascending;
    sortColumnIndex = idx;
    print("object");
    notifyListeners();
  }

  Future<void> searchByName(String currentSearchString) async {
    currentPage = 1;
    searchString = currentSearchString;
    notifyListeners();
  }

  Future<void> filterByMedium(String currentFilterKind) async {
    currentPage = 1;
    filterKind = currentFilterKind;
    notifyListeners();
  }

  Future<void> filterByBrandList(List<String> currentFilterBrandList) async {
    currentPage = 1;
    filterBrandList = currentFilterBrandList;
    notifyListeners();
  }

  Future<void> fetchAndSetCustomerForecastList(
      {bool init = false,
      Verkaeufer verkaeufer,
      bool refresh = false,
      String pageType,
      String id,
      String year}) async {
    Map<String, String> uriQuery = {};
    List<CustomerForecast> loadedCustomerForecastList = [];
    if (verkaeufer != null && verkaeufer.email != null) {
      uriQuery['email'] = verkaeufer.email;
    }

    if (year != null) {
      uriQuery['jahr'] = year;
    }

    if (pageType != null && id != null) {
      uriQuery[pageType.toLowerCase()] = id;
    }

    if (_items.isEmpty || refresh) {
      var uri = Uri.http(APIHOST, '/api/customer-forecast/', uriQuery);
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
        _addToActiveItems = null;
      } catch (error) {
        throw (error);
      }
    } else {
      loadedCustomerForecastList = [..._items];
    }
    if (searchString != '') {
      loadedCustomerForecastList = [
        ...loadedCustomerForecastList
            .where((customerForecast) => customerForecast.customer
                .toLowerCase()
                .startsWith(searchString.toLowerCase()))
            .toList()
      ];
    }

    if (filterKind != '') {
      loadedCustomerForecastList = [
        ...loadedCustomerForecastList
            .where((customerForecast) => customerForecast.medium == filterKind)
            .toList()
      ];
    }

    if (filterBrandList.isNotEmpty) {
      loadedCustomerForecastList = [
        ...loadedCustomerForecastList
            .where((customerForecast) =>
                filterBrandList.contains(customerForecast.brand))
            .toList()
      ];
    }

    if (sortField != '') {
      if (sortField == 'gesamt') {
        if (sortAscending) {
          loadedCustomerForecastList.sort((a, b) {
            num aForecast =
                a.forecast.entries.map((e) => e.value).reduce((a, b) => a + b);
            num bForecast =
                b.forecast.entries.map((e) => e.value).reduce((a, b) => a + b);
            return aForecast.compareTo(bForecast);
          });
        } else {
          loadedCustomerForecastList.sort((a, b) {
            num aForecast =
                a.forecast.entries.map((e) => e.value).reduce((a, b) => a + b);
            num bForecast =
                b.forecast.entries.map((e) => e.value).reduce((a, b) => a + b);
            return bForecast.compareTo(aForecast);
          });
        }
      } else if (sortField == 'kunde') {
        if (sortAscending) {
          loadedCustomerForecastList
              .sort((a, b) => a.customer.compareTo(b.customer));
        } else {
          loadedCustomerForecastList
              .sort((a, b) => b.customer.compareTo(a.customer));
        }
      } else {
        if (sortAscending) {
          loadedCustomerForecastList.sort((a, b) {
            num aForecast = a.forecast[sortField];
            num bForecast = b.forecast[sortField];
            return bForecast.compareTo(aForecast);
          });
        } else {
          loadedCustomerForecastList.sort((a, b) {
            num aForecast = a.forecast[sortField];
            num bForecast = b.forecast[sortField];
            return aForecast.compareTo(bForecast);
          });
        }
      }
    }

    maxPages = (loadedCustomerForecastList.length / maxItemsOnPage).ceil();
    int minItemsPage = currentPage * maxItemsOnPage - maxItemsOnPage;
    int maxItemsPage = currentPage * maxItemsOnPage;
    if (maxItemsPage >= loadedCustomerForecastList.length - 1) {
      _activeItems = loadedCustomerForecastList.sublist(minItemsPage);
    } else {
      _activeItems =
          loadedCustomerForecastList.sublist(minItemsPage, maxItemsPage);
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
    var url = APIPROTOCOL + APIHOST + '/api/customer-forecast/';
    try {
      final response = await http.post(url, headers: headers, body: msg);
      final extractedData = json.decode(response.body) as dynamic;
    } catch (error) {
      throw error;
    }
  }
}
