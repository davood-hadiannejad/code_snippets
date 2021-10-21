import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../main.dart';
import './verkaeufer.dart';
import './commitment.dart';

class CommitmentList with ChangeNotifier {
  List<Commitment> _items = [];
  List<Commitment> _activeItems = [];
  String statusFilter = 'offen';
  String searchString = '';
  List<String> filterBrandList = [];

  final String authToken;

  CommitmentList(this.authToken, this._items);

  List<Commitment> get items {
    return [..._activeItems];
  }

  List<Commitment> sortByField(field, {ascending = false}) {
    if (field == 'mn3') {
      if (ascending) {
        _activeItems.sort((a, b) {
          var aBewertet = a.mn3;
          var bBewertet = b.mn3;
          return bBewertet.compareTo(aBewertet);
        });
      } else {
        _activeItems.sort((a, b) {
          var aBewertet = a.mn3;
          var bBewertet = b.mn3;
          return aBewertet.compareTo(bBewertet);
        });
      }
    } else if (field == 'month_end') {
      if (ascending) {
        _activeItems.sort((a, b) => b.monthEnd.compareTo(a.monthEnd));
      } else {
        _activeItems.sort((a, b) => a.monthEnd.compareTo(b.monthEnd));
      }
    } else if (field == 'month_start') {
      if (ascending) {
        _activeItems.sort((a, b) => b.monthStart.compareTo(a.monthStart));
      } else {
        _activeItems.sort((a, b) => a.monthStart.compareTo(b.monthStart));
      }
    }

    return [..._activeItems];
  }

  Commitment findById(int id) {
    return _items.firstWhere((commitment) => commitment.id == id);
  }

  Future<void> searchByName(String currentSearchString) async {
    searchString = currentSearchString;
    notifyListeners();
  }

  Future<void> filterByStatus(String status) async {
    statusFilter = status;
    notifyListeners();
  }

  Future<void> filterByBrandList(List<String> currentFilterBrandList) async {
    filterBrandList = currentFilterBrandList;
    notifyListeners();
  }

