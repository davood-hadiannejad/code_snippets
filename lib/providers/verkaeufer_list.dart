import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../main.dart';
import './verkaeufer.dart';

String dummyData =
    '[{"medium": "TV", "brand": "Nick", "goal": 600000, "offen": 500000, "gebucht": 5000}, {"medium": "TV", "brand": "MTV", "goal": 800000, "offen": 500000, "gebucht": 10000}]';

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

  void selectVerkaeuferByName(String name) {
    _items.forEach((verkaeufer) {
      if (verkaeufer.name == name) {
        verkaeufer.selected = true;
      } else {
        verkaeufer.selected = false;
      }
    });
    notifyListeners();
  }


  Future<void> fetchAndSetVerkaeuferList() async {
    var url = APIPROTOCOL + APIHOST + '/api/verkaeufer/';
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
      final List<Verkaeufer> loadedVerkaeuferList = [Verkaeufer(
        name: 'Gesamt',
        email: null,
        selected: true,
        isCurrentUser: false,
        isGroup: true,
      )];
      extractedData.forEach((verkaeufer) {
        if (verkaeufer['status'] == 'AKTIV') {
          if (verkaeufer['is_current_user']) {
            loadedVerkaeuferList.first.selected = false;
          }
          loadedVerkaeuferList.add(
            Verkaeufer(
              name: verkaeufer['name_advendio'],
              email: verkaeufer['email'],
              selected: verkaeufer['is_current_user'],
              isCurrentUser: verkaeufer['is_current_user'],
              isGroup: verkaeufer['email'].startsWith('gruppe_'),
            ),
          );
        }
      });
      loadedVerkaeuferList.sort((a, b) => a.name.compareTo(b.name));
      loadedVerkaeuferList.sort((a, b) {
        if(b.isGroup) {
          return 1;
        }
        return -1;
      });
      _items = loadedVerkaeuferList;

      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }
}
