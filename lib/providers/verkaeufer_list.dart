import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './verkaeufer.dart';

String dummyData = '[{"medium": "TV", "brand": "Nick", "goal": 600000, "offen": 500000, "gebucht": 5000}, {"medium": "TV", "brand": "MTV", "goal": 800000, "offen": 500000, "gebucht": 10000}]';

class VerkaeuferList with ChangeNotifier {
  List<Verkaeufer> _items = [];

  final String authToken;

  VerkaeuferList(this.authToken, this._items);

  List<Verkaeufer> get items {
    return [..._items];
  }

  Verkaeufer get selectedVerkaufer {
    if (_items.isNotEmpty) {
      return _items.firstWhere((verkaeufer) => verkaeufer.selected == true);
    }
  }

  Verkaeufer findByEmail(String email) {
    return _items.firstWhere((verkaeufer) => verkaeufer.email == email);
  }

  void selectVerkaeuferByEmail(String email) {
    _items.forEach((verkaeufer) {
      if (verkaeufer.email == email) {
        verkaeufer.selected = true;
      } else {
        verkaeufer.selected = false;
      }
    });
    notifyListeners();
  }

  Future<void> fetchAndSetVerkaeuferList() async {
    var url = 'http://hammbwdsc02:96/api/verkaeufer/';
    try {
      final response = await http.get(
        url,
        headers: {"Authorization": "Bearer $authToken"},
      );
      final extractedData = json.decode(utf8.decode(response.bodyBytes) ) as List<dynamic>;
      //final extractedData = json.decode(dummyData) as List<dynamic>;

      if (extractedData == null) {
        return;
      }
      final List<Verkaeufer> loadedVerkaeuferList = [];
      extractedData.forEach((verkaeufer) {
        if (verkaeufer['status'] == 'AKTIV') {
          loadedVerkaeuferList.add(
            Verkaeufer(
              name: verkaeufer['name_advendio'],
              email: verkaeufer['email'],
              selected: true, //verkaeufer['is_current_user'],
              isCurrentUser: false, //verkaeufer['is_current_user'],
            ),
          );
        }
      });
      _items = loadedVerkaeuferList;

      notifyListeners();

    } catch (error) {
      throw (error);
    }
  }
}