  Future<void> fetchAndSetCommitmentList({
    bool init = false,
    Verkaeufer verkaeufer,
    String year,
    String pageType,
    String id,
  }) async {
    Map<String, String> uriQuery = {};

    if (verkaeufer != null && verkaeufer.email != null) {
      uriQuery['email'] = verkaeufer.email;
    }

    if (year != null) {
      uriQuery['jahr'] = year;
    }

    if (pageType != null && id != null) {
      uriQuery[pageType.toLowerCase()] = id;
    }

    var uri = Uri.http(APIHOST, '/api/commitments/', uriQuery);
    print(uri);
    try {
      final response = await http.get(
        uri,
        headers: {"Authorization": "Bearer $authToken"},
      );
      final extractedData =
          json.decode(utf8.decode(response.bodyBytes)) as List<dynamic>;
      if (extractedData == null) {
        return;
      }
      List<Commitment> loadedCommitmentList = [];
      extractedData.forEach((commitment) {
        loadedCommitmentList.add(
          Commitment(
            id: commitment['id'],
            verkaeufer: commitment['verkaeufer'],
            customer: commitment['kunde'],
            medium: commitment['medium'],
            brand: commitment['brand'],
            umsatzcluster: commitment['umsatzcluster'],
            agentur: commitment['agentur'],
            mn3: commitment['mn3'],
            cashRabatt: commitment['cashRabatt'],
            naturalRabatt: commitment['naturalRabatt'],
            mn3Ist: commitment['mn3_ist'],
            cashRabattIst: commitment['cashRabatt_ist'],
            naturalRabattIst: commitment['naturalRabatt_ist'],
            year: commitment['year'],
            monthStart: commitment['month_start'],
            monthEnd: commitment['month_end'],
            comment: commitment['comment'],
            status: commitment['status'],
          ),
        );
      });
      _items = loadedCommitmentList;

      if (searchString != '') {
        loadedCommitmentList = loadedCommitmentList
            .where((commitment) => commitment.customer
                .toLowerCase()
                .startsWith(searchString.toLowerCase()))
            .toList();
      }
      if (filterBrandList.isNotEmpty) {
        loadedCommitmentList = loadedCommitmentList
            .where((commitment) => filterBrandList.any((item) => commitment.brand.contains(item)))
            .toList();
      }

      _activeItems = loadedCommitmentList
          .where((commitment) => commitment.status == statusFilter)
          .toList();

      if (init != true) {
        notifyListeners();
      }
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addCommitment(
    String customer,
    List<dynamic> medium,
    List<dynamic> brand,
    String agency,
    String verkaueferEmail,
    double mn3,
    double cashRabatt,
    double naturalRabatt,
    List<dynamic> umsatzcluster,
    String comment,
    int monthStart,
    int monthEnd,
    String status,
    String year,
  ) async {
    var url = APIPROTOCOL + APIHOST + '/api/commitments/';
    try {
      Map<String, dynamic> body = {
        'kunde': customer,
        'verkaeufer': verkaueferEmail,
        'medium': medium,
        'brand': brand,
        'agentur': agency,
        'mn3': mn3,
        'cashRabatt': cashRabatt,
        'naturalRabatt': naturalRabatt,
        'umsatzcluster': umsatzcluster,
        'comment': comment,
        'month_start': monthStart,
        'month_end': monthEnd,
        'status': status,
        'year': year,
      };

      final response = await http.post(url,
          headers: {
            "content-type": "application/json",
            "accept": "application/json",
            "Authorization": "Bearer $authToken"
          },
          body: json.encode(body));
      final extractedData =
          json.decode(utf8.decode(response.bodyBytes)) as dynamic;
      _items.add(Commitment(
        id: extractedData['id'],
        verkaeufer: extractedData['verkaeufer'],
        customer: extractedData['kunde'],
        medium: extractedData['medium'],
        brand: extractedData['brand'],
        umsatzcluster: extractedData['umsatzcluster'],
        agentur: extractedData['agentur'],
        mn3: extractedData['mn3'],
        cashRabatt: extractedData['cashRabatt'],
        naturalRabatt: extractedData['naturalRabatt'],
        year: extractedData['year'],
        monthStart: extractedData['month_start'],
        monthEnd: extractedData['month_end'],
        comment: extractedData['comment'],
        status: extractedData['status'],
      ));

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateCommitment(
    int id,
    String customer,
    List<dynamic> medium,
    List<dynamic> brand,
    String agency,
    String verkaueferEmail,
    double mn3,
    double cashRabatt,
    double naturalRabatt,
    List<dynamic> umsatzcluster,
    String comment,
    int monthStart,
    int monthEnd,
    String status,
    String year,
  ) async {
    var url = APIPROTOCOL + APIHOST + '/api/commitments/${id.toString()}/';
    try {
      Map<String, dynamic> body = {
        'id': id,
        'kunde': customer,
        'verkaeufer': verkaueferEmail,
        'medium': medium,
        'brand': brand,
        'agentur': agency,
        'mn3': mn3,
        'cashRabatt': cashRabatt,
        'naturalRabatt': naturalRabatt,
        'umsatzcluster': umsatzcluster,
        'comment': comment,
        'month_start': monthStart,
        'month_end': monthEnd,
        'status': status,
        'year': year,
      };

      final response = await http.put(url,
          headers: {
            "content-type": "application/json",
            "accept": "application/json",
            "Authorization": "Bearer $authToken"
          },
          body: json.encode(body));
      final extractedData =
          json.decode(utf8.decode(response.bodyBytes)) as dynamic;
      _items.removeWhere((commitment) => commitment.id == id);
      print(url);
      _items.add(Commitment(
        id: extractedData['id'],
        verkaeufer: extractedData['verkaeufer'],
        customer: extractedData['kunde'],
        medium: extractedData['medium'],
        brand: extractedData['brand'],
        umsatzcluster: extractedData['umsatzcluster'],
        agentur: extractedData['agentur'],
        mn3: extractedData['mn3'],
        cashRabatt: extractedData['cashRabatt'],
        naturalRabatt: extractedData['naturalRabatt'],
        year: extractedData['year'],
        monthStart: extractedData['month_start'],
        monthEnd: extractedData['month_end'],
        comment: extractedData['comment'],
        status: extractedData['status'],
      ));

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
